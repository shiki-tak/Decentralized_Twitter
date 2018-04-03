<template>
  <div class="createarticle">
    <div class="content">
      <h3>Create Article</h3>
      <p v-if="contractAddress">The contract is deployed at {{contractAddress}}</p>
      <p v-if="!contractAddress">No contracts found</p>
      <h5>title</h5>
      <input v-model="title">
      <br>
      <h5>content</h5>
      <input v-model="content">
      <br>
      <button @click="createArticle">Create</button>
    </div>
  </div>
</template>

<script>
import Web3 from 'web3'
import contract from 'truffle-contract'
import artifacts from '../../build/contracts/CryptoArticleToken.json'
const CryptoArticle = contract(artifacts)

export default {
  name: 'CreateArticle',
  data() {
    return {
      message: null,
      contractAddress: null,
      title: null,
      content: null
    }
  },
  created() {
    CryptoArticle.setProvider(web3.currentProvider)
    web3.eth.getAccounts((err, accs) => {
      if (err != null) {
        console.log(err)
        this.message = "There was an error fetching your accounts. Do you have Metamask, Mist installed or an Ethereum node running? If not, you might want to look into that"
        return
      }

      if (accs.length == 0) {
        this.message = "Couldn't get any accounts! Make sure your Ethereum client is configured correctly."
        return
      }
      this.account = accs[0];
      CryptoArticle.deployed()
        .then((instance) => instance.address)
        .then((address) => {
          this.contractAddress = address
        })
    })
  },
  methods: {
    createArticle() {
      this.message = "Transaction started";
      return CryptoArticle.deployed()
        .then((instance) => instance.mint(this.title, this.content, true, { from: this.account }))
        .then(() => {
          this.message = "Transaction done"
        })
        .catch((e) => {
          console.error(e)
          this.message = "Transaction failed"
        })
    }
  }
}
</script>
