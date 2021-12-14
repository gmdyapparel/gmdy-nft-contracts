import NFTContract from 0x02

transaction() {

    prepare(acct: AuthAccount) {
        if acct.borrow<&NFTContract.Collections>(from: /storage/Collections) == nil {

            let newCollections <- NFTContract.createEmptyCollections()
            acct.save(<- newCollections, to: /storage/Collections)
            
            // create a public capability for the collection
            if acct.link<&{NFTContract.CollectionsReceiver}>(/public/CollectionsReceiver, target: /storage/Collections) == nil {
                acct.unlink(/public/MomentCollection)
            }

            acct.link<&{NFTContract.CollectionsReceiver}>(/public/CollectionsReceiver, target: /storage/Collections)
            log("Collections created!")
        } else {
            panic("Collections is already exists!")
        }
    }
}