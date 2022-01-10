import GMDYNFTContract from 0xe7eeedb550d0d497
import GMDYMarketPlace from 0xe7eeedb550d0d497
import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68

        /* { This transaction purchase a NFT } */
transaction(collectionId: UInt64, ownerCollections: Address, seller: Address, tokenID: UInt64 ) {
    
            prepare(acct: AuthAccount) {
    
              /* ### This conditional verifies that the buyer has a receiving collection to deposit the purchased NFT,
                                    if it does not have it, it is created ## */
                if (acct.borrow<&{GMDYNFTContract.CollectionPublic}>(from: /storage/GmdyCollection1) == nil) {
                    let account = getAccount(ownerCollections)
                  
                              /*Get Collection Metadata to create a receiving collection*/
                  let collect = account.getCapability<&AnyResource{GMDYNFTContract.CollectionsReceiver}>(/public/CollectionsReceiver)
                    .borrow() ?? panic("Could not borrow collections reference")
                    
                  /*data array*/
                  let data = collect.getCollectionRef(collectionId: collectionId)
    
                                    /* Saving receiving collection*/
                  acct.save(<- GMDYNFTContract.createEmptyCollectionNFT(name: data.name, metadata: data.metadata), to: /storage/GmdyCollection1)
    
                                  // publish a capability to the Collection in storage
                  acct.link<&{GMDYNFTContract.CollectionPublic}>(/public/GmdyCollection1, target: /storage/GmdyCollection1)
                  }
                
    
                          /* ~Look for the reference of the NFT that is for sale~ */
                   let saleCollecction = getAccount(seller).getCapability(/public/MYSaleColecction)
                         .borrow<&GMDYMarketPlace.SaleCollection{GMDYMarketPlace.SalePublic}>()
                         ?? panic("Could not borrow a reference to the sale")
    
                           /* ~Find the container where the purchased NFT will be stored~ */
                   let recipientCollection = getAccount(acct.address).getCapability(/public/GmdyCollection1) 
                                     .borrow<&AnyResource{GMDYNFTContract.CollectionPublic}>()
                                     ?? panic("Can't get the User's collection.")
    
                    //get price of the NFT
                  let price = saleCollecction.idPrice(tokenID: tokenID)
    
                  //get vault of the buyer
                   let vault = acct.borrow<&FUSD.Vault>(from: /storage/fusdVault)
                    ?? panic("Could not borrow reference to the owner's Vault!")
               
                   if vault == nil {
                    panic("Could not borrow GMDYVault, have you set up your account?")
                   }
                                /* ~withdraw the money to pay~ */
                   let payment <- vault.withdraw(amount: price) as! @FUSD.Vault
    
                              /* ~gives the money to the seller and sends the NFT to the buyer~ */
                   saleCollecction.purchase(tokenID: tokenID, recipient: recipientCollection, payment: <- payment)
                   }
                 
                 execute {
                   log("A user purchased an NFT")
                 }
               }