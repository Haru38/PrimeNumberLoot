// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(
                    out,
                    and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
                )
                out := shl(8, out)
                out := add(
                    out,
                    and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
                )
                out := shl(8, out)
                out := add(
                    out,
                    and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
                )
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}

contract PrimeNumberLoot is ERC721Enumerable, ReentrancyGuard, Ownable {
    using SafeMath for uint256;
    uint256 max_num = 100000;

    constructor() ERC721("PrimeNumberLoot", "PrimeNumberLoot") Ownable() {}

    function allPrime(uint256 first,uint256 second) public pure returns(uint256[] memory primes){
        primes = new uint256[]((second-first)/2);
        uint256 index = 0;
        for(uint256 i = first;i < second+1;i++){
            bool result = probablyPrime(i,2);
            if (result == true){
                primes[index] = i;
                index++;
            }
        }
        return primes;
    }

    function changeLimit(uint256 limit) external onlyOwner{
        max_num = limit;
    }

    //prime number or not
    function isPrime(uint256 query) internal view returns (bool) {
        require(
            query <= max_num && query >= 0,
            "That number is not supported."
        );
        return probablyPrime(query,2);
    }


    function claim(uint256 primeNumber) public nonReentrant {
        require(isPrime(primeNumber), "It's not a prime number.");
        _safeMint(_msgSender(), primeNumber);
    }


    function tokenURI(uint256 primeNumber)
        public
        view
        override
        returns (string memory)
    {
        string[5] memory colors = ["#78FF94","#77EEFF","#DBFF71","#FF00CC","#999900"];
        string[5] memory fontSizes = ["50","45","40","40","35"];

        string memory strPrimeNumber = toString(primeNumber);
        uint256 lenPrimeNumber = bytes(strPrimeNumber).length;


        string[9] memory parts;
        parts[0] = '<svg version="1.1" preserveAspectRatio="xMinYMin meet" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200"><style>.base { fill: #000000; font-family:';
        parts[1] = "cursive";
        parts[2] = ';font-size: ';
        parts[3] = fontSizes[lenPrimeNumber-1];
        parts[4] = 'px;}</style><rect width="100%" height="100%" fill="';
        if(primeNumber == 57){
            parts[5] = "#FF8856";
        }else{
            parts[5] = colors[lenPrimeNumber-1];
        }
        parts[6] = '"/><text x="100" y="100" class="base" text-anchor="middle">';
        parts[7] = strPrimeNumber;
        parts[8] = "</text></svg>";

        string memory output = string(
            abi.encodePacked(
                parts[0],
                parts[1],
                parts[2],
                parts[3],
                parts[4],
                parts[5],
                parts[6],
                parts[7],
                parts[8]
            )
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Prime Number #',
                        toString(primeNumber),
                        '", "description": "PrimeNumberLoot is an NFT for prime numbers up to ',
                        toString(max_num),
                        '. The background color and font changes depending on the number of digits in the prime number.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(output)),
                        '"}'
                    )
                )
            )
        );

        output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return output;
    }


    function probablyPrime(uint256 n, uint256 prime) public pure returns (bool) {
        // miller rabin
        // copied from https://gist.github.com/lhartikk/c7bbc120aa8e58a0e0e781edb9a90497
        if (n == 2 || n == 3 || n == 57) {
            return true;
        }

        if (n % 2 == 0 || n < 2) {
            return false;
        }

        uint256[2] memory values = getValues(n);
        uint256 s = values[0];
        uint256 d = values[1];

        uint256 x = fastModularExponentiation(prime, d, n);

        if (x == 1 || x == n - 1) {
            return true;
        }

        for (uint256 i = s - 1; i > 0; i--) {
            x = fastModularExponentiation(x, 2, n);
            if (x == 1) {
                return false;
            }
            if (x == n - 1) {
                return true;
            }
        }
        return false;
    }


    function fastModularExponentiation(uint256 a, uint256 b, uint256 n) public pure returns (uint256) {
        a = a % n;
        uint256 result = 1;
        uint256 x = a;

        while(b > 0){
            uint256 leastSignificantBit = b % 2;
            b = b / 2;

            if (leastSignificantBit == 1) {
                result = result * x;
                result = result % n;
            }
            x = x.mul(x);
            x = x % n;
        }
        return result;
    }


    // Write (n - 1) as 2^s * d
    function getValues(uint256 n) public  pure returns (uint256[2] memory) {
        uint256 s = 0;
        uint256 d = n - 1;
        while (d % 2 == 0) {
            d = d / 2;
            s++;
        }
        uint256[2] memory ret;
        ret[0] = s;
        ret[1] = d;
        return ret;
    }


    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}