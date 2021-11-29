import FungibleToken from 0x0ecca3de3c54821a

transaction {
  var temporaryVault: @FungibleToken.Vault

  prepare(acct: AuthAccount) {
    let vaultRef = acct.borrow<&FungibleToken.Vault>(from: /storage/MainVault)
        ?? panic("Could not borrow a reference to the owner's vault")
      
    self.temporaryVault <- vaultRef.withdraw(amount: 50.0)
  }

  execute {
    let recipient = getAccount(0xc2f030dfaeb9a10b)

    let receiverRef = recipient.getCapability(/public/MainReceiver)
                      .borrow<&FungibleToken.Vault{FungibleToken.Receiver}>()
                      ?? panic("Could not borrow a reference to the receiver")

    receiverRef.deposit(from: <-self.temporaryVault)

    log("Transfer succeeded!")
  }
}