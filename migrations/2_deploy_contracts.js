var Wishlist = artifacts.require("Wishlist");
module.exports = deployer => {
    deployer.deploy(Wishlist);
};