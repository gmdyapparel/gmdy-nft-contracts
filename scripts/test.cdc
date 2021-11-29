import MarketPlace from 0x03
    pub fun main(id: UInt64): String? {
        let account1 = getAccount(0x01)
        let acct1saleRef = account1.getCapability<&AnyResource{MarketPlace.SalePublic}>(/public/NFTSale)
            .borrow()
            ?? panic("Could not borrow acct nft sale reference")
        return acct1saleRef.getCollection(collectionId: 21)
    }
     