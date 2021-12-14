import GMDYNFTContract from 0x01

pub fun main(): [UInt64] {

 let account = getAccount(0x01)
      let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
      .borrow() ?? panic("Could not borrow collections reference")
      return collectRef.getIdsCollection()

}