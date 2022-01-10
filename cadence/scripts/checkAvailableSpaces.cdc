import GMDYNFTContract from 0xe7eeedb550d0d497


pub fun main(): Int? {
      let account = getAccount(0xe7eeedb550d0d497)
      let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
      .borrow() ?? panic("Could not borrow collections reference")
      
      return collectRef.getAavailableSpacesCollect(nftCollectionId: 1)
}