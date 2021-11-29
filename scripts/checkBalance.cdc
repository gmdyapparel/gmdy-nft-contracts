import FungibleToken from 0x0ecca3de3c54821a

pub fun main(): UFix64 {
    let acct1 = getAccount(0x0ecca3de3c54821a)

    let acct1ReceiverRef = acct1.getCapability<&FungibleToken.Vault{FungibleToken.Balance}>(/public/MainReceiver)
        .borrow()
        ?? panic("Could not borrow a reference to the acct1 receiver")

    log("Account 1 Balance")
    log(acct1ReceiverRef.balance)
    return acct1ReceiverRef.balance
}