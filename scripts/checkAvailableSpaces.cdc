import GMDYNFTContract from 0x02

pub fun main(): Int? {
      let account = getAccount(0x02)
      let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
      .borrow() ?? panic("Could not borrow collections reference")
      
      return collectRef.getAavailableSpacesCollect(nftCollectionId: 11)

}