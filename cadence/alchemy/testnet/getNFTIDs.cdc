import NonFungibleToken from 0x631e88ae7f1d7c20
import GMDYNFTContract from 0xfde2900253c7afaa

pub fun main(ownerAddress: Address): {String: [UInt64]} {
    let owner = getAccount(ownerAddress)
    let ids: {String: [UInt64]} = {}

     if let col = owner.getCapability(GMDYNFTContract.CollectionPublicPath)
    .borrow<&{GMDYNFTContract.CollectionPublic}>() {
        ids["GMDYNFTContract"] = col.getIDs()
    }
    return ids
}
