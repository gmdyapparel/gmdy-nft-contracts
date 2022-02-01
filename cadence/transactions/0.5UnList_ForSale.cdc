import FungibleToken from 0xf233dcee88fe0abe
import NonFungibleToken from 0x1d7e57aa55817448
import FUSD from 0x3c5959b568896393
import GMDYNFTContract from 0xb385c1f831306cc2
import NFTStorefront from 0x4eb8a10cb9f87357


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