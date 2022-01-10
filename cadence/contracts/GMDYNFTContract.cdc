import NonFungibleToken from 0x631e88ae7f1d7c20

pub contract GMDYNFTContract: NonFungibleToken {

// Initialize the total supply
pub var totalSupply: UInt64

//variable that stores the account address that created the contract
pub let privateKey: Address

pub event ContractInitialized()
/* withdraw event */
pub event Withdraw(id: UInt64, from: Address?)
/* Event that is issued when an NFT is deposited */
 pub event Deposit(id: UInt64, to: Address?)
/* event that is emitted when a new collection is created */
pub event NewCollection(collectionId: UInt64, collectionName: String)
/* event that warns that the collection is already created*/
pub event ExistingCollection(message: String)
/* Event that is emitted when new NFTs are cradled*/
pub event NewNFTsminted(collectionId: UInt64, amount: UInt64)


/* ## ~~This is the contract where we manage the flow of our collections and NFTs~~  ## */

/* 
Through the contract you can find variables such as Metadata,
 which are no longer a name to refer to the attributes of our NFTs. 
 which could be the url where our images live
*/

//Struc Metadata NFT
    pub struct MetadataDisplay {
    pub let name: String
    pub let collectionType : String
    pub var metadata : {String: AnyStruct}
     
     

     init (metadata: {String: AnyStruct}, collectionType: String, name: String) {
        self.metadata = metadata
        self.collectionType = collectionType
        self.name = name
     }
    }


//In this section you will find our variables and fields for our NFTs and Collections
    pub resource NFT: NonFungibleToken.INFT  {
    // The unique ID that each NFT has
        pub let id: UInt64

        pub var metadata : {String: AnyStruct}
        pub let collectionType : String
        pub let name: String

        init(id : UInt64, name: String, metadata: {String:AnyStruct}, collectionType : String) {
            self.id = id
            self.metadata = metadata
            self.collectionType = collectionType
            self.name = name
        }

         pub fun getViews(): [Type] {
            return [
                Type<MetadataDisplay>()
            ]
        }

         pub fun resolveView(_ view: Type): AnyStruct? {
            switch view {
                case Type<MetadataDisplay>():
                    return MetadataDisplay(
                    metadata: self.metadata,
                    collectionType: self.collectionType,   
                    name: self.name,
                    )
            }
            return nil
        }
    }

    // We define this interface purely as a way to allow users
    // They would use this to only expose getIDs
    // and idExists fields in their Collection
    pub resource interface CollectionPublic {

        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun idExists(id: UInt64): Bool
        pub fun getRefNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT
       
    }

// We define this interface simply as a way to allow users to
    // to create a banner of the collections with their Name and Metadata
    pub resource Collection: CollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {

        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}
        pub var metadata: {String: AnyStruct}

        pub var name: String

        init (name: String, metadata: {String: AnyStruct}) {
            self.ownedNFTs <- {}
            self.name = name
            self.metadata = metadata
        }

         /* Function to remove the NFt from the Collection */
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            // If the NFT isn't found, the transaction panics and reverts
            let exist = self.idExists(id: withdrawID)
            if exist == false {
                    panic("id NFT Not exist")
            }
           let token <- self.ownedNFTs.remove(key: withdrawID)!

             /* Emit event when a common user withdraws an NFT*/
            emit Withdraw(id:withdrawID, from: self.owner?.address)

           return <-token
        }

        /*Function to deposit a  NFT in the collection*/
        pub fun deposit(token: @NonFungibleToken.NFT) {

            let token <- token as! @GMDYNFTContract.NFT

            let id: UInt64 = token.id
            
            self.ownedNFTs[token.id] <-! token

            emit Deposit(id: id, to: self.owner?.address )
        }

        //fun get IDs nft
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        /*Function get Ref NFT*/
        pub fun getRefNFT(id: UInt64): &NonFungibleToken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleToken.NFT
        }

        /*Function borrow NFT*/
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            if self.ownedNFTs[id] != nil {
                return &self.ownedNFTs[id] as &NonFungibleToken.NFT     
            }
            panic("not found NFT")
        }

        pub fun borrowGMDYNFT(id: UInt64): &GMDYNFTContract.NFT? {
            if self.ownedNFTs[id] != nil {
                // Create an authorized reference to allow downcasting
                let ref = &self.ownedNFTs[id] as auth &NonFungibleToken.NFT
                return ref as! &GMDYNFTContract.NFT
            }
          panic("not found NFT")
        }

      

        // fun to check if the NFT exists
        pub fun idExists(id: UInt64): Bool {
            return self.ownedNFTs[id] != nil
        }
     
        destroy () {
            destroy self.ownedNFTs
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
                panic("The collection is already complete or The amount of nft sent exceeds the maximum amount")
            }
            
            var i = 0  
            var newCurrentId = currentId
            while i < Int(amount) {
                let newNFT <- create NFT(id: newCurrentId, name: self.name, metadata: self.metadata, collectionType: self.collectionType)
                collection.deposit(token: <- newNFT)
                self.collectionNFT.append(newCurrentId)
                GMDYNFTContract.totalSupply = GMDYNFTContract.totalSupply + newCurrentId as UInt64
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
    //// To get how many collections exist etc..
    pub resource interface CollectionsReceiver {
        pub fun createCollection(name: String, metadata: {String: AnyStruct}): UInt64 
        pub fun createNFTCollection(name: String, collectionType: String, metadata: {String: AnyStruct}, amountToCreate: UInt64, maximum: UInt64, collectionId: UInt64): UInt64 
        pub fun generateNFT(collectionId: UInt64, nftCollectionId: UInt64, amount: UInt64)
        pub fun getAvailableSpacesCollect(nftCollectionId: UInt64):Int 
         pub fun getMetadataNft(collectionId: UInt64, tokenId: UInt64): &GMDYNFTContract.NFT? {
            post {
                (result == nil) || (result?.id == tokenId):
                    "Cannot borrow GMDYNFT reference: the ID of the returned reference is incorrect"
            }
        }
        pub fun getIdsNFT(collectionId: UInt64) : [UInt64] 
        pub fun getIdsCollection(): [UInt64]
        pub fun withdraw(collectionId: UInt64, withdrawID: UInt64): @NonFungibleToken.NFT
        pub fun depositNFT(collectionId: UInt64, token: @NonFungibleToken.NFT)
        pub fun getCollectionRef(collectionId: UInt64): &Collection 
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

            emit NewCollection(collectionId: id, collectionName: name)
            return id
        }

        pub fun createNFTCollection(name: String, collectionType: String, metadata: {String: AnyStruct}, amountToCreate: UInt64, maximum: UInt64, collectionId: UInt64): UInt64 {
            let collection = &self.collections[collectionId] as! &Collection
            let currentId = self.idCountNFT + 1 as UInt64
            let nftCollection <- create NFTCollection(currentId: currentId, name: name, collectionType: collectionType, metadata: metadata, amountToCreate: amountToCreate, maximum: maximum, collection: collection)
            self.idCountNFT = currentId + amountToCreate
            
            GMDYNFTContract.totalSupply = GMDYNFTContract.totalSupply + amountToCreate as UInt64

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
              //emit event 
            emit NewNFTsminted(collectionId: collectionId, amount: amount)
        }

        pub fun getAvailableSpacesCollect(nftCollectionId: UInt64):Int {
            let nftCollection = &self.nftCollections[nftCollectionId] as! &NFTCollection
            return nftCollection.getQuantityAvailablesForCreate()
        }

         pub fun getMetadataNft(collectionId: UInt64, tokenId: UInt64): &GMDYNFTContract.NFT?  {
          let collection = &self.collections[collectionId] as! &Collection
            let ref  = collection.borrowGMDYNFT(id: tokenId)
            if ref != nil {
            return ref
            }
            return panic("NFT not found")
        }

        pub fun getIdsNFT(collectionId: UInt64) : [UInt64] {
        let collection = &self.collections[collectionId]  as! &Collection
            let ids = collection.getIDs()
            return ids
        }

        pub fun  getIdsCollection(): [UInt64] {
            return self.collections.keys
        }

        pub fun withdraw(collectionId: UInt64, withdrawID: UInt64): @NonFungibleToken.NFT  {
            // If the NFT isn't found, the transaction panics and reverts
        let collection = &self.collections[collectionId] as! &Collection
        let token <- collection.withdraw(withdrawID: withdrawID)

        /* Emit event When admin withdraws an NFT*/
        emit Withdraw(id:withdrawID, from: self.owner?.address)

        return <-token
        }

        //func deposit NFT
        pub fun depositNFT(collectionId: UInt64, token: @NonFungibleToken.NFT) {

            let token <- token as! @GMDYNFTContract.NFT

            let id = token.id

            let collection = &self.collections[collectionId] as! &Collection
            if collection == nil {
                panic("collection not found")
            }
            collection.deposit(token: <-token)
            /*event that is emitted when the administrator deposits an NFT */
            emit Deposit(id: id, to: self.owner?.address)
        }


        pub fun getCollectionRef(collectionId: UInt64): &Collection {
            return &self.collections[collectionId] as! &Collection
        }

      
        destroy () {
            destroy self.collections
            destroy self.nftCollections
        }
    }
    
    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection(name: "", metadata: {})
    }

    pub fun createEmptyCollectionNFT(name: String, metadata: {String:AnyStruct}): @NonFungibleToken.Collection {
        return <-  create Collection(name: name, metadata: metadata)
    }

    //Function that emits an event that warns that the collection is already created
    pub fun collectionExisting() {
        emit ExistingCollection(message: "Collections is already exists!") 
    }

    //Validation so that only the owner of the contract can create collections and mint tokens
    pub fun createEmptyCollections(key: Address): @Collections {
    if key == self.privateKey { 
        return <- create Collections()
    }
     panic("Account not verified")
    }

    init() {
       
        self.privateKey = self.account.address


        // Initialize the total supply
        self.totalSupply = 0

        emit ContractInitialized()
    }
}