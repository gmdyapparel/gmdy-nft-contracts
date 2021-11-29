import gmdyContract from 0x0ecca3de3c54821a
import FungibleToken from 0x0ecca3de3c54821a
import MarketPlace from 0x0ecca3de3c54821a

transaction {

    prepare(acct: AuthAccount) {
        let receiver = acct.getCapability<&{FungibleToken.Receiver}>(/public/MainReceiver)
        let sale <- MarketPlace.createSaleCollection(ownerVault: receiver)

        let collectionRef = acct.borrow<&gmdyContract.Collection>(from: /storage/NFTCollection)
            ?? panic("Could not borrow owner's nft collection reference")

        let token <- collectionRef.withdraw(withdrawID: 2)

        sale.listForSale(token: <-token, price: 47.0, family:" Ultra Rare")

        acct.save(<-sale, to: /storage/NFTSale)

        acct.link<&MarketPlace.SaleCollection{MarketPlace.SalePublic}>(/public/NFTSale, target: /storage/NFTSale)

        log("Collection created")
    }
}