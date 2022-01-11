import GMDYNFTContract from 0x9d0198a3907d2ffc
import MetadataViews from 0x9d0198a3907d2ffc


pub fun main(): GMDYNFTContract.MetadataDisplay {
    let account = getAccount(0x9d0198a3907d2ffc)
      let collectRef = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
      .borrow() ?? panic("Could not borrow collections reference")
      
    let nft = collectRef.getMetadataNft(collectionId: 1, tokenId: 1) ?? panic("Could not borrow NFT reference")


// Get the basic display information for this NFT
    if let view = nft.resolveView(Type<GMDYNFTContract.MetadataDisplay>()) {
    let display = view as! GMDYNFTContract.MetadataDisplay

    return display
    }
    panic("Metada NFT not Found")
}
