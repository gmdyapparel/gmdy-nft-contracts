import GMDYNFTContract from 0xab43461c2152a9d7
import MarketPlaceGMDY from 0xab43461c2152a9d7
import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68


    pub fun main(): AnyStruct? {
        let account = getAccount(0x01)
        let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
        .borrow() ?? panic("Could not borrow collections reference")
        
        return collectRef.getIdsNFT(collectionId: 1)

    }