import GMDYNFTContract from 0x02
import GMDYFungibleToken from 0x01
import GMDYMarketPlace from 0x03

// This transaction uses the signer's Vault tokens to purchase an NFT
// from the Sale collection of account 0x01.
transaction {

  // reference to the buyer's NFT collection where they
  // will store the bought NFT
  let collectionRef: &AnyResource{GMDYNFTContract.NFTReceiver}

  // Vault that will hold the tokens that will be used to
  // buy the NFT
  let temporaryVault: @GMDYFungibleToken.Vault

  prepare(acct: AuthAccount) {
  
    // get the references to the buyer's fungible token Vault
    // and NFT Collection Receiver
    self.collectionRef = acct.borrow<&AnyResource{GMDYNFTContract.NFTReceiver}>(from: /storage/NFTCollection)
        ?? panic("Could not borrow reference to the signer's nft collection")

    let vaultRef = acct.borrow<&GMDYFungibleToken.Vault>(from: /storage/MainVault)
        ?? panic("Could not borrow reference to the signer's vault")

    // withdraw tokens from the buyers Vault
    self.temporaryVault <- vaultRef.withdraw(amount: 10.0)
  }

  execute {
    // get the read-only account storage of the seller
    let seller = getAccount(0x02)

    // get the reference to the seller's sale
    let saleRef = seller.getCapability<&AnyResource{GMDYMarketPlace.SalePublic}>(/public/NFTSale)
        .borrow()
       ?? panic("Could not borrow a reference to the sale")

    // purchase the NFT the the seller is selling, giving them the reference
    // to your NFT collection and giving them the tokens to buy it
    saleRef.purchase(tokenID: 1,
        recipient: self.collectionRef,
        buyTokens: <-self.temporaryVault)

    log("Token has been bought")
  }
}
