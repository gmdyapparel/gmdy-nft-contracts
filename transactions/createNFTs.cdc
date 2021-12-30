import GMDYNFTContract from 0x02

  /* ## This Transacction Minst */
transaction {

  let collections : Capability<&{GMDYNFTContract.CollectionsReceiver}>

  prepare(acct: AuthAccount) {
    
    //The account must be gmdy
        if acct.borrow<&GMDYNFTContract.Collections>(from: /storage/Collections) == nil {
            let newCollections <- GMDYNFTContract.createEmptyCollections(key: acct.address)
            acct.save(<- newCollections, to: /storage/Collections)
            
            // create a public capability for the collection
            if acct.link<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver, target: /storage/Collections) == nil {
                acct.unlink(/public/MomentCollection)
            }

            acct.link<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver, target: /storage/Collections)
            log("Collections created!")
        } 
        self.collections = acct.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
  }

  execute {
    let metadataCollection : {String : String} = {
      "banner": "ipfs://QmSRydNqzGFYCap3tf32zoL2onUYpTpVm4tGx9YVS3RRDa"
    }
    let nameCollection : String = "Neymar collection"
    let name = "Neymar Jr"
    let collectionType = "common"
    let amountToCreate = 12  as UInt64
    let maximum = 20  as UInt64
    let metadataNFT : {String : String} = {
        "name": "Avatar",
        "description": "Moonlight Avatar", 
        "uri": "ipfs://QmSRydNqzGFYCap3tf32zoL2onUYpTpVm4tGx9YVS3RRDa"
    }
    let collections = self.collections.borrow()!
    let collectionId = collections.createCollection(name: nameCollection, metadata: metadataCollection)
    log("id collection")
    log(collectionId)
    
    let idNFTCollection = collections.createNFTCollection(name: name, collectionType: collectionType, metadata: metadataNFT, amountToCreate: amountToCreate, maximum: maximum,
     collectionId: collectionId)
    log("id NFT Collection")
    log(idNFTCollection)
  }
}