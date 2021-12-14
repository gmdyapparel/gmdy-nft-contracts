
import GMDYMarketPlace from 0x3b21b794c7c9fa3b


// This script prints the NFTs that account has for sale.
pub fun main() {
  // Get the public account object for account 
  let account1 = getAccount(0x3b21b794c7c9fa3b)

  // Find the public Sale reference to their Collection
  let acct1saleRef = account1.getCapability<&AnyResource{GMDYMarketPlace.SalePublic}>(/public/NFTSale)
        .borrow()
        ?? panic("Could not borrow a reference to the sale")

  // Los the NFTs that are for sale
  log("NFTs for sale")
  log(acct1saleRef.getIDs())
  log("Price")
  log(acct1saleRef.idPrice(tokenID: 1))
}