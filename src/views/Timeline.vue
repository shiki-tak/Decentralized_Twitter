<template>
  <div class="timeline">
    <AllDTweet />
  </div>
</template>

<script>
import Web3 from 'web3'
import contract from 'truffle-contract'
import artifacts from '../../build/contracts/DTweetToken.json'

import AllDTweet from '@/components/AllDTweet.vue'
const DTweetToken = contract(artifacts)

export default {
  name: 'CreateDTweet',
  components: {
    AllDTweet
  },

  data() {
    return {
      dtweets: [],
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
    DTweetToken.setProvider(web3.currentProvider)
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
      DTweetToken.deployed()
        .then((instance) => instance.address)
        .then((address) => {
          this.contractAddress = address
          this.updateDTweet();
        })
    })
  },
  methods: {
    updateDTweet() {
      DTweetToken.deployed().then((instance) => instance.getAllDTweets()).then((r) => {
        for (var i = 0; i < r.length; i++) {
          this.getDTweet(r[i]);
        }
      })
    },
    getDTweet(tokenId) {
      DTweetToken.deployed().then((instance) => instance.getDTweet(tokenId, { from: this.account })).then((r) => {
        var dtweet = {
          "title": null,
          "content": null
        }
        dtweet.title = r[0].toString()
        dtweet.content = r[1].toString()
        this.dtweets.push(dtweet)
      })
    }
  }
}
</script>
<style>
.timeline {
  padding: 15px;
}
</style>
