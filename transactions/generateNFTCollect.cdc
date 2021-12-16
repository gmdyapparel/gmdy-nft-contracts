import GMDYNFTContract from 0x01

transaction() {

      let collections : Capability<&{GMDYNFTContract.CollectionsReceiver}>
  //let nftCollection : Capability<&{NFTContract.NFTCollectionReceiver}>?

  prepare(acct: AuthAccount) {
    self.collections = acct.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
    
  }

  execute {
    let collections = self.collections.borrow()!
    collections.generateNFT(collectionId: 1, nftCollectionId: 1, amount: 23)
  }

}