<template>
  <div class="home">
    <div class="app title">
      <div class="name">
        <p>Decentralized Twitter</p>
      </div>
      <img src="../assets/ether_icon.png" style="width: 90px;" />
      <h3>Ethereumを使った分散型アプリケーション(DApps)としてのTweetサイト</h3>
    </div>
    <div class="about">
      <center>
        <h1>About</h1>
        <p>これはEthereumを使ったtweet投稿サイトです。</p>
        <p>このサイトではTweetに代わって、DTweet(Decentralized Tweet)を行うことができます。</p>
        <p>あなたのDTweetはブロックチェーンの一つであるEthereum上に記録され、運営主体にデータを集められることはありません。</p>
        <p>DTweetはERC721トークンとして発行されており、Burnすることもできます。</p>
        <p>現在、テストネットの一つ、Ropsten Test Networkでご利用いただけます。</p>
      </center>
    </div>
    <div class="how to use">
      <center>
        <h1>How to Use It</h1>
      </center>
      <div class="install metamask">
        <h2>1. Install MetaMask</h2>
        <ul>
          <p>まず、Google Chrome用のプラグインである<a href="https://metamask.io/">MetaMask</a>をインストールします。</p>
          <p>MetaMaskはEthereumを使ったDAppsを簡単に使うことができるプラグインであり、
            最近ではCryptoKittiesを代表とするEthereum上のゲームをプレイするときに多く用いられているウォレットです。</p>
          <p>インストールが完了したら、ネットワークをRopsten Test Networkに設定します。</p>
          <img src="../assets/network_state.png" style="width: 300px; height: auto; box-shadow: 2px 2px 5px 2px #ddd;"/>
        </ul>
      </div>
      <div class="buy eth">
        <h2>2. Buy ETH</h2>
        <ul>
          <p>DTweetするためのETHを手に入れます。</p>
          <p>MetaMaskから"BUY"ボタンをクリックします。</p>
          <img src="../assets/buy.png" style="width: 300px; height: auto; box-shadow: 2px 2px 5px 2px #ddd;"/>
          <p>"ROPSTEN TEST FAUCET"をクリックすると、MetaMask Ether Faucetが開きます。</p>
          <img src="../assets/buy_confirm.png" style="width: 300px; height: auto; box-shadow: 2px 2px 5px 2px #ddd;"/>
          <p>"request 1 ether from faucet"をクリックすると、テスト用のETHが手に入ります。</p>
          <img src="../assets/faucet.png" style="width: 700px; height: auto; box-shadow: 2px 2px 5px 2px #ddd;"/>
        </ul>
      </div>
      <div class="send dtweet">
        <h2>3. Send DTweet</h2>
        <ul>
          <p>DTweetタブからDTweetのTitleとContentを入力します。</p>
          <img src="../assets/dtweet.png" style="width: 600px; height: auto; box-shadow: 2px 2px 5px 2px #ddd;"/>
          <p>MetaMaskの"CONFIRM TRANSACTION"が開くので、"SUBMIT"をクリックします。</p>
          <img src="../assets/tx_metamask.png" style="width: auto; height: 300px; box-shadow: 2px 2px 5px 2px #ddd;"/>
          <p>ネットワークの状態にもよりますが、30秒ほどでTransactionが承認され、DTweetが表示されます。</p>
          <img src="../assets/dtweet_result.png" style="width: auto; height: 300px; box-shadow: 2px 2px 5px 2px #ddd;"/>
          <p>Transaction HashのリンクをクリックするとRopsten Test NetのEtherscanが開きます。</p>
          <img src="../assets/ropsten_res.png" style="width: 700px; height: auto; box-shadow: 2px 2px 5px 2px #ddd;"/>
        </ul>
      </div>
    </div>
    <div class="footer">
      @2018 <a href="https://twitter.com/shiki_tak">shiki_tak.</a> All Rights Reserved.
    </div>
  </div>
</template>

<script>
export default {
  name: 'home',
  components: {

  }
}
</script>

<style>

.app.title {
  background-color: #303030;
  height: 285px;
  text-align: center;
  color: white;
}

.name {
  margin-top: -15px;
  padding-top: 5px;
  font-size: 45px;
  text-align: center;
  p {
    margin-bottom: 5px !important;
  }
}
.how.to.use {
  padding: 30px;
  margin-top: 60px;
}

.send.dtweet {
  margin-top: 40px;
}

.footer {
  height: 60px;
  background-color: #eee;
  padding: 10px 20px 30px 20px;
  position: relative;
}
</style>
