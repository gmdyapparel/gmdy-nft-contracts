 import gmdyContract from 0x0ecca3de3c54821a
    
pub fun main() : {String : String} {

    let nftOwner = getAccount(0x0ecca3de3c54821a)  
    let capability = nftOwner.getCapability<&{gmdyContract.NFTReceiver}>(/public/NFTReceiver)
    let receiverRef = capability.borrow()
                          ?? panic("Could not borrow the receiver reference")
        return receiverRef.getMetadata(id: 2)
}
                  