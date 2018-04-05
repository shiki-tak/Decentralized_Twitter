<template>
  <div class="article">
    <div class="content post">
      <center>
        <h3>App Info</h3>
        <p v-if="contractAddress">The contract is deployed at {{contractAddress}}</p>
        <p v-if="!contractAddress">No contracts found</p>
        <p v-if="account">Current address: {{account}}</p>
        <p v-if="!account">No accounts found</p>
      </center>
      <center>
        <h3>DTweetする</h3>
        <form novalidate class="md-layout">
          <md-card-content>
            <div class="md-layout md-gutter">
              <md-field>
                <label for="title">Title</label>
                <md-input type="text" name="title" id="title" autocomplete="title" v-model="title" class="blog form" />
              </md-field>
              <md-field>
                <label for="content">Content</label>
                <md-input type="text" name="content" id="content" autocomplete="content" v-model="content" class="blog form" />
              </md-field>
            </div>
            <md-card-actions>
              <div class="blog create button">
                <md-button @click="createArticle">Create</md-button>
              </div>
            </md-card-actions>
          </md-card-content>
        </form>
      </center>
    </div>
    <center>
      <h3>Transaction State</h3>
      <div class="message" v-if="message">{{message}}</div>
      <div class="message" v-if="!message">transaction nothing</div>
      <div class="tx_hash" v-if="tx_hash">Tx Hash: <a v-bind:href="tx_url">{{tx_hash}}</a></div>
    </center>
    <center>
      <h3>Your DTweet</h3>
    </center>
    <div class>
      <div v-for="(blog, key, index) in blogs" :key="index" class="dtweet list myself">
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
  name: 'Article',
  data() {
    return {
      blogs: [],
      message: null,
      tx_hash: null,
      tx_url: null,
      contractAddress: null,
      account: null,
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
          this.updateArticle();
        })
    })
  },
  methods: {
    createArticle() {
      this.message = "Transaction started";
      return CryptoArticle.deployed()
        .then((instance) => instance.mint(this.title, this.content, true, { from: this.account }))
        .then((r) => {
          this.tx_hash = r.tx
          this.tx_url = 'https://ropsten.etherscan.io/tx/' + r.tx
          this.message = "Transaction result"
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
      CryptoArticle.deployed().then((instance) => instance.getAllArticlesOfOwner(this.account, { from: this.account })).then((r) => {
        for (var i = 0; i < r.length; i++) {
          this.getArticle(r[i]);
        }
      })
    },
    getArticle(tokenId) {
      CryptoArticle.deployed().then((instance) => instance.getArticle(tokenId, { from: this.account })).then((r) => {
        var blog = {
          "id": null,
          "title": null,
          "content": null,
          "mintedBy": null
        }
        blog.id = tokenId
        blog.title = r[0].toString()
        blog.content = r[1].toString()
        this.blogs.push(blog)
      })
    },
    deleteArticle(tokenId){
      CryptoArticle.deployed().then((instance) => instance.burn(tokenId, { from: this.account })).then((r) => {
        this.tx_hash = r.tx
        this.tx_url = 'https://ropsten.etherscan.io/tx/' + r.tx
        this.updateArticle();
      })
    }
  }
}
</script>
<style>
.md-card-content {
  margin-left: 300px;
}

.dtweet.list.myself {
  border-bottom: solid 1px rgba(0,0,0,0.42);
  margin-left: 300px;
  margin-right: 300px;
  margin-top: 50px;
}

.blog.form {
  width: 400px !important;
}
</style>
