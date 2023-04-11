require("@nomicfoundation/hardhat-toolbox");
require('hardhat-abi-exporter');
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
};

abiExporter: [
  {
    path: './abi/pretty',
    pretty: true,
  },
  {
    path: './abi/ugly',
    pretty: false,
  },
]