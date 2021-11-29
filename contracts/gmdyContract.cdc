pub contract gmdyContract {

  //Resources are elements stored in user accounts and accessible through access control measures  
  pub resource NFT {
    pub let id: UInt64
    init(initID: UInt64) { 
      self.id = initID
    }
  }

  //Available resources interface
  pub resource interface NFTReceiver {
    pub fun deposit(token: @NFT, metadata: {String : String})
    pub fun getIDs(): [UInt64]
    pub fun idExists(id: UInt64): Bool
    pub fun getMetadata(id: UInt64) : {String : String}
  }

  //token collection interface
  pub resource Collection: NFTReceiver {

    //Keeps track of all the NFTs that a user owns from this contract
    pub var ownedNFTs: @{UInt64: NFT}

    //NFT to store a metadata mapping for each NFT
    pub var metadataObjs: {UInt64: { String : String }}

    init () {
        self.ownedNFTs <- {}
        self.metadataObjs = {}
    }

    pub fun withdraw(withdrawID: UInt64): @NFT {
        let token <- self.ownedNFTs.remove(key: withdrawID)!

        return <-token
    }

    pub fun deposit(token: @NFT, metadata: {String : String}) {
        self.metadataObjs[token.id] = metadata
        self.ownedNFTs[token.id] <-! token
    }

    pub fun idExists(id: UInt64): Bool {
        return self.ownedNFTs[id] != nil
    }

    pub fun getIDs(): [UInt64] {
        return self.ownedNFTs.keys
    }

    pub fun updateMetadata(id: UInt64, metadata: {String: String}) {
        self.metadataObjs[id] = metadata
    }

    pub fun getMetadata(id: UInt64): {String : String} {
        return self.metadataObjs[id]!
    }

    destroy() {
        destroy self.ownedNFTs
    }
  }

  //Function that creates an empty NFT collection when called
  pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }

  //The NFTMinterresource includes a headCount that is incremented to ensure that we never have duplicate identifiers for our NFTs.
  pub resource NFTMinter {
    pub var idCount: UInt64

    init() {
        self.idCount = 1
    }

    pub fun mintNFT(): @NFT {
        var newNFT <- create NFT(initID: self.idCount)
        self.idCount = self.idCount + 1 as UInt64
        return <-newNFT
    }
  }

  //Main contract initializer
  init() {
        self.account.save(<-self.createEmptyCollection(), to: /storage/NFTCollection)
        self.account.link<&{NFTReceiver}>(/public/NFTReceiver, target: /storage/NFTCollection)
        self.account.save(<-create NFTMinter(), to: /storage/NFTMinter)
	}
}
