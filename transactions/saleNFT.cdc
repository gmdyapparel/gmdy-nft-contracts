import GMDYNFTContract from 0xe8e38458359e5712
import GMDYFungibleToken from 0xe8e38458359e5712
import GMDYMarketPlace from 0xe8e38458359e5712

// This transaction creates a new Sale Collection object,
transaction {

    let collections : Capability<&{GMDYNFTContract.CollectionsReceiver}>

    prepare(acct: AuthAccount) {
        self.collections = acct.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)

        // Borrow a reference to the stored Vault
        //if  acct.getCapability<&GMDYFungibleToken>(/public/MainReceiver) == nil {
        
            acct.save(<- GMDYFungibleToken.createEmptyVault(), to: /storage/MainVault8)
            acct.link<&{GMDYFungibleToken.Receiver}>(/public/MainReceiver8, target: /storage/MainVault8)
        //}
        let receiver = acct.getCapability<&{GMDYFungibleToken.Receiver}>(/public/MainReceiver8)
   
        // Create a public Receiver capability to the Vault
        acct.link<&GMDYFungibleToken.Vault{GMDYFungibleToken.Receiver, GMDYFungibleToken.Balance}>
             (/public/MainReceiver8, target: /storage/MainVault8)
             
        // Create a new Sale object, 
        // initializing it with the reference to the owner's vault
        let sale <- GMDYMarketPlace.createSaleCollection(ownerVault: receiver)
        
        // borrow a reference to the NFTCollection in storage
        let collectionsRef = self.collections.borrow() ?? panic("Could not borrow a reference to the owner's nft collection")
        
        // Withdraw the NFT from the collection that you want to sell
        let token <- collectionsRef.withdraw(collectionId: 1, withdrawID: 8)
        
        // List the token for sale by moving it into the sale object
        sale.listForSale(token: <-token, price: 10.0)
      
         acct.save<@GMDYMarketPlace.SaleCollection>(<-sale, to: /storage/NFTSale8)

        // Create a public capability to the sale so that others can call its methods
        acct.link<&GMDYMarketPlace.SaleCollection{GMDYMarketPlace.SalePublic}>(/public/NFTSale8, target: /storage/NFTSale8)
 
            log("Sale Created")
    }
}