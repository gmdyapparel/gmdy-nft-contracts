import FungibleToken from 0x9a0766d93b6608b7
import NonFungibleToken from 0x631e88ae7f1d7c20
import FUSD from 0xe223d8a629e49c68
import GMDYNFTContract from 0xf9e66a0c2eceafc7
import NFTStorefront from 0x94b06cfca1d8a476


 /* ## This Transacction Minst NFTs and collection */
transaction {

  let collection : Capability<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>
  let key : AuthAccount

  prepare(acct: AuthAccount) {

    //The account must be gmdy
  self.key = acct
  
    let nameCollection : String = "Neymar collection";
    let metadataCollection : {String : AnyStruct} = {
      "banner": "ipfs://QmSRydNqzGFYCap3tf32zoL2onUYpTpVm4tGx9YVS3RRDa"
    }
        if acct.borrow<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(from: /storage/collection6) == nil {
          log("to create collection")
          let collection <- GMDYNFTContract.createEmptyCollectionNFT(name: nameCollection, metadata: metadataCollection)
          acct.save(<- collection, to: /storage/collection6)

          if acct.borrow<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(from: /storage/collection6) == nil {
            log("nil again")
          }
          acct.link<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(/private/collection6, target: /storage/collection6)
          acct.link<&GMDYNFTContract.Collection{NonFungibleToken.CollectionPublic, GMDYNFTContract.CollectionPublic}>(/public/collection6, target: /storage/collection6)
          log("Collection created!")
        } else {
          log("Collection was created")
        }

           if acct.borrow<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(from: /storage/collection6) == nil {
            panic("Collection not created")
        }
        self.collection = acct.getCapability<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(/private/collection6)

        let name = "Neymar Jr";
        let description = "Moonlight Avatar";
        let uriVideo = "ipfs://QmSRydNqzGFYCap3tf32zoL2onUYpTpVm4tGx9YVS3RRDa";

        let metadataNFT : {String : String} = {
            "uriImage": "ipfs://QmSRydNqzGFYCap3tf32zoL2onUYpTpVm4tGx9YVS3RRDa"
        }
    
        let nftType = "common"
        let amountToCreate = 10  as UInt64
        let maximum = 50  as UInt64
        let nftTemplate <- GMDYNFTContract.createNFTTemplate(
          key: self.key,
          name: name, 
          nftType: nftType, 
          metadata: metadataNFT, 
          thumbnail: uriVideo,
          description:description,
          amountToCreate: amountToCreate, 
          maximum: maximum, 
          collection: self.collection
        )
        acct.save(<- nftTemplate, to: /storage/nfttemplate7)

        acct.link<&{GMDYNFTContract.NFTCollectionReceiver}>(/public/nfttemplate7, target: /storage/nfttemplate7)
      }
  execute {
      log("NFTs and Collection Minted")
  }
}