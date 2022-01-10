import GMDYNFTContract from 0xe7eeedb550d0d497
import GMDYMarketPlace from 0xe7eeedb550d0d497
import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68

        /* This transacction is to put an NFT up for sale */
transaction(collectionId: UInt64, tokenID: UInt64, price: UFix64) {
    let collections : Capability<&{GMDYNFTContract.CollectionsReceiver}>

    prepare(acct: AuthAccount) {

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

              /* ## condition that verifies that you have a collection created in the MarketPlace to sell NFT ## */
       if (acct.borrow<&GMDYMarketPlace.SaleCollection{GMDYMarketPlace.SalePublic}>(from: /storage/MYSaleColecction) == nil) {

            let MYNFTCollection = acct.getCapability<&GMDYNFTContract.Collection>(/public/CollectionsReceiver)
            let FlowtokenVault = acct.getCapability<&FUSD.Vault{FungibleToken.Receiver}>(/public/fusdReceiver)

            acct.save(<- GMDYMarketPlace.createSaleCollection(MYNFTCollection: MYNFTCollection, FlowtokenVault: FlowtokenVault), to: /storage/MYSaleColecction)
            acct.link<&GMDYMarketPlace.SaleCollection{GMDYMarketPlace.SalePublic}>(/public/MYSaleColecction, target: /storage/MYSaleColecction)
        }
        
                  /* ~Gets the reference of the collection of the NFTs~ */
        self.collections = acct.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
        
        // borrow a reference to the NFTCollection in storage
        let collectionsRef = self.collections.borrow() ?? panic("Could not borrow a reference to the owner's nft collection")

           let saleCollection = acct.borrow<&GMDYMarketPlace.SaleCollection>(from: /storage/MYSaleColecction)
                            ?? panic("This SaleCollection does not exist")
        
        // Withdraw the NFT from the collection that you want to sell
        let token <- collectionsRef.withdraw(collectionId: collectionId, withdrawID: tokenID)

 
        // List the token for sale by moving it into the sale object
        saleCollection.listForSale(token: <-token, price: price)
        
    }
    execute {
        log("Sale Created")
        }
}
 