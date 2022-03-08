import FungibleToken from 0x9a0766d93b6608b7
import NonFungibleToken from 0x631e88ae7f1d7c20
import FUSD from 0xe223d8a629e49c68
import GMDYNFTContract from 0xbf53596ef8f4926c
import NFTStorefront from 0x94b06cfca1d8a476

  /* ## This transaction creates a collection ## */
transaction {

  prepare(acct: AuthAccount) {

    //The account must be Experia View
    let nameCollection : String = "GMDY collection 1";
    let metadataCollection : {String : AnyStruct} = {
      "banner": "https://gateway.pinata.cloud/ipfs/bafybeibuqzhuoj6ychlckjn6cgfb5zfurggs2x7pvvzjtdcmvizu2fg6ga"
    }

    let providerStorage = /storage/collection12
    let providerPrivate = /private/collection12

        if acct.borrow<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(from: providerStorage) == nil {
          let collection <- GMDYNFTContract.createEmptyCollectionNFT(name: nameCollection, metadata: metadataCollection)
          acct.save(<- collection, to: providerStorage)

          if acct.borrow<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(from: providerStorage) == nil {
            log("nil again")
          }
          acct.link<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(providerPrivate, target: providerStorage)
           acct.link<&GMDYNFTContract.Collection{NonFungibleToken.CollectionPublic, GMDYNFTContract.CollectionPublic}>(GMDYNFTContract.CollectionPublicPath, target: providerStorage)
        } else {
          panic("Collection was created")
        }
  }

  execute {
   log("Collection Created Succes")
  }
}