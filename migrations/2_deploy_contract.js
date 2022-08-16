const Tether = artifacts.require("Tether");
const Reward= artifacts.require("Reward");
const Decentral_Bank = artifacts.require("Decentral_bank");


module.exports = async function (deployer, network, accounts) {

  await deployer.deploy(Tether);
  const tether = await Tether.deployed();

  await deployer.deploy(Reward);
  const reward = await Reward.deployed();

  await deployer.deploy(Decentral_Bank, reward.address, tether.address);
  const decentral_Bank = await Decentral_Bank.deployed();

  await reward.transfer(decentral_Bank.address, '1000000000000000000000000');

  await tether.transfer(decentral_Bank.address, '10000000000000000000000');

  await tether.transfer(accounts[1],'100000000000000000000');

};
