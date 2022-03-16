// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;

library UnifapV2Library {
    function sortPairs(address token0, address token1)
        internal
        pure
        returns (address, address)
    {
        return token0 < token1 ? (token0, token1) : (token1, token0);
    }
}
