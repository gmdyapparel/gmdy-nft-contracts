import GMDYNFTContract from 0xab43461c2152a9d7
import MarketPlaceGMDY from 0xab43461c2152a9d7

        /* ~~ */ /*This transaction is to withdraw the sale (Market owners) */ /* ~~ */
transaction(collectionId: UInt64, withdrawID: UInt64) {

    let collections : Capability<&{GMDYNFTContract.CollectionsReceiver}>
    prepare(acct: AuthAccount) {
                 /* ~Gets the reference of the collection of the NFTs~ */
        self.collections = acct.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)

        // borrow a reference to the NFTCollection in storage
        let collectionsRef = self.collections.borrow() ?? panic("Could not borrow a reference to the owner's nft collection")

             /* ~Look for the reference of the NFT that is for sale~ */
         let saleCollecction = getAccount(0x02).getCapability(/public/MYSaleColecction)
            .borrow<&GMDYMarketPlace.SaleCollection{GMDYMarketPlace.SalePublic}>()
                     ?? panic("Could not borrow a reference to the sale")


                         /*Token to withdraw */
        let token <-  saleCollecction.withdraw(tokenID: withdrawID)

                        /* Insert the withdrawn token */
        collectionsRef.depositNFT(collectionId: collectionId, token: <- token)
    }

    execute {
        log("NFT withdrawn")
    }
}