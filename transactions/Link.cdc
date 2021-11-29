import FungibleToken from 0x0ecca3de3c54821a

transaction {
    prepare(acct: AuthAccount) {
          acct.link<&FungibleToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/MainReceiver, target: /storage/MainVault)
        
        
          log("Public Receiver reference created!")
    }

    post{
         getAccount(0xc2f030dfaeb9a10b).getCapability<&FungibleToken.Vault{FungibleToken.Receiver}>(/public/MainReceiver)
                    .check():
                    "Vault Receiver Reference was not created correctly"
    }
}