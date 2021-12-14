
pub contract GMDYFungibleToken {

    // Total supply of all tokens in existence.
    pub var totalSupply: UFix64

    // Provider
    pub resource interface Provider {

        // withdraw
        pub fun withdraw(amount: UFix64): @Vault {
            post {
                // `result` refers to the return value of the function
                result.balance == UFix64(amount):
                    "Withdrawal amount must be the same as the balance of the withdrawn Vault"
            }
        }
    }

    // Receiver 
	pub resource interface Receiver {
        // deposit
        //
        // Function that can be called to deposit tokens 
        // into the implementing resource type
        //
        pub fun deposit(from: @Vault)
    }

    // Balance
    pub resource interface Balance {
        pub var balance: UFix64
    }

    // Vault
    pub resource Vault: Provider, Receiver, Balance {
        
		// keeps track of the total balance of the account's tokens
        pub var balance: UFix64

        // initialize the balance at resource creation time
        init(balance: UFix64) {
            self.balance = balance
        }

        // withdraw
        pub fun withdraw(amount: UFix64): @Vault {
            self.balance = self.balance - amount
            return <-create Vault(balance: amount)
        }
        
        // deposit
        pub fun deposit(from: @Vault) {
            self.balance = self.balance + from.balance
            destroy from
        }
    }

    // createEmptyVault
    pub fun createEmptyVault(): @Vault {
        return <-create Vault(balance: 0.0)
    }

	// VaultMinter
    //
    // Resource object that an admin can control to mint new tokens
    pub resource VaultMinter {

		// Function that mints new tokens and deposits into an account's vault
        pub fun mintTokens(amount: UFix64, recipient: &AnyResource{Receiver}) {
			GMDYFungibleToken.totalSupply = GMDYFungibleToken.totalSupply + amount
            recipient.deposit(from: <-create Vault(balance: amount))
        }
    }

  
    init() {
        self.totalSupply = 0.0

        // create the Vault with the initial balance and put it in storage
        let vault <- create Vault(balance: self.totalSupply)
        self.account.save(<-vault, to: /storage/MainVault)

        // Create a new MintAndBurn resource and store it in account storage
        self.account.save(<-create VaultMinter(), to: /storage/MainMinter)

        // Create a private capability link for the Minter
        self.account.link<&VaultMinter>(/private/Minter, target: /storage/MainMinter)
    }
}
 