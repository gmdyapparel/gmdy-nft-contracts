import GMDYNFTContract from 0x7d03cfd2c59cc73e
import MetadataViews from 0x7d03cfd2c59cc73e

pub fun main(): AnyStruct? {
    let account = getAccount("owner NFT")
      let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionPublic}>(/public/GmdyCollection1)
      .borrow() ?? panic("Could not borrow collections reference")
      
   // let nft = collectRef.getMetadataNft(collectionId: 1, tokenId: 1) ?? panic("Could not borrow NFT reference")
    let nft = collectRef.borrowGMDYNFT(id: 1) ?? panic("Could not borrow NFT reference")

// Get the basic display information for this NFT
//let display = nft.getType()
    if let view = nft.resolveView(Type<GMDYNFTContract.MetadataDisplay>()) {
    let display = view as! GMDYNFTContract.MetadataDisplay

    return display
   }
    panic("Metada NFT not Found")
}
