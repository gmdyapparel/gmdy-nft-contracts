import GMDYNFTContract from 0x02
import GMDYMarketPlace from 0x03

        /* ~~ */ /*This Transaction is for Sale Withdrawn  */ /* ~~ */
transaction(collectionId: UInt64, withdrawID: UInt64) {

    
    prepare(acct: AuthAccount) {
                 /* ~Gets the reference of the collection of the NFTs~ */
        let collections = acct.getCapability<&{GMDYNFTContract.NFTReceiver}>(/public/GmdyCollection1)
                                .borrow() ?? panic("Could not borrow a reference to the owner's nft collection")
                        

             /* ~Look for the reference of the NFT that is for sale~ */
         let saleCollecction = getAccount(0x02).getCapability(/public/MYSaleColecction)
            .borrow<&GMDYMarketPlace.SaleCollection{GMDYMarketPlace.SalePublic}>()
                     ?? panic("Could not borrow a reference to the sale")


                         /*Token to withdraw */
        let token <-  saleCollecction.withdraw(tokenID: withdrawID)

                        /* Insert the withdrawn token */
        collections.deposit(token: <- token)
    }

    execute {
        log("NFT withdrawn")
    }
}