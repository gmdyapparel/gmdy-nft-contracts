import GMDYNFTContract from 0xab43461c2152a9d7


pub fun main(): Int? {
      let account = getAccount(0x02)
      let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
      .borrow() ?? panic("Could not borrow collections reference")
      
      return collectRef.getAavailableSpacesCollect(nftCollectionId: 11)
}