import GMDYNFTContract from 0xfde2900253c7afaa

pub fun main(): {String: [UInt64]} {
    let owner = getAccount(0x7d03cfd2c59cc73e)
    let ids: {String: [UInt64]} = {}

    if let col = owner.getCapability(GMDYNFTContract.CollectionPublicPath)
    .borrow<&{GMDYNFTContract.CollectionPublic}>() {
        ids["GMDYNFTContract"] = col.getIDs()
    }

    return ids
}