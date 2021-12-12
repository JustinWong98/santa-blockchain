var Token = artifacts.require('Wishlist');

contract("Wishlist", (accounts) => {
describe('deployment', async () => {
  it('deployed successfully', async () => {
    const deployedToken = await Token.deployed();

  })
})
})