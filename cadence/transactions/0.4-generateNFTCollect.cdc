import GMDYNFTContract from 0xab43461c2152a9d7

transaction() {

      let collections : Capability<&{GMDYNFTContract.CollectionsReceiver}>

  prepare(acct: AuthAccount) {
    self.collections = acct.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
    
  }

  execute {
    let collections = self.collections.borrow()!
    collections.generateNFT(collectionId: 11, nftCollectionId: 11, amount: 5)
  }

}