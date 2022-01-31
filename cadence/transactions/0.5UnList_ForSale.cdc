import FungibleToken from 0xf233dcee88fe0abe
import NonFungibleToken from 0x1d7e57aa55817448
import FUSD from 0x3c5959b568896393
import GMDYNFTContract from 0xb385c1f831306cc2
import NFTStorefront from 0x4eb8a10cb9f87357


transaction(listingResourceID: UInt64) {
    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontManager}
    let collections : Capability<&{GMDYNFTContract.CollectionsReceiver}>
    
    prepare(acct: AuthAccount) {
         /* ~Gets the reference of the collection of the NFTs~ */
        self.collections = acct.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)

           // borrow a reference to the NFTCollection in storage
         let collectionsRef = self.collections.borrow() ?? panic("Could not borrow a reference to the owner's nft collection")

        let storefront = acct.borrow<&NFTStorefront.Storefront{NFTStorefront.StorefrontManager}>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront.Storefront")
        torefront.removeListing(listingResourceID: listingResourceID)

                /* Insert the withdrawn token */
        collectionsRef.depositNFT(collectionId: 1, token: <- )
        }

        execute {
    }
}