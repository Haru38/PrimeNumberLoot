# PrimeNumberLoot

## descriptrion

This is a smart contract that issues prime numbers as NFTs.
It supports prime numbers up to 100000, and issues a svg with a different background color and font depending on the number of digits of the prime number.
The issued svg image can be viewed on open sea, etc.

## PrimeNunberLoot.sol
Deployed Contracts
### Constructor.
Perform prime number generation when deployed. Use "Eratosthenes' sieve".

### method : claim
tokenID : Matches a prime number. (That is, not the number of 1~primes, but the prime number itself is the tokenID.)

### method : tokenURI
Code to create SVG of minted prime numbers.

## PN_origin.sol
A method to check the result of prime number generation and the number of prime numbers added for testing. This function is not added to the contract for deployment because it is not actually used.

