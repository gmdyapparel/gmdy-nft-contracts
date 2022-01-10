import GMDYNFTContract from 0xab43461c2152a9d7
import GMDYMarketPlace from 0xab43461c2152a9d7

    /* This transaction is to make an NFT Resale (App users)*/
  transaction {

        let collections : Capability<&{GMDYNFTContract.CollectionsReceiver}>
    
        prepare(acct: AuthAccount) {
    
         self.collections = acct.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
    
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
           if (acct.borrow<&GMDYMarketPlace0_2.SaleCollection{GMDYMarketPlace0_2.SalePublic}>(from: /storage/MYSaleColecctionNFT) == nil) {
    
                let MYNFTCollection = acct.getCapability<&GMDYNFTContract.Collection>(/public/CollectionsReceiver)
                let FlowtokenVault = acct.getCapability<&FUSD.Vault{FungibleToken.Receiver}>(/public/fusdReceiver)
    
                acct.save(<- GMDYMarketPlace0_2.createSaleCollection(MYNFTCollection: MYNFTCollection, FlowtokenVault: FlowtokenVault), to: /storage/MYSaleColecctionNFT)
                acct.link<&GMDYMarketPlace0_2.SaleCollection{GMDYMarketPlace0_2.SalePublic}>(/public/MYSaleColecctionNFT, target: /storage/MYSaleColecctionNFT)
            }
           
            
            // borrow a reference to the NFTCollection in storage
            let collecction = getAccount(acct.address).getCapability(/public/GmdyCollection1) 
                                .borrow<&AnyResource{GMDYNFTContract.CollectionPublic}>()
                                ?? panic("Can't get the User's collection.")
    
               let saleCollection = acct.borrow<&GMDYMarketPlace0_2.SaleCollection>(from: /storage/MYSaleColecctionNFT)
                                ?? panic("This SaleCollection does not exist")
            
            // Withdraw the NFT from the collection that you want to sell
            let token <- collecction.withdraw(withdrawID: 1)
    
     
            // List the token for sale by moving it into the sale object
            saleCollection.listForSale(token: <-token, price: 100.0)
    
    
                log("Sale Created")
        }
    }