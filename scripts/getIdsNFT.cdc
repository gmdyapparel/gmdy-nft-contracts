import MarketPlaceGMDY from 0x583c3f5f9bbd6292


// This script prints the NFTs that account 0x01 has for sale.
pub fun main(): [UInt64] {

  let account = getAccount(0x583c3f5f9bbd6292)

  // Find the public Sale reference to their Collection
  let acct1saleRef = account.getCapability<&AnyResource{MarketPlaceGMDY.SalePublic}>(/public/MYSaleColecction)
        .borrow()
        ?? panic("Could not borrow a reference to the sale")

  // Los the NFTs that are for sale
   log(acct1saleRef.getIDs())
  
}
  