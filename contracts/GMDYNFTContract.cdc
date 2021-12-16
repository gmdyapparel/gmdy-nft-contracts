pub contract GMDYNFTContract {

// event that is emitted when a new collection is created
pub event newCollection(collectionId: UInt64, collectionName: String)

/* This is the contract where we manage the flow of our collections and NFts*/

/* 
Through the contract you can find variables such as Metadata,
 which are no longer a name to refer to the attributes of our NFTs. 
 which could be the url where our images live
*/

// We define this interface purely as a way to allow users
    // They would use this to only expose getIDs
    // and idExists fields in their Collection
    pub resource interface NFTReceiver {

        pub fun deposit(token: @NFT)

        pub fun getIDs(): [UInt64]

        pub fun idExists(id: UInt64): Bool

        pub fun getRefNFT(id: UInt64): &NFT
    }

// We define this interface simply as a way to allow users to
    // to create a banner of the collections with their Name and Metadata
    pub resource Collection: NFTReceiver {

        pub var metadata: {String: AnyStruct}
        pub var ownedNFTs: @{UInt64: NFT}

        init (name: String, metadata: {String: AnyStruct}) {
            self.ownedNFTs <- {}
            self.metadata = metadata
        }

        pub fun deposit(token: @NFT) {
            self.ownedNFTs[token.id] <-! token
        }

        pub fun withdraw(withdrawID: UInt64): @NFT {
            // If the NFT isn't found, the transaction panics and reverts
            let token <- self.ownedNFTs.remove(key: withdrawID)!

            return <-token
        }

        pub fun getRefNFT(id: UInt64): &NFT {
            return &self.ownedNFTs[id] as! &NFT
        }

        //fun get IDs nft
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        // fun to check if the NFT exists
        pub fun idExists(id: UInt64): Bool {
            return self.ownedNFTs[id] != nil
        }
     
        destroy () {
            destroy self.ownedNFTs
        }

    }

//In this section you will find our variables and fields for our NFTs and Collections
    pub resource  NFT {
        pub let id : UInt64
        pub var metadata : {String: AnyStruct}
        pub let collectionType : String
        pub let name: String
 

        init(id : UInt64, name: String, metadata: {String:AnyStruct}, collectionType : String) {
            self.id = id
            self.metadata = metadata
            self.collectionType = collectionType
            self.name = name
        
        }
    }

// We define this interface simply as a way to allow users to
    // to add the first NFTs to an empty collection.
    pub resource interface NFTCollectionReceiver {
      pub fun generateNFT(currentId: UInt64, amount: UInt64, collection: &Collection): UInt64
      pub fun getQuantityAvailablesForCreate(): Int
    }

    pub resource NFTCollection: NFTCollectionReceiver {

        pub var metadata : {String: AnyStruct}
        pub let collectionType : String
        // array NFT
        pub var collectionNFT : [UInt64]
        pub let name : String
        pub let maximum : UInt64

        init(currentId: UInt64, name: String, collectionType: String, metadata: {String: AnyStruct}, amountToCreate: UInt64, maximum: UInt64 collection: &Collection) { 
            self.metadata = metadata
            self.name = name
            self.collectionType = collectionType
            self.maximum = maximum
            self.collectionNFT = []
            self.generateNFT(currentId: currentId, amount: amountToCreate, collection: collection)
        }
        
        pub fun generateNFT(currentId: UInt64, amount: UInt64, collection: &Collection): UInt64 {
            if Int(amount) < 0 {
                panic("Error amount should be greather than 0")
            }
            if amount > self.maximum {
                panic("Error amount is greater than maximun")
            }
            let newTotal = Int(amount) + self.collectionNFT.length
            if newTotal > Int(self.maximum) {
                panic("Error amount more current nft created is greater than maximun")
            }
            var i = 0
            var newCurrentId = currentId
            while i < Int(amount) {
                let newNFT <- create NFT(id: newCurrentId, name: self.name, metadata: self.metadata, collectionType: self.collectionType)
                collection.deposit(token: <- newNFT)
                self.collectionNFT.append(newCurrentId)
                i = i + 1
                newCurrentId = 1 + newCurrentId as UInt64
            }
            return newCurrentId
        }
    
        pub fun getQuantityAvailablesForCreate(): Int {
            return Int(self.maximum) - self.collectionNFT.length
        }

    }


// We define this interface simply as a way to allow users to
    // to create a new collection restricted to your NFT collection.
    // to add the first NFTs to an empty collection.
    // They would use this just to expose the amount available to create.
    // to add NFT to available spaces.
    //// They would use this to only expose getIDs
    // to get the Ids of the existing collections.
    // They would use this just to expose the ids of the nfts getIdsNFT()
    //// To get how many collections exist.
    pub resource interface CollectionsReceiver {
        pub fun createCollection(name: String, metadata: {String: AnyStruct}): UInt64
        pub fun createNFTCollection(name: String, collectionType: String, metadata: {String: AnyStruct}, amountToCreate: UInt64, maximum: UInt64, collectionId: UInt64): UInt64
        pub fun generateNFT(collectionId: UInt64, nftCollectionId: UInt64, amount: UInt64)
        pub fun getAavailableSpacesCollect(nftCollectionId: UInt64): Int
        pub fun getIdsCollection(): [UInt64]
        pub fun withdraw(collectionId: UInt64, withdrawID: UInt64): @NFT
        pub fun getCollectionRef(collectionId: UInt64): &Collection
        pub fun getMetadataNft(collectionId: UInt64, tokenId: UInt64): {String:AnyStruct}
        pub fun getIdsNFT(collectionId: UInt64) : [UInt64]
    }

    pub resource Collections: CollectionsReceiver {

        pub var idCountNFT: UInt64
        pub var idCountCollections : UInt64
        pub var idCountNFTCollections : UInt64
        pub let collections : @{UInt64: Collection}
        pub let nftCollections : @{UInt64: NFTCollection}

        init() {
            self.idCountNFT = 0
            self.idCountCollections = 0
            self.idCountNFTCollections = 0
            self.collections <- {}
            self.nftCollections <- {}
        }

        pub fun createCollection(name: String, metadata: {String: AnyStruct}): UInt64 {
            let id = self.idCountCollections + 1 as UInt64
            self.collections[id] <-! create Collection(name: name, metadata: metadata)
            self.idCountCollections = id

            emit newCollection(collectionId: id, collectionName: name)
            return id
        }

        pub fun createNFTCollection(name: String, collectionType: String, metadata: {String: AnyStruct}, amountToCreate: UInt64, maximum: UInt64, collectionId: UInt64): UInt64 {
            let collection = &self.collections[collectionId] as! &Collection
            let currentId = self.idCountNFT + 1 as UInt64
            let nftCollection <- create NFTCollection(currentId: currentId, name: name, collectionType: collectionType, metadata: metadata, amountToCreate: amountToCreate, maximum: maximum, collection: collection)
            self.idCountNFT = currentId + amountToCreate
            let id = self.idCountNFTCollections + 1
            self.nftCollections[id] <-! nftCollection
            self.idCountNFTCollections = id
            return id
        }

        pub fun generateNFT(collectionId: UInt64, nftCollectionId: UInt64, amount: UInt64) {
            let nftCollection = &self.nftCollections[nftCollectionId] as! &NFTCollection
            let collection = &self.collections[collectionId] as! &Collection
            nftCollection.generateNFT(currentId: self.idCountNFT, amount: amount, collection: collection)
            self.idCountNFT = self.idCountNFT + amount
        }

        pub fun getAavailableSpacesCollect(nftCollectionId: UInt64):Int {
            let nftCollection = &self.nftCollections[nftCollectionId] as! &NFTCollection
            return nftCollection.getQuantityAvailablesForCreate()
        }

         pub fun getMetadataNft(collectionId: UInt64, tokenId: UInt64): {String:AnyStruct}{
          let collection = &self.collections[collectionId] as! &Collection
            let token = collection.getRefNFT(id: tokenId)
            return token.metadata
        }

        pub fun getIdsNFT(collectionId: UInt64) : [UInt64] {
        let collection = &self.collections[collectionId]  as! &Collection
            let ids = collection.getIDs();
            return ids
        }

        pub fun  getIdsCollection(): [UInt64] {
            return self.collections.keys
        }

        pub fun withdraw(collectionId: UInt64, withdrawID: UInt64): @NFT {
            // If the NFT isn't found, the transaction panics and reverts
        let collection = &self.collections[collectionId] as! &Collection
        let token <- collection.withdraw(withdrawID: withdrawID)
        return <-token
        }

        pub fun getCollectionRef(collectionId: UInt64): &Collection {
            return &self.collections[collectionId] as! &Collection
        }

      
        destroy () {
            destroy self.collections
            destroy self.nftCollections
        }
    }
    
     pub fun createEmptyCollection(name: String, metadata: {String:AnyStruct}): @Collection {
        return <- create Collection(name: name, metadata: metadata)
    }
    
    //variable that stores the account address that created the contract
    pub let privateKey: Address

    init() {
        self.privateKey = self.account.address
    }

    pub fun createEmptyCollections(key: Address): @Collections{
    //Validation so that only the owner of the contract can create collections and mint tokens
    if key == self.privateKey {
        return <- create Collections()
    }
     panic("Account not verified")
    }
    
}
