// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token0 is ERC20 {
    constructor() ERC20("Token0", "T0") {
        this;
    }

    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
    }

    event Testing(address from);

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        emit Testing(from);
    }
}

contract Token1 is ERC20 {
    constructor() ERC20("Token1", "T1") {
        this;
    }

    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
    }
}
