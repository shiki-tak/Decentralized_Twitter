<template>
  <div class="home">
    <div class="about">
      <center>
        <h1>About Us</h1>
        <p>これは分散型アプリケーション(DApps)として作られたtweet投稿サイトです。</p>
        <p>あなたのtweetはブロックチェーンの一つであるEthereum上に記録され、運営主体にデータを集められることはありません。</p>
        <p>現在、テストネットの一つ、Ropsten Test Networkでご利用いただけます。</p>
      </center>
    </div>
    <div class="how to use">
      <center>
        <h1>How to Use It</h1>
      </center>
      <div class="metamask install">
        <h2>1. Install MetaMask</h2>
        <ul>
          <li>まず、Google Chrome用のプラグインである<a href="https://metamask.io/">MetaMask</a>をインストールします。</li>
          <li>MetaMaskはEthereumを使った分散型アプリケーション(DApps)を簡単に使うことができるプラグインであり、現在開発されているDAppsはほとんどMetaMaskを使って動作する用に作られています。</li>
          <li>インストールが完了したら、ネットワークをRopsten Test Networkに設定します。</li>
        </ul>
      </div>
      <div class="tweet">
        <h2>2. Send DTweet</h2>
        <ul>
          <li>DTweetタブから分散型ツイート(DTweet)しよう。</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import SimpleStorage from '@/components/SimpleStorage.vue'

export default {
  name: 'home',
  components: {
    SimpleStorage
  }
}
</script>

<style>
.how.to.use {
  padding: 30px;
  margin-top: 60px;
}
</style>
