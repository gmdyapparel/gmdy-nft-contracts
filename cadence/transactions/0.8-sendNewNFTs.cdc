import FungibleToken from 0xf233dcee88fe0abe
import NonFungibleToken from 0x1d7e57aa55817448
import FUSD from 0x3c5959b568896393
import GMDYNFTContract from 0xb385c1f831306cc2
import NFTStorefront from 0x4eb8a10cb9f87357


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