import FungibleToken from 0x0ecca3de3c54821a

transaction {
	prepare(acct: AuthAccount) {
		let vaultA <- FungibleToken.createEmptyVault()
			
		acct.save<@FungibleToken.Vault>(<-vaultA, to: /storage/MainVault)

    log("Empty Vault stored")

		let ReceiverRef = acct.link<&FungibleToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/MainReceiver, target: /storage/MainVault)

    log("References created")
	}

    post {
        getAccount(0xc2f030dfaeb9a10b).getCapability<&FungibleToken.Vault{FungibleToken.Receiver}>(/public/MainReceiver)
                        .check():  
                        "Vault Receiver Reference was not created correctly"
    }
}