import GMDYNFTContract from 0x583c3f5f9bbd6292
import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68


pub contract MarketPlaceGMDY {

    // Event that is emitted when a new NFT is put up for sale
    pub event ForSale(id: UInt64, price: UFix64)

    // Event that is emitted when the price of an NFT changes
    pub event PriceChanged(id: UInt64, newPrice: UFix64)
    
    // Event that is emitted when a token is purchased
    pub event TokenPurchased(id: UInt64, price: UFix64)

    // Event that is emitted when a seller withdraws their NFT from the sale
    pub event SaleWithdrawn(id: UInt64)

    // Interface that users will publish for their Sale collection
    // that only exposes the methods that are supposed to be public
    pub resource interface SalePublic {
        pub fun purchase(tokenID: UInt64, recipient: &AnyResource{GMDYNFTContract.NFTReceiver}, payment: @FUSD.Vault)
        pub fun idPrice(tokenID: UInt64): UFix64
        pub fun getIDs(): [UInt64]
    }

    // SaleCollection
    //
    // NFT Collection object that allows a user to put their NFT up for sale
    // where others can send fungible tokens to purchase it
    //
    pub resource SaleCollection: SalePublic {

        // Dictionary of the NFTs that the user is putting up for sale
        pub var forSale: @{UInt64: GMDYNFTContract.NFT}
         // Dictionary of the prices for each NFT by ID
        pub var prices: {UInt64: UFix64}

        //token vault
        pub let FlowTokenVault: Capability<&FUSD.Vault{FungibleToken.Receiver}>
        //Collection NFT
        pub let MyNFTCollection: Capability<&GMDYNFTContract.Collection>

         /* listForSale lists an NFT for sale in this collection */
        pub fun listForSale(token: @GMDYNFTContract.NFT, price: UFix64) {
        pre {
            price >= 0.0: "It doesn't make sense to list a token for less than 0.0"
            
            }
            let id = token.id
            // store the price in the price array
            self.prices[id] = price
            // put the NFT into the the forSale dictionary
            let oldToken <- self.forSale[id] <- token
            destroy oldToken

            emit ForSale(id: id, price: price)
        }

        /* withdraw gives the owner the opportunity to remove a sale from the collection */
        pub fun withdraw(tokenID: UInt64): @GMDYNFTContract.NFT {
            // remove the price
            self.prices.remove(key: tokenID)
            // remove and return the token
            let token <- self.forSale.remove(key: tokenID) ?? panic("missing NFT")
            return <-token
        }

           /* purchase lets a user send tokens to purchase an NFT that is for sale */
        pub fun purchase(tokenID: UInt64, recipient: &AnyResource{GMDYNFTContract.NFTReceiver}, payment: @FUSD.Vault) {
            pre {
                self.forSale[tokenID] != nil && self.prices[tokenID] != nil:
                    "No token matching this ID for sale!"
                payment.balance >= (self.prices[tokenID] ?? 0.0):
                    "Not enough tokens to buy the NFT!"
            }
            // get the value out of the optional
            let price = self.prices[tokenID]!     
            self.prices[tokenID] = nil

            //recipient collection
            recipient.deposit(token: <- self.withdraw(tokenID: tokenID))
            //recipient Vault
            let vaultRef = self.FlowTokenVault.borrow()
                ?? panic("Could not borrow reference to owner token vault")

            vaultRef.deposit(from: <- payment)
            
            /* Emit Event*/
            emit TokenPurchased(id: tokenID, price: price)
        }
        
        init (_MYNFTCollection: Capability<&GMDYNFTContract.Collection>, _FlowtokenVault: Capability<&FUSD.Vault{FungibleToken.Receiver}>) {
            self.forSale <- {}
            self.FlowTokenVault = _FlowtokenVault
            self.MyNFTCollection = _MYNFTCollection
            self.prices = {}
        }

        /* changePrice changes the price of a token that is currently for sale */
        pub fun changePrice(tokenID: UInt64, newPrice: UFix64) {
            self.prices[tokenID] = newPrice

            emit PriceChanged(id: tokenID, newPrice: newPrice)
        }

        /* idPrice returns the price of a specific token in the sale */
        pub fun idPrice(tokenID: UInt64): UFix64 {
            return self.prices[tokenID] ?? panic("Got no price")
        }

        /* getIDs returns an array of token IDs that are for sale */
        pub fun getIDs(): [UInt64] {
            return self.forSale.keys
        }

        destroy() {
            destroy self.forSale
        }
    }

    // createCollection returns a new collection resource to the caller
    pub fun createSaleCollection(MYNFTCollection: Capability<&GMDYNFTContract.Collection>, FlowtokenVault: Capability<&FUSD.Vault{FungibleToken.Receiver}>): @SaleCollection {
        return <- create SaleCollection(_MYNFTCollection: MYNFTCollection, _FlowtokenVault: FlowtokenVault)
    }

    init() {
    
    }
}
