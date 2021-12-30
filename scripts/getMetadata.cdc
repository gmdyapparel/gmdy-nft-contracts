import MarketPlaceGMDY from 0x583c3f5f9bbd6292

pub fun main(): AnyStruct? {
      let account = getAccount(0x02)
      let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
      .borrow() ?? panic("Could not borrow collections reference")
      
      return collectRef.getMetadataNft(collectionId: 1, tokenId: 1)

}