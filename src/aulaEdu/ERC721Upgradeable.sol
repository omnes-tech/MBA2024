// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC721Upgradeable} from "https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/v5.0.2/contracts/token/ERC721/ERC721Upgradeable.sol";
import {UUPSUpgradeable} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/proxy/utils/UUPSUpgradeable.sol";

contract NFT is ERC721Upgradeable, UUPSUpgradeable {
    function initialize(
        string memory name_,
        string memory symbol_
    ) external initializer {
        __ERC721_init(name_, symbol_);
    }

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }

    function nameAndSymbol()
        external
        view
        returns (string memory, string memory)
    {
        return (name(), symbol());
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}
