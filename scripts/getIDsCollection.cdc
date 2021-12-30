import MarketPlaceGMDY from 0x583c3f5f9bbd6292

    pub fun main(): AnyStruct? {
        let account = getAccount(0x583c3f5f9bbd6292)
        let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
        .borrow() ?? panic("Could not borrow collections reference")
        
        return collectRef.getIdsNFT(collectionId: 1)

    }