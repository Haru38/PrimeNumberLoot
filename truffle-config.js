//----------------------------------------------------------------
// メインネットへの接続は[INFURA]を使うと便利
//----------------------------------------------------------------
const HDWalletProvider = require('@truffle/hdwallet-provider');
var privatekey = "4c5cc1a8c683a323a332897611c6b99fd111434c5f1bffe2804716c2d510006e"

module.exports = {
  networks: {


    mainnet: {
      provider: function(){
        return( new HDWalletProvider( privatekey, "https://mainnet.infura.io/v3/5fb3800936cf4b1691d49a48ae818b91") );
      },
      network_id: 1,
      gas:  25000000,          // 1.2 m：ガスリミットの指定
      gasPrice: 70000000000,  // 45 gwei：ガス価格の指定（あまり安すぎるとデプロイ等が終わらないので注意）
      from: "0x857403325CEAbFBD4a212EBE48660b0D6392473D"
    },
    rinkeby: {
      provider: function(){
        return( new HDWalletProvider( privatekey, "https://rinkeby.infura.io/v3/5fb3800936cf4b1691d49a48ae818b91") );
      },
      network_id: 4,
      gas:  25000000,          // 1.2 m：ガスリミットの指定
      gasPrice: 20000000000,  // 45 gwei：ガス価格の指定（あまり安すぎるとデプロイ等が終わらないので注意）
      from: "0x30396F27D047e0E168d6A2c2fDe20cd7eD68Ed34"
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
