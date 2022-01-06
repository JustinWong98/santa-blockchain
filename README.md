# Wish upon a Santa
## Get into the spirit of giving with Blockchain and NFTs!

Wish upon a Santa is an app that allows users to grant wishes made by other users using Ether(ETH), but for this project, we use a fake ETH currency for testing purposes, so anyone can come and use the website without worrying about having to spend real currency.

The concept behind this app is that the wishes available are items that will be delivered by the website once someone buys it on their behalf(like an online store). The prices are set based on an available list of items - and the ETH goes to the store. To incentivise users to get into the spirit of gifting, we give 'Goodwill' points which can be used to claim NFT badges that can be displayed on one's profile, as well as a leaderboard ranking for the top wish-granters.

Here are the links to our [frontend](https://github.com/leechuanxin/santa-frontend) and [smart contract](https://github.com/JustinWong98/santa-blockchain).

## Features

- Allows users to mint their own wishes
- Users can grant wishes for others through cryptocurrency
- Compete for the top positions in the leaderboard through granting wishes
- Redeem NFT badges as a reward for granting wishes
- See all the wishes a user made or granted, and the badges they claimed

## Tech

We use:

- [Solidity] - For coding our smart contract on the blockchain
- [PostgreSQL] - Database to tie username to wallet address - as the username does not need to be stored on the blockchain
- [React] - For frontend design
- [React Bootstrap] - Bootstrap components for React

## Usage
You can visit our deployed app [here](https://damp-bayou-29307.herokuapp.com)
You will need to install [Metamask](https://metamask.io) to use this app.

- Make sure your Metamask account is connected to the Rinkeby Test Network, and connect Metamask to the website
![](https://user-images.githubusercontent.com/84217227/148346096-2c66414c-3b53-4728-8a5f-9ea67f0c5d1c.gif)
- Create your username
- Make a wish, or grant someone a wish
![](https://user-images.githubusercontent.com/84217227/148346183-08366e59-0111-4158-8c32-7a99354718dc.png)
![](https://user-images.githubusercontent.com/84217227/148346688-6ce47b2e-6ec7-40ea-91bc-b4ceb66bcd59.gif)
- Redeem NFT Badges
![](https://user-images.githubusercontent.com/84217227/148347160-8db83507-5e0a-49e2-8501-57ab7589d595.png)
- Admire your position on the leaderboard and the unique badges you've claimed!
![](https://user-images.githubusercontent.com/84217227/148347151-a5bbc0a4-e0c2-46f2-8f9d-b45300f9866d.png)
![](https://user-images.githubusercontent.com/84217227/148347248-52055b38-fd9c-418a-b65a-0d844ab1b8e7.png)
## License

MIT

   [dill]: <https://github.com/joemccann/dillinger>
   [frontend]: <https://github.com/leechuanxin/santa-frontend>
   [smart-contract]: <https://github.com/JustinWong98/santa-blockchain>
   [Truffle]: <https://trufflesuite.com/truffle/>
   [PostgreSQL]: <https://www.postgresql.org>
   [node.js]: <http://nodejs.org>
   [React]: <https://reactjs.org>
   [express]: <http://expressjs.com>
   [Solidity]: <https://soliditylang.org>
   [React Bootstrap]: <https://react-bootstrap.github.io>
