import FungibleToken from 0x9a0766d93b6608b7
import NonFungibleToken from 0x631e88ae7f1d7c20
import FUSD from 0xe223d8a629e49c68
import GMDYNFTContract from 0x1b087c9338699c77
import NFTStorefront from 0x94b06cfca1d8a476

transaction( saleItemID: UInt64, price: UFix64) {
    let flowReceiver: Capability<&FUSD.Vault{FungibleToken.Receiver}>
    let exampleNFTProvider: Capability<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront

    prepare(acct: AuthAccount) {
    // If the account doesn't already have a Storefront
        if acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath) == nil {

            // Create a new empty .Storefront
            let storefront <- NFTStorefront.createStorefront() 
            
            // save it to the account
            acct.save(<-storefront, to: NFTStorefront.StorefrontStoragePath)

            // create a public capability for the .Storefront
            acct.link<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath, target: NFTStorefront.StorefrontStoragePath)
        }
        
     /* ## Verify that the account has a vault to receive payments ## */
        if(acct.borrow<&FUSD.Vault>(from: /storage/fusdVault) == nil) {
            // Create a new FUSD Vault and put it in storage
            acct.save(<-FUSD.createEmptyVault(), to: /storage/fusdVault)

            // Create a public capability to the Vault that only exposes
            // the deposit function through the Receiver interface
            acct.link<&FUSD.Vault{FungibleToken.Receiver}>(
                /public/fusdReceiver,
                target: /storage/fusdVault
            )

            // Create a public capability to the Vault that only exposes
            // the balance field through the Balance interface
            acct.link<&FUSD.Vault{FungibleToken.Balance}>(
                /public/fusdBalance,
                target: /storage/fusdVault
            )
        }

        // We need a provider capability, but one is not provided by default so we create one if needed.
        let providerPath = /public/collection1

        self.flowReceiver = acct.getCapability<&FUSD.Vault{FungibleToken.Receiver}>(/public/fusdReceiver)
        assert(self.flowReceiver.borrow() != nil, message: "Missing or mis-typed FUSD receiver")
        
        if !acct.getCapability<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(providerPath)!.check() {
            acct.link<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(providerPath, target: /storage/collection1)
        }

        self.exampleNFTProvider = acct.getCapability<&GMDYNFTContract.Collection{NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>(providerPath)!
        assert(self.exampleNFTProvider.borrow() != nil, message: "Missing or mis-typed ExampleNFT.Collection provider")

        self.storefront = acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")
    }

    execute {
        let saleCut = NFTStorefront.SaleCut(
            receiver: self.flowReceiver,
            amount: price
        )
        self.storefront.createListing(
            nftProviderCapability: self.exampleNFTProvider,
            nftType: Type<@GMDYNFTContract.NFT>(),
            nftID: saleItemID,
            salePaymentVaultType: Type<@FUSD.Vault>(),
            saleCuts: [saleCut]
        )
        log("sell created")
    }
}