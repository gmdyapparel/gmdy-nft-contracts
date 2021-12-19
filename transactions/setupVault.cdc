// SetupAccount1Transaction.cdc
import GMDYNFTContract from 0xe8e38458359e5712
import GMDYFungibleToken from 0xe8e38458359e5712

// This transaction sets up account 0x01 for the marketplace tutorial
// by publishing a Vault reference and creating an empty NFT Collection.
transaction {
  prepare(acct: AuthAccount) {
    // Create a public Receiver capability to the Vault
    acct.link<&GMDYFungibleToken.Vault{GMDYFungibleToken.Receiver, GMDYFungibleToken.Balance}>
             (/public/MainReceiver, target: /storage/MainVault8)

    log("Created Vault references")

    let name = "Neymar"
    let metadataCollection : {String : String} = {
      "banner": "https://www.puma-catchup.com/wp-content/uploads/2021/03/Neymar-header-750x421.jpg"
    }
    // store an empty NFT Collection in account storage
    acct.save<@GMDYNFTContract.Collection>(<-GMDYNFTContract.createEmptyCollection(name: name, metadata: metadataCollection), to: /storage/NFTCollection8)

    // publish a capability to the Collection in storage
    acct.link<&{GMDYNFTContract.NFTReceiver}>(/public/NFTReceiver, target: /storage/NFTCollection8)

    log("Created a new empty collection and published a reference")
  }
}