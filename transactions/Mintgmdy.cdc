import FungibleToken from 0x0ecca3de3c54821a

transaction {
    let mintingRef: &FungibleToken.VaultMinter

    var receiver: Capability<&FungibleToken.Vault{FungibleToken.Receiver}>

	prepare(acct: AuthAccount) {
        self.mintingRef = acct.borrow<&FungibleToken.VaultMinter>(from: /storage/MainMinter)
            ?? panic("Could not borrow a reference to the minter")
        
        let recipient = getAccount(0x0ecca3de3c54821a)
      
        self.receiver = recipient.getCapability<&FungibleToken.Vault{FungibleToken.Receiver}>
(/public/MainReceiver)

	}

    execute {
        self.mintingRef.mintTokens(amount: 300.0, recipient: self.receiver)

        log("30 tokens minted and deposited to account 0xf8d6e0586b0a20c7")
    }
}