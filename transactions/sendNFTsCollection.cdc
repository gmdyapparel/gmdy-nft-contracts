import GMDYNFTContract from 0x3b21b794c7c9fa3b

transaction {

  let collections : Capability<&{GMDYNFTContract.CollectionsReceiver}>

  prepare(acct: AuthAccount) {
    self.collections = acct.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
    
  }

  execute {
    let metadataCollection : {String : String} = {
      "banner": "https://www.puma-catchup.com/wp-content/uploads/2021/03/Neymar-header-750x421.jpg"
    }
    let nameCollection : String = "Neymar collection"
    let name = "Neymar Jr"
    let currentId = 1 as UInt64
    let collectionType = "common"
    let amountToCreate = 7  as UInt64
    let maximum = 100  as UInt64
    let metadataNFT : {String : String} = {
        "name": "Neymar Jr",
        "description": "From Brasil", 
        "uri": "https://www.sortiraparis.com/images/80/74061/632047-psg-neymar-va-bientot-avoir-un-personnage-dans-fortnite.jpg"
    }
    let collections = self.collections.borrow()!
    let collectionId = collections.createCollection(name: nameCollection, metadata: metadataCollection)
    log("id collection")
    log(collectionId.toString())
    let collectionsBorrow = self.collections.borrow()!
    let idNFTCollection = collectionsBorrow.createNFTCollection(name: name, collectionType: collectionType, metadata: metadataNFT, amountToCreate: amountToCreate, maximum: maximum,
     collectionId: collectionId)
    log("id NFT Collection")
    log(idNFTCollection)
  }
}