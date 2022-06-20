import FungibleToken from 0x9a0766d93b6608b7
import NonFungibleToken from 0x631e88ae7f1d7c20
import FUSD from 0xe223d8a629e49c68
import GMDYNFTContract from 0xbf53596ef8f4926c
import NFTStorefront from 0x94b06cfca1d8a476

  /* ## This transaction creates a collection ## */
transaction {

  let publicPath: PublicPath
  let storagePath : StoragePath
  let privatePath: PrivatePath

  prepare(acct: AuthAccount) {

    self.storagePath = /storage/collection2
    self.publicPath = /public/collection2
    self.privatePath = /private/collection2


    //The account must be gmdy
    let nameCollection : String = "Neymar collection";
    let metadataCollection : {String : AnyStruct} = {
      "banner": "ipfs://QmSRydNqzGFYCap3tf32zoL2onUYpTpVm4tGx9YVS3RRDa"
    }
        if acct.borrow<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(from: self.storagePath) == nil {
          let collection <- GMDYNFTContract.createEmptyCollectionNFT(name: nameCollection, metadata: metadataCollection)
          acct.save(<- collection, to: self.storagePath)

          if acct.borrow<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(from: self.storagePath) == nil {
            panic("Error to create collection")
          }
          acct.link<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(self.privatePath, target: self.storagePath)
          acct.link<&GMDYNFTContract.Collection{NonFungibleToken.CollectionPublic, GMDYNFTContract.CollectionPublic}>(self.publicPath, target: self.storagePath)
          log("Collection created!")
        } else {
          panic("Collection was created")
        }
  }

  execute {
    let acct = getAccount(0x02)
    // create a public capability for the collection
    if acct.getCapability<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(self.publicPath) == nil {
      log("nill collection")
    }
  }
}