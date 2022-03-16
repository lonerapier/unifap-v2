// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.10;

interface IUnifapV2Factory {
	function createPair(address, address) external returns (address);
}