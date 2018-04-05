<template>
  <div class="alldtweet">
    <center>
      <h3>All DTweet</h3>
    </center>
    <div class>
      <div v-for="(blog, key, index) in blogs" :key="index" class="dtweet list">
        <p>Title: {{ blog.title }}</p>
        <p>Content: {{ blog.content }}</p>
        <md-button class="md-raised" @click="deleteArticle(blog.id)">Delete</md-button>
      </div>
    </div>
  </div>
</template>

<script>
import Web3 from 'web3'
import contract from 'truffle-contract'
import artifacts from '../../build/contracts/CryptoArticleToken.json'

const CryptoArticle = contract(artifacts)

export default {
  name: 'AllDTweet',
  data() {
    return {
      blogs: [],
      message: null,
      title: null,
      content: null
    }
  },
  created() {
    if (typeof web3 !== 'undefined') {
      console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 Fluyd, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
      // Use Mist/MetaMask's provider
      web3 = new Web3(web3.currentProvider)
    } else {
      console.warn("No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask")
      // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
      web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"))
    }
    CryptoArticle.setProvider(web3.currentProvider)
    web3.eth.getAccounts((err, accs) => {
      if (web3.currentProvider.publicConfigStore._state.networkVersion !== '3') {
        this.is_network = false
      } else {
        this.is_network = true
      }
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
          this.updateArticle();
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
          this.title = null
          this.content = null
          this.updateArticle();
        })
        .catch((e) => {
          console.error(e)
          this.message = "Transaction failed"
        })
    },
    updateArticle() {
      CryptoArticle.deployed().then((instance) => instance.getAllArticles()).then((r) => {
        for (var i = 0; i < r.length; i++) {
          this.getArticle(r[i]);
        }
      })
    },
    getArticle(tokenId) {
      CryptoArticle.deployed().then((instance) => instance.getArticle(tokenId, { from: this.account })).then((r) => {
        var blog = {
          "title": null,
          "content": null
        }
        blog.title = r[0].toString()
        blog.content = r[1].toString()
        this.blogs.push(blog)
      })
    }
  }
}
</script>

<style>
.dtweet.list {
  border-bottom: solid 1px rgba(0,0,0,0.42);
  margin-left: 300px;
  margin-right: 300px;
  margin-top: 50px;
}

</style>
