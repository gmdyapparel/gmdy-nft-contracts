import FungibleToken from 0x9a0766d93b6608b7
import NonFungibleToken from 0x631e88ae7f1d7c20
import FUSD from 0xe223d8a629e49c68
import GMDYNFTContract from 0xf9e66a0c2eceafc7
import NFTStorefront from 0x94b06cfca1d8a476

  /* ## This transaction is to coin new NFTs ## */
    transaction(amount: UInt64) {

    let providerNFT: Capability<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>
        let collections : Capability<&{GMDYNFTContract.NFTCollectionReceiver}>

    prepare(acct: AuthAccount) {
       self.collections = acct.getCapability<&{GMDYNFTContract.NFTCollectionReceiver}>(/public/nftTemplate2)

        self.providerNFT = acct.getCapability<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(/private/collection2)
        assert(self.providerNFT.borrow() != nil, message: "Missing or mis-typed ExampleNFT.Collection provider")
        
    }

    execute {
         
        let collections = self.collections.borrow() ?? panic("Error capability")

        collections.generateNFT(amount: amount, collection: self.providerNFT)
        log("New cradled NFTs")
    }
}