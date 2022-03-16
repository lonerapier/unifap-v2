// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.10;

import "./UnifapV2Pair.sol";

error IdenticalTokens();
error InvalidToken();
error PairAlreadyExists();

import "./interfaces/IUnifapV2Pair.sol";

contract UnifapV2Factory {
	mapping(address => mapping(address => address)) public pairs;
	address[] public allPairs;

	event PairCreated(address indexed token0, address indexed token1, address pair, uint);

	function createPair(address tokenA, address tokenB) public returns (address pair) {
		if (tokenA == tokenB) revert IdenticalTokens();

		(address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

		if (token0 == address(0)) revert InvalidToken();
		if (pairs[token0][token1] != address(0)) revert PairAlreadyExists();

		bytes memory bytecode = type(UnifapV2Pair).creationCode;
		bytes32 salt = keccak256(abi.encodePacked(token0, token1));
		assembly {
			pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
		}

		IUnifapV2Pair(pair).initialize(token0, token1);

		pairs[token0][token1] = pair;
		pairs[token1][token0] = pair;
		allPairs.push(pair);

		emit PairCreated(token0, token1, pair, allPairs.length);
	}
}