import GMDYNFTContract from 0xe8e38458359e5712

pub fun main(): [UInt64] {

 let account = getAccount(0xe8e38458359e5712)
      let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
      .borrow() ?? panic("Could not borrow collections reference")
      return collectRef.getIdsNFT(collectionId: 11)

}