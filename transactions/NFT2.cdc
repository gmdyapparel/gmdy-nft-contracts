import gmdyContract from 0x0ecca3de3c54821a

transaction {
  let receiverRef: &{gmdyContract.NFTReceiver}
  let minterRef: &gmdyContract.NFTMinter

  prepare(acct: AuthAccount) {
      self.receiverRef = acct.getCapability<&{gmdyContract.NFTReceiver}>(/public/NFTReceiver)
          .borrow()
          ?? panic("Could not borrow receiver reference")        
      
      self.minterRef = acct.borrow<&gmdyContract.NFTMinter>(from: /storage/NFTMinter)
          ?? panic("could not borrow minter reference")
  }

  execute {
      let metadata : {String : String} = {
          "name": "Avatar Love",
          "description": "Romantic scene", 
          "uri": "ipfs://Qmaf5bZ97YJMeqPZmBdcf1brGihww8atZHXmWK7eMDj15Z"
      }
      let newNFT <- self.minterRef.mintNFT()
  
      self.receiverRef.deposit(token: <-newNFT, metadata: metadata)

      log("NFT Minted and deposited to Account 2's Collection")
  }
}