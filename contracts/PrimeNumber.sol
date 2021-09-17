// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PrimeNumber is ERC721Enumerable, ReentrancyGuard, Ownable {
    mapping(uint256 => bool) private primeNumberBool;
    uint256 max_num = 100;

    constructor() ERC721("PrimeNumberLoot", "PrimeNumberLoot") Ownable() {
        for (uint256 i = 0; i <= max_num; i++) {
            primeNumberBool[i] = true;
        }

        //oput ogf flag
        for (uint256 i = 2; i <= max_num; i++) {
            if (primeNumberBool[i] == true) {
                for (uint256 j = 2 * i; j <= max_num; j = j + i) {
                    primeNumberBool[j] = false;
                }
            }
        }
        primeNumberBool[57] = true;
    }

    //if prime number
    function PRIMES(uint256 query) internal view returns (bool) {
        require(
            query <= max_num && query >= 0,
            "That number is not supported."
        );
        return primeNumberBool[query];
    }

    // get all prime number only owaner
    function getAllPrimeNumber()
        public
        view
        onlyOwner
        returns (uint256[] memory primes)
    {
        uint256 primeNumberCount = getNumOfPrimeNumber();
        primes = new uint256[](primeNumberCount);
        uint256 index = 0;
        for (uint256 i = 2; i <= max_num; i++) {
            if (primeNumberBool[i] == true) {
                primes[index] = i;
                index++;
            }
        }
        return primes;
    }

    //get the number of prime number
    function getNumOfPrimeNumber() public view returns (uint256) {
        uint256 index = 0;
        for (uint256 i = 2; i <= max_num; i++) {
            if (primeNumberBool[i] == true) {
                index++;
            }
        }
        return index;
    }

    //for claim
    function claim(uint256 primeNumber) public nonReentrant {
        require(PRIMES(primeNumber), "not prime number");
        _safeMint(_msgSender(), primeNumber);
    }

    function ownerClaim(uint256 primeNumber) public nonReentrant onlyOwner {
        require(PRIMES(primeNumber), "not prime number");
        _safeMint(owner(), primeNumber);
    }

    function tokenURI(uint256 primeNumber)
        public
        pure
        override
        returns (string memory)
    {
        string[5] memory colors = ["#78FF94","#77EEFF","#DBFF71","#FF82B2","#FF8856"];
        string[5] memory fonts = ["sans-serif","serif","cursive","fantasy","monospace"];
        string[5] memory fontSizes = ["50","50","50","40","30"];

        string memory strPrimeNumber = toString(primeNumber);//uint2str
        uint256 lenPrimeNumber = bytes(strPrimeNumber).length;//桁数

        string memory color;//背景色
        string memory yourFont;//フォント
        string memory fontSize;//

        string[9] memory parts;

        if (primeNumber == 57){
            parts[0] = '<svg version="11"preserveAspectRatio="xMinYMinmeet"xmlns="http://wwww3.org/2000/svg" viewBox="0 0 200 200"><defs><linearGradient id="GradientBG" x1="0" x2="0" y1="0" y2="1"><stop offset="5%" stop-color="';
            parts[1] = "#B22222";
            parts[2] = '"/><stop offset="95%" stop-color="white"/></linearGradient></defs><style>.base {fill: #000000;font-family:';
            parts[3] = fonts[lenPrimeNumber-1];
            parts[4] = ';font-size:';
            parts[5] = fontSizes[lenPrimeNumber-1];
            parts[6] = 'px;}</style><rect id="sora" x="0" y="0" width="100%" height="100%" fill="url(#GradientBG)" /><text x="100" y="100" class="base" text-anchor="middle">';
            parts[7] = strPrimeNumber;
            parts[8] = '</text></svg>';
        }else{
            parts[0] = '<svg version="1.1" preserveAspectRatio="xMinYMin meet" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200"><style>.base { fill: #000000; font-family:';
            parts[1] = fonts[lenPrimeNumber-1];
            parts[2] = ';font-size: ';
            parts[3] = fontSizes[lenPrimeNumber-1];
            parts[4] = 'px;}</style><rect width="100%" height="100%" fill="';
            parts[5] = colors[lenPrimeNumber-1];
            parts[6] = '"/><text x="100" y="100" class="base" text-anchor="middle">';
            parts[7] = strPrimeNumber;
            parts[8] = "</text></svg>";
        }


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
                        '{"name": "prime Number #',
                        toString(primeNumber),
                        '", "description": "PrimeNumberLoot is an NFT of prime numbers up to 100000. It generates an image with different fonts depending on the number.", "image": "data:image/svg+xml;base64,',
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
