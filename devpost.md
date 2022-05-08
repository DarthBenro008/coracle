# devpost

## Inspiration

Data integrity has always been a concern for us. To tackle this, we were going through many data integrity processes in the industry right now and how blockchains utilize those for outside-network data. This was when we came across the word "Oracle". Since then, we have been looking into making off-chain data reliable and trustworthy enough to be utilized. Hence, presenting to you, Coracle!

EVM smart contracts cannot access off-chain data. If your smart contract relies on off-chain (like the internet) data to evaluate or execute a function, you either have to manually feed the data to your contract, incentivize users to do it, or rely on a centralized party to provide the data.

## What it does

Coracle is a transparent price oracle on BSC(Binance Smart Chain). Coracle provides a trustless and decentralized alternative to Oracle. It provides the infrastructure for decentralized applications to query off-chain data by properly incentivizing miners to provide data in a unique way that benefits the blockchain and the miners.

## How we built it

Coracle (or Cola Oracle) is a decentralized oracle. It enables contracts to interact with and obtain off-chain data securely.

Coracle implements a reward mechanism where miners get rewarded using a time-based rewarding mechanism with reputation. When a miner provides the system with correct data, the reputation of the miner is increased, and over the quarter, this reputation is built. Once the quarter finishes, the reward(collected through the tips) is distributed amongst the miners in form of cryptocurrency tokens called Cola.

In short, the miner who has contributed for the longest with the correct values gets a higher share of tokens in reward every quarter.

Since data integrity is the priority, miners have to stay long enough and provide correct data to gain significant incentives, unlike an oracle where anyone can become a miner.

## Challenges we ran into

The reward mechanism is something that had to be meaningful thought to make it a beneficial process for both the miners and the developers who will integrate the contract.

Running the BAS testnet required high spec laptops, and we had to purchase a VM to test it out.

## Accomplishments that we're proud of

Starting with minimal knowledge about oracles and why they are used in a blockchain, to building our own in such a short duration of time was a great experience.

## What we learned

We learnt about the workings and importance of Oracle in a blockchain system. Since we had never worked on Binance, we learnt the workings and the new features of the Binance chain.
