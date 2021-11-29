 import gmdyContract from 0xf8d6e0586b0a20c7
        import FungibleToken from 0xf8d6e0586b0a20c7
         import MarketPlace from 0xf8d6e0586b0a20c7
         transaction {
           let collectionRef: &AnyResource{gmdyContract.NFTReceiver}
        let temporaryVault: @FungibleToken.Vault
         prepare(acct: AuthAccount) {
         self.collectionRef = acct.borrow<&AnyResource{gmdyContract.NFTReceiver}>(from: /storage/NFTCollection)!
        let vaultRef = acct.borrow<&FungibleToken.Vault>(from: /storage/MainVault)
           ?? panic("Could not borrow owner's vault reference")
         self.temporaryVault <- vaultRef.withdraw(amount: 10.0)
     }
         execute {
         let seller = getAccount(0xf8d6e0586b0a20c7)
            let saleRef = seller.getCapability<&AnyResource{MarketPlace.SalePublic}>(/public/NFTSale)
                .borrow()
                ?? panic("Could not borrow seller's sale reference")
                saleRef.purchase(tokenID: tokenId, recipient: self.collectionRef, buyTokens: <-self.temporaryVault)
                    }
                }