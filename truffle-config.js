//----------------------------------------------------------------
// メインネットへの接続は[INFURA]を使うと便利
//----------------------------------------------------------------
const HDWalletProvider = require('@truffle/hdwallet-provider');
var privatekey = "#################"

module.exports = {
  networks: {


    mainnet: {
      provider: function(){
        return( new HDWalletProvider( privatekey, "####################") );
      },
      network_id: 1,
      gas:  25000000,          // 1.2 m：ガスリミットの指定
      gasPrice: 70000000000,  // 45 gwei：ガス価格の指定（あまり安すぎるとデプロイ等が終わらないので注意）
      from: "#########################"
    },
    rinkeby: {
      provider: function(){
        return( new HDWalletProvider( privatekey, "##########################") );
      },
      network_id: 4,
      gas:  25000000,          // 1.2 m：ガスリミットの指定
      gasPrice: 20000000000,  // 45 gwei：ガス価格の指定（あまり安すぎるとデプロイ等が終わらないので注意）
      from: "#############################"
    }
  },

  compilers: {
    solc: {
      version: "0.8.6", // [BASEFEE]の値を取りたいので
      settings: {
        optimizer: {
          enabled: true,  // 本番環境へ上げる際は最適化を有効に
          runs: 200
        }
      }
    }
  }
}
