import GMDYNFTContract from 0x3b21b794c7c9fa3b

pub fun main(): AnyStruct? {
      let account = getAccount(0x3b21b794c7c9fa3b)
      let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
      .borrow() ?? panic("Could not borrow collections reference")
      
      return collectRef.getMetadataNft(collectionId: 1, tokenId: 10)

}