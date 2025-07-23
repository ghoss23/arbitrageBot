require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  soldity:{
    compilers:[
      {version:"0.5.0",version: "0.5.5",version:"0.6.0",version:"0.6.6",version:"0.8.0"},
    ],
  },

  networks: {
    hardhat:{
      forking:{
      url:"https://bnb-mainnet.g.alchemy.com/v2/lNa0QhGRjIvJGFqENQ_w_1eHXqdOCpxr",
      },
    },
    testnet:{
      url:"https://bnb-testnet.g.alchemy.com/v2/lNa0QhGRjIvJGFqENQ_w_1eHXqdOCpxr",
      chainId: 97,
      account:["0xa1eeb2b9f26fe436a9de5a68bd6303897af7e5daae1c0eb872999d58d91a0377"], 
    },
    mainnet:{
      url:"https://bnb-mainnet.g.alchemy.com/v2/lNa0QhGRjIvJGFqENQ_w_1eHXqdOCpxr",
      chainId:56,
    },
  },
};
