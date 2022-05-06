import FungibleToken from 0x9a0766d93b6608b7
import NonFungibleToken from 0x631e88ae7f1d7c20
import FUSD from 0xe223d8a629e49c68
import GMDYNFTContract from 0xb385c1f831306cc2
import NFTStorefront from 0x94b06cfca1d8a476

 /* ## it is to withdraw from sale## */
transaction(listingResourceID: UInt64) {
    
    prepare(acct: AuthAccount) {
        
           
        let storefront = acct.borrow<&NFTStorefront.Storefront{NFTStorefront.StorefrontManager}>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront.Storefront")
        storefront.removeListing(listingResourceID: listingResourceID)

        }

        execute {
        log("NFT withdrawn from sale")
    }
}