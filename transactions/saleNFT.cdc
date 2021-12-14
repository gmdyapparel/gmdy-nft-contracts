import GMDYNFTContract from 0x3b21b794c7c9fa3b
import GMDYFungibleToken from 0x3b21b794c7c9fa3b
import GMDYMarketPlace from 0x3b21b794c7c9fa3b

// This transaction creates a new Sale Collection object,
transaction {

    let collections : Capability<&{GMDYNFTContract.CollectionsReceiver}>

    prepare(acct: AuthAccount) {

        self.collections = acct.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)

        // Borrow a reference to the stored Vault
        //if  acct.getCapability<&GMDYFungibleToken>(/public/MainReceiver) == nil {
        
            acct.save(<- GMDYFungibleToken.createEmptyVault(), to: /storage/MainVault)
            acct.link<&{GMDYFungibleToken.Receiver}>(/public/MainReceiver, target: /storage/MainVault)
        //}
        let receiver = acct.getCapability<&{GMDYFungibleToken.Receiver}>(/public/MainReceiver)
   

        // Create a new Sale object, 
        // initializing it with the reference to the owner's vault
        let sale <- GMDYMarketPlace.createSaleCollection(ownerVault: receiver)
        
        // borrow a reference to the NFTCollection in storage
        let collectionsRef = self.collections.borrow() ?? panic("Could not borrow a reference to the owner's nft collection")
        
        // Withdraw the NFT from the collection that you want to sell
        let token <- collectionsRef.withdraw(collectionId: 1, withdrawID: 1)
        
        // List the token for sale by moving it into the sale object
        sale.listForSale(token: <-token, price: 10.0)
        
        // Store the sale object in the account storage 
       /// let bprr = acct.getCapability<&AnyResource{GMDYMarketPlace.SalePublic}>(/public/NFTSale)
       // log(bprr)
       // if bprr == nil {
         acct.save<@GMDYMarketPlace.SaleCollection>(<-sale, to: /storage/NFTSale)

        // Create a public capability to the sale so that others can call its methods
        acct.link<&GMDYMarketPlace.SaleCollection{GMDYMarketPlace.SalePublic}>(/public/NFTSale, target: /storage/NFTSale)
        //}
            log("Sale Created")
    }
}
 
 