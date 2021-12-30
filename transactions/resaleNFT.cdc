import GMDYNFTContract from 0x02
import GMDYMarketPlace from 0x03

    /* This transaction Resale NFT */
transaction {

    let collections : Capability<&{GMDYNFTContract.CollectionsReceiver}>

    prepare(acct: AuthAccount) {
        self.collections = acct.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
        
        // borrow a reference to the NFTCollection in storage
        let collecction = getAccount(acct.address).getCapability(/public/GmdyCollection1) 
                                 .borrow<&AnyResource{GMDYNFTContract.NFTReceiver}>()
                                 ?? panic("Can't get the User's collection.")

           let saleCollection = acct.borrow<&GMDYMarketPlace.SaleCollection>(from: /storage/MYSaleColecction)
                            ?? panic("This SaleCollection does not exist")
        
        // Withdraw the NFT from the collection that you want to sell
        let token <- collecction.withdraw(withdrawID: 1)

 
        // List the token for sale by moving it into the sale object
        saleCollection.listForSale(token: <-token, price: 10.0)

            log("Sale Created")
    }
}