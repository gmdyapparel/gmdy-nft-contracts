import GMDYFungibleToken from 0x01


pub fun main() {
    // Get the accounts' public account objects
    let acct1 = getAccount(0x01)

    // Get references to the account's receivers
    // by getting their public capability
    // and borrowing a reference from the capability
    let acct1ReceiverRef = acct1.getCapability<&GMDYFungibleToken.Vault{GMDYFungibleToken.Balance}>(/public/MainReceiver)
        .borrow()
        ?? panic("Could not borrow acct1 vault receiver reference")
  

    log("Account Balance")
    log(acct1ReceiverRef.balance)

}