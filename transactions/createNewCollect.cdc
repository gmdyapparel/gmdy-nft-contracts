import GMDYNFTContract from 0x3b21b794c7c9fa3b

transaction() {

    prepare(acct: AuthAccount) {
        if acct.borrow<&GMDYNFTContract.Collections>(from: /storage/Collections) == nil {

            let newCollections <- GMDYNFTContract.createEmptyCollections(key: acct.address)
            acct.save(<- newCollections, to: /storage/Collections)
            
            // create a public capability for the collection
            if acct.link<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver, target: /storage/Collections) == nil {
                acct.unlink(/public/SportsmanCollection)
            }

            acct.link<&{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver, target: /storage/Collections)
            log("Collections created!")
        } else {
            panic("Collections is already exists!")
        }
    }
}