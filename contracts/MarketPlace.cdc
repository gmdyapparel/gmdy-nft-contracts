import gmdyContract from 0x0ecca3de3c54821a
import FungibleToken from 0x0ecca3de3c54821a

pub contract MarketPlace {
  pub event ForSale(id: UInt64, price: UFix64, family: String)
  pub event PriceChanged(id: UInt64, newPrice: UFix64)
  pub event TokenPurchased(id: UInt64, price: UFix64)
  pub event SaleWithdrawn(id: UInt64)
  
  //This is an interface that we will make publicly available to everyone, not just the contract owner.
  pub resource interface SalePublic {
      pub fun purchase(tokenID: UInt64, recipient: &AnyResource{gmdyContract.NFTReceiver}, buyTokens: @FungibleToken.Vault)
      pub fun idPrice(tokenID: UInt64): UFix64?
      pub fun getIDs(): [UInt64]
      pub fun getFamily(tokenId: UInt64): String?
  }

  pub resource SaleCollection: SalePublic {
    pub var forSale: @{UInt64: gmdyContract.NFT}

    pub var prices: {UInt64: UFix64}

    pub var families: {UInt64: String}

    access(account) let ownerVault: Capability<&AnyResource{FungibleToken.Receiver}>

    init (vault: Capability<&AnyResource{FungibleToken.Receiver}>) {
        self.forSale <- {}
        self.ownerVault = vault
        self.prices = {}
        self.families = {}
    }

    pub fun withdraw(tokenID: UInt64): @gmdyContract.NFT {
        self.prices.remove(key: tokenID)
        let token <- self.forSale.remove(key: tokenID) ?? panic("missing NFT")
        return <-token
    }

    pub fun listForSale(token: @gmdyContract.NFT, price: UFix64, family: String) {
        let id = token.id

        self.prices[id] = price

        self.families[id] = family

        let oldToken <- self.forSale[id] <- token
        destroy oldToken

        emit ForSale(id: id, price: price, family: family)
    }

    pub fun changePrice(tokenID: UInt64, newPrice: UFix64) {
        self.prices[tokenID] = newPrice

        emit PriceChanged(id: tokenID, newPrice: newPrice)
    }

    pub fun purchase(tokenID: UInt64, recipient: &AnyResource{gmdyContract.NFTReceiver}, buyTokens: @FungibleToken.Vault) {
        pre {
            self.forSale[tokenID] != nil && self.prices[tokenID] != nil:
                "No token matching this ID for sale!"
            buyTokens.balance >= (self.prices[tokenID] ?? 0.0):
                "Not enough tokens to by the NFT!"
        }

        let price = self.prices[tokenID]!

        self.prices[tokenID] = nil

        let vaultRef = self.ownerVault.borrow()
            ?? panic("Could not borrow reference to owner token vault")

        vaultRef.deposit(from: <-buyTokens)

        let metadata = recipient.getMetadata(id: tokenID)
        recipient.deposit(token: <-self.withdraw(tokenID: tokenID), metadata: metadata)

        emit TokenPurchased(id: tokenID, price: price)
    }

    pub fun idPrice(tokenID: UInt64): UFix64? {
        return self.prices[tokenID]
    }
    
    pub fun getFamily(tokenId: UInt64): String? {
        return self.families[tokenId]
    }

    pub fun getIDs(): [UInt64] {
        return self.forSale.keys
    }

    destroy() {
        destroy self.forSale
    }
    }
    pub fun createSaleCollection(ownerVault: Capability<&AnyResource{FungibleToken.Receiver}>): @SaleCollection { 
     return <- create SaleCollection(vault: ownerVault)
    }
}