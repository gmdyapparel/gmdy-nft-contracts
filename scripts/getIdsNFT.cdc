import GMDYNFTContract from 0xe0e812314d3d75bb

pub fun main(): [UInt64] {

 let account = getAccount(0xe0e812314d3d75bb)
      let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
      .borrow() ?? panic("Could not borrow collections reference")
      return collectRef.getIdsNFT(collectionId: 1)

}