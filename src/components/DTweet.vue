<template>
  <div class="DTweet">
    <div class="content post">
      <center>
        <h3>Network Info</h3>
        <p v-if="!is_network">This Network is Not Ropsten!</a>
        <p v-if="!is_network">Please check your Network!</a>
        <p v-if="contractAddress && is_network">The contract is deployed at {{contractAddress}}</p>
        <p v-if="!contractAddress && is_network">No contracts found</p>
        <p v-if="account && is_network">Current address: {{account}}</p>
        <p v-if="!account && is_network">No accounts found</p>
      </center>
      <center>
        <h3>DTweetする</h3>
        <form novalidate class="md-layout">
          <md-card-content>
            <div class="md-layout md-gutter">
              <md-field>
                <label for="title">Title</label>
                <md-input type="text" name="title" id="title" autocomplete="title" v-model="title" class="dtweet form" />
              </md-field>
              <md-field>
                <label for="content">Content</label>
                <md-textarea type="text" name="content" id="content" autocomplete="content" v-model="content" class="dtweet form" />
              </md-field>
            </div>
            <md-card-actions>
              <div class="dtweet create button">
                <md-button @click="createDTweet" v-bind:disabled="!is_network">Create</md-button>
              </div>
            </md-card-actions>
          </md-card-content>
        </form>
      </center>
    </div>
    <center>
      <h3>Transaction State</h3>
      <div class="message" v-if="message">{{message}}</div>
      <div class="tx_hash" v-if="tx_hash">Tx Hash: <a v-bind:href="tx_url">{{tx_hash}}</a></div>
    </center>
    <center>
      <h3>Your DTweet</h3>
    </center>
    <div class>
      <div v-for="(dtweet, key, index) in dtweets" :key="index" class="dtweet list myself">
        <p>Title: {{ dtweet.title }}</p>
        <p style="white-space: pre;">{{ dtweet.content }}</p>
        <md-button class="md-raised" @click="deleteDTweet(dtweet.id)">Burn</md-button>
      </div>
    </div>
  </div>
</template>

<script>
import Web3 from 'web3'
import contract from 'truffle-contract'
import artifacts from '../../build/contracts/DTweetToken.json'
const DTweetToken = contract(artifacts)

export default {
  name: 'DTweet',
  data() {
    return {
      dtweets: [],
      is_network: true,
      message: null,
      tx_hash: null,
      tx_url: null,
      network: null,
      contractAddress: null,
      account: null,
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

    DTweetToken.setProvider(web3.currentProvider)
    web3.eth.getAccounts((err, accs) => {
      // このタイミングでcrrentProviderのnetwork idを調べると、UIが動的に更新されるみたい
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
      DTweetToken.deployed()
        .then((instance) => instance.address)
        .then((address) => {
          this.contractAddress = address
          this.updateDTweet();
        })
    })
  },
  methods: {
    createDTweet() {
      this.message = "Transaction started";
      return DTweetToken.deployed()
        .then((instance) => instance.mint(this.title, this.content, true, { from: this.account }))
        .then((r) => {
          this.tx_hash = r.tx
          this.tx_url = 'https://ropsten.etherscan.io/tx/' + r.tx
          this.message = "Transaction result"
          var dtweet = {
            "id": null,
            "title": null,
            "content": null,
            "mintedBy": null
          }
          dtweet.id = this.dtweets.length + 1
          dtweet.title = this.title
          dtweet.content = this.content
          dtweet.mintedBy = this.account

          this.dtweets.push(dtweet)
          this.title = null
          this.content = null
        })
        .catch((e) => {
          console.error(e)
          this.message = "Transaction failed"
        })
    },
    updateDTweet() {
      DTweetToken.deployed().then((instance) => instance.getAllDTweetsOfOwner(this.account, { from: this.account })).then((r) => {
        for (var i = 0; i < r.length; i++) {
          this.getDTweet(r[i]);
        }
      })
    },
    getDTweet(tokenId) {
      DTweetToken.deployed().then((instance) => instance.getDTweet(tokenId, { from: this.account })).then((r) => {
        var dtweet = {
          "id": null,
          "title": null,
          "content": null,
          "mintedBy": null
        }
        dtweet.id = tokenId
        dtweet.title = r[0].toString()
        dtweet.content = r[1].replace("", "\n")
        this.dtweets.push(dtweet)
      })
    },
    deleteDTweet(tokenId){
      DTweetToken.deployed().then((instance) => instance.burn(tokenId, { from: this.account })).then((r) => {
        this.tx_hash = r.tx
        this.tx_url = 'https://ropsten.etherscan.io/tx/' + r.tx
        this.dtweets = []
        this.updateDTweet();
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

.dtweet.form {
  width: 400px !important;
}
</style>
