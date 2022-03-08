import FungibleToken from 0x9a0766d93b6608b7
import NonFungibleToken from 0x631e88ae7f1d7c20
import FUSD from 0xe223d8a629e49c68
import GMDYNFTContract from 0xbf53596ef8f4926c
import NFTStorefront from 0x94b06cfca1d8a476

  /* ## This Transacction Minst */
transaction {

 let signer : AuthAccount
  let collection : Capability<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>
  
  prepare(acct: AuthAccount) {

      self.signer = acct
      let providerPrivate = /private/collection12

        if acct.borrow<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(from: /storage/collection12) == nil {
            panic("Collection not created")
        }
        self.collection = acct.getCapability<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(providerPrivate)

        let name = "Neymar Jr";

        let metadataNFT : {String : String} = {
            "uri": "ipfs://QmSRydNqzGFYCap3tf32zoL2onUYpTpVm4tGx9YVS3RRDa"
        }
        let description = "Moonlight Avatar"
    
        let collectionType = "common"
        let amountToCreate = 10  as UInt64
        let maximum = 10000  as UInt64
        let nftTemplate <- GMDYNFTContract.createNFTTemplate(
          key: self.signer,
          name: name,
          nftType: "rare",
          metadata: metadataNFT,
          thumbnail: "ipfs://QmSRydNqzGFYCap3tf32zoL2onUYpTpVm4tGx9YVS3RRDa",
          description:  description,
          amountToCreate: amountToCreate, 
          maximum: maximum, 
          collection: self.collection
        )
        acct.save(<- nftTemplate, to: /storage/nfttemplate1)
          acct.link<&{GMDYNFTContract.NFTCollectionReceiver}>(/public/nfttemplate1, target: /storage/nfttemplate1)
  }
  execute {
    log("saved")
  }
}