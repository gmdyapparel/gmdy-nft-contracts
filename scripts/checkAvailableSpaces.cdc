import GMDYNFTContract from 0xe8e38458359e5712

pub fun main(): Int? {
      let account = getAccount(0xe8e38458359e5712)
      let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
      .borrow() ?? panic("Could not borrow collections reference")
      
      return collectRef.getAavailableSpacesCollect(nftCollectionId: 11)

}