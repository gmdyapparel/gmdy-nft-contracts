import GMDYNFTContract from 0x02

pub fun main(): [UInt64] {

 let account = getAccount(0x02)
      let collectRef = account.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
      .borrow() ?? panic("Could not borrow collections reference")
      return collectRef.getIdsNFT(collectionId: 1)

}