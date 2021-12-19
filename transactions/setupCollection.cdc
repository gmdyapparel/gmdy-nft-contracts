import GMDYNFTContract from 0xe8e38458359e5712

transaction() {

    prepare(acct: AuthAccount) {
        if acct.borrow<&GMDYNFTContract.Collections>(from: /storage/Collections) == nil {

            let newCollections <- GMDYNFTContract.createEmptyCollections(key: acct.address)
            acct.save(<- newCollections, to: /storage/Collections)
            
            // create a public capability for the collection
            if acct.link<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver, target: /storage/Collections) == nil {
                acct.unlink(/public/MomentCollection)
            }

            acct.link<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver, target: /storage/Collections)
            log("Collections created!")
        } else {
            GMDYNFTContract.collectionExisting();
            log("Existing Collection!")
        }
    }
}