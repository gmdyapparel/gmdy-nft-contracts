import FungibleToken from 0x9a0766d93b6608b7
import NonFungibleToken from 0x631e88ae7f1d7c20
import FUSD from 0xe223d8a629e49c68
import GMDYNFTContract from 0x23b25112477c90dc
import NFTStorefront from 0x94b06cfca1d8a476

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