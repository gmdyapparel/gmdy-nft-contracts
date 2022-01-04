import GMDYNFTContract from 0xab43461c2152a9d7
import MarketPlaceGMDY from 0xab43461c2152a9d7
import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68



// This script prints the NFTs that account 0x01 has for sale.
pub fun main(): UFix64 {

  let account = getAccount(0x583c3f5f9bbd6292)

  // Find the public Sale reference to their Collection
  let acct1saleRef = account.getCapability<&AnyResource{MarketPlaceGMDY.SalePublic}>(/public/MYSaleColecction)
        .borrow()
        ?? panic("Could not borrow a reference to the sale")

  //log("ids for sale)
  //log(acct1saleRef.getIDs())
  
  // Los the NFTs that are for sale
  log("NFTs for sale")
  return (acct1saleRef.idPrice(tokenID: 2))
}
  
  