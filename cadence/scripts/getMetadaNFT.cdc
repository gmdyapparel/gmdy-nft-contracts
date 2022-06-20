import FungibleToken from 0x9a0766d93b6608b7
import NonFungibleToken from 0x631e88ae7f1d7c20
import FUSD from 0xe223d8a629e49c68
import GMDYNFTContract from 0xfde2900253c7afaa
import MetadataViews from 0x631e88ae7f1d7c20


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
    let account = getAccount(0xdeaf456b7e0ee426)
// acct.link<&GMDYNFTContract.Collection{NonFungibleToken.CollectionPublic, GMDYNFTContract.CollectionPublic}>(/public/collection6, target: /storage/collection6)
    let collection = account
        .getCapability(GMDYNFTContract.CollectionPublicPath)
        .borrow<&{GMDYNFTContract.CollectionPublic}>()
       ?? panic("Could not borrow a reference to the collection")

    let nft = collection.borrowGMDYNFT(id: 5) ?? panic("Could not borrow NFT reference")

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