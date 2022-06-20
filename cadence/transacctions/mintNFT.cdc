import FungibleToken from 0x9a0766d93b6608b7
import NonFungibleToken from 0x631e88ae7f1d7c20
import FUSD from 0xe223d8a629e49c68
import GMDYNFTContract from 0xbf53596ef8f4926c
import NFTStorefront from 0x94b06cfca1d8a476

  /* ## This Transacction Minst NFT */
transaction {

  let collection : Capability<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>
  let key : AuthAccount

  prepare(acct: AuthAccount) {
        
          //The account must be gmdy
              self.key = acct

        if acct.borrow<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(from: /storage/collection1) == nil {
            panic("Collection not created")
        }
        self.collection = acct.getCapability<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(/public/collection1)

        let name = "Neymar Jr";
        let uriImage = "ipfs://QmSRydNqzGFYCap3tf32zoL2onUYpTpVm4tGx9YVS3RRDa"
        let description = "description"

        let metadataNFT : {String : String} = {
            "description": "Moonlight Avatar"
        }
    
        let collectionType = "common"
        let amountToCreate = 10  as UInt64
        let maximum = 10000  as UInt64
        let nftTemplate <- GMDYNFTContract.createNFTTemplate(
          key: self.key,
          name: name, 
          nftType: collectionType, 
          metadata: metadataNFT,
          thumbnail: uriImage,
          description: description,
          amountToCreate: amountToCreate, 
          maximum: maximum, 
          collection: self.collection
        )
        acct.save(<- nftTemplate, to: /storage/nfttemplate1)
        acct.link<&{GMDYNFTContract.NFTCollectionReceiver}>(/public/example, target: /storage/example)
  }

  execute {
    log("NFT created, SUCCES")
  }
}