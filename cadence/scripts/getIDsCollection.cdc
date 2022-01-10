import GMDYNFTContract from 0xe7eeedb550d0d497
import MarketPlaceGMDY from 0xe7eeedb550d0d497
import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68


    pub fun main(): AnyStruct? {
        let account = getAccount(0xe7eeedb550d0d497)
        let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
        .borrow() ?? panic("Could not borrow collections reference")
        
        return collectRef.getIdsNFT(collectionId: 1)

    }