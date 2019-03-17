var ClockAuction = artifacts.require("ClockAuction");
var ClockAuctionBase = artifacts.require("ClockAuctionBase");
var DogAcessControl = artifacts.require("DogAccessControl");
var DogAuction = artifacts.require("DogAuction");
var DogBase = artifacts.require("DogBase");
var DogBreeding = artifacts.require("DogBreeding");
var DogCore = artifacts.require("DogCore");
var DogDeal = artifacts.require("DogDeal");
var DogMinting = artifacts.require("DogMinting");
var DogOwnership = artifacts.require("DogOwnership");
var ERC721 = artifacts.require("ERC721");
var ERC721Burnable = artifacts.require("ERC721Burnable");
var ERC721Metadata = artifacts.require("ERC721Metadata");
var GeneScienceInterface = artifacts.require("GeneScienceInterface");
var Ownable = artifacts.require("Ownable");
var Pausable = artifacts.require("Pausable");
var SaleClockAuction = artifacts.require("SaleClockAuction");
var SiringClockAuction = artifacts.require("SiringClockAuction");

module.exports = function(deployer, network, accounts) {

    const wallet = accounts[1]

  // deployment steps
  return deployer

  .then(() => deployer.deploy(Ownable))
  .then(() => deployer.deploy(Pausable))
  .then(() => deployer.link(Pausable,Ownable))

  .then(() => deployer.deploy(ClockAuctionBase))

  .then(() => deployer.deploy(ClockAuction))
  .then(() => deployer.link(ClockAuction, [Pausable, ClockAuctionBase]))
  
  .then(() => deployer.deploy(ERC721))

  .then(() => deployer.deploy(ERC721Burnable))
  .then(() => deployer.link(ERC721Burnable,ERC721))

  .then(() => deployer.deploy(DogAcessControl))

  .then(() => deployer.deploy(SaleClockAuction))
  .then(() => deployer.link(SaleClockAuction,ClockAuction))

  .then(() => deployer.deploy(SiringClockAuction))
  .then(() => deployer.link(SiringClockAuction,ClockAuction))

  .then(() => deployer.deploy(DogBase))
  .then(() => deployer.link(DogBase,[DogAccessControle, SaleClockAuction, SiringClockAuction, ERC721Burnable]))

  .then(() => deployer.deploy(DogOwnership))
  .then(() => deployer.link(DogOwnership, [DogBase, ERC721, ERC721Metadata]))

  .then(() => deployer.deploy(DogBreeding))
  .then(() => deployer.link(DogBreeding, [DogOwnership, GeneScienceInterface]))

  .then(() => deployer.deploy(DogAuction))
  .then(() => deployer.link(DogAuction,DogBreeding))

  .then(() => deployer.deploy(DogMinting))
  .then(() => deployer.link(DogMinting,DogAuction))

  .then(() => deployer.deploy(DogCore))
  .then(() => deployer.link(DogCore,DogMinting))
  
  .then(() => deployer.deploy(DogDeal))
  .then(() => deployer.link(DogDeal, [DogOwnership, DogBase, ERC721Burnable]))
  
  .then(() => deployer.deploy(ERC721Metadata))
  .then(() => deployer.deploy(GeneScienceInterface));
  
};