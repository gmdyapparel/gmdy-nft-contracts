import GMDYNFTContract from 0xe7eeedb550d0d497

    /* ## This transaction is to coin new NFTs ## */
    transaction(collectionId: UInt64, amount: UInt64) {

        let collections : Capability<&{GMDYNFTContract.CollectionsReceiver}>

    prepare(acct: AuthAccount) {
        self.collections = acct.getCapability<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
        
    }

    execute {
        let collections = self.collections.borrow()!
        collections.generateNFT(collectionId: collectionId, nftCollectionId: collectionId, amount: amount)
        log("New cradled NFTs")
    }
}