# PrimeNumberLoot
[Etherscan page](https://etherscan.io/address/0x896fdEfD39a41d29C01E0bb2dC1A21529B81f42b#code)

created by 2021-09
## Descriptrion

This is a smart contract that issues prime numbers as NFTs.
It supports prime numbers up to 100000, and issues a svg with a different background color and font depending on the number of digits of the prime number.
The issued svg image can be viewed on [opensea](https://opensea.io/collection/primenumberloot), etc.

## PrimeNunberLoot.sol
Deployed Contracts
The Miller-Rabin test is used to determine prime numbers.

### method : claim
tokenID : Matches a prime number. (That is, not the number of 1~primes, but the prime number itself is the tokenID.)

### method : tokenURI
Code to create SVG of minted prime numbers.


## PN_origin.sol
### Constructor.
Perform prime number generation when deployed. Use "Eratosthenes' sieve".



