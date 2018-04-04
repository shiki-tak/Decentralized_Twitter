<template>
  <div class="article">
    <div class="content">
      <h3>Create Article</h3>
      <p v-if="contractAddress">The contract is deployed at {{contractAddress}}</p>
      <p v-if="!contractAddress">No contracts found</p>
      <p v-if="account">Current address: {{account}}</p>
      <p v-if="!account">No accounts found</p>
      <h3>Tweet</h3>
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
    </div>
    <div class="message" v-if="message">{{message}}</div>
    <div class="transaction" v-if="transaction">{{transaction}}</div>
    <h4>Your DTweet</h4>
    <div v-for="(blog, key, index) in blogs" :key="index">
      <p>Title: {{ blog.title }}</p>
      <p>Content: {{ blog.content }}</p>
      <md-button class="md-raised md-accent" @click="deleteArticle(blog.id)">Delete</md-button>
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
      transaction: null,
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
          this.transaction = r
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
        this.updateArticle();
      })
    }
  }
}
</script>
<style>
.blog.form {
  width: 400px !important;
}
</style>
