<template>
  <div class="createarticle">
    <div class="content">
      <h3>Create Article</h3>
      <p v-if="contractAddress">The contract is deployed at {{contractAddress}}</p>
      <p v-if="!contractAddress">No contracts found</p>
      <p v-if="account">Current account: {{account}}</p>
      <p v-if="!account">No accounts found</p>

      <h5>title</h5>
      <input v-model="title">
      <br>
      <h5>content</h5>
      <input v-model="content">
      <br>
      <button @click="createArticle">Create</button>
    </div>
    <div class="message" v-if="message">{{message}}</div>

    <h4>Blogs</h4>
    <table class="table table-striped">
      <thead>
        <tr>
          <th scope="col">#</th>
          <th scope="col">Title</th>
          <th scope="col">Content</th>
        </tr>
      </thead>
      <tbody v-for="(blog, key, index) in blogs" :key="index">
        <tr>
          <td>{{ blog.id }}</td>
          <td>{{ blog.title }}</td>
          <td>{{ blog.content }}</td>
        </tr>
      </tbody>
    </table>

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
      blogs: [],
      message: null,
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
        })
    })
    this.updateArticle();
    console.log(this.blogs)
  },
  methods: {
    createArticle() {
      this.message = "Transaction started";
      return CryptoArticle.deployed()
        .then((instance) => instance.mint(this.title, this.content, true, { from: this.account }))
        .then(() => {
          this.message = "Transaction done"
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
