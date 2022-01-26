import NonFungibleToken from 0x631e88ae7f1d7c20
import MetadataViews from 0xf9e66a0c2eceafc7


pub struct NFT {
    pub let name: String
    pub let description: String
    pub let thumbnail: String
    pub let nftTypeCollection: String
    pub let metadata:  AnyStruct
    pub let owner: Address
    pub let type: String

    init(name: String, description: String, thumbnail: String, nftTypeCollection: String, metadata: AnyStruct, owner: Address, nftType: String,) {
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.nftTypeCollection = nftTypeCollection
        self.metadata = metadata
        self.owner = owner
        self.type = nftType
    }
}

pub fun main(): NFT {
    let account = getAccount(0x02)
// acct.link<&GMDYNFTContract.Collection{NonFungibleToken.CollectionPublic, GMDYNFTContract.CollectionPublic}>(/public/collection6, target: /storage/collection6)
    let collection = account
        .getCapability(/public/collection6)
        .borrow<&{GMDYNFTContract.CollectionPublic}>()
       ?? panic("Could not borrow a reference to the collection")

    let nft = collection.borrowGMDYNFT(id: 10) ?? panic("Could not borrow NFT reference")

    // Get the basic display information for this NFT
    
    let view = nft.resolveView(Type<MetadataViews.Display>())!
    let metadata = nft.getMetadata()

    let display = view as! MetadataViews.Display
    
    let owner: Address = nft.owner!.address
    let nftTypeCollection = nft.getnftType()
    let nftType = nft.getType()

    return NFT(
        name: display.name,
        description: display.description,
        thumbnail: display.thumbnail.uri(),
        nftTypeCollection: nftTypeCollection,
        metadata: metadata,
        owner: owner,
        nftType: nftType.identifier,
    )
}