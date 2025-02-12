// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "forge-std/Test.sol";
import "../src/DLCNode.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DLCNodeTest is Test {
    DLCNode public dlcNode;

    address public owner = address(0x1);
    address public user1 = address(0x2);
    address public user2 = address(0x3);

    function setUp() public {
        vm.startPrank(owner);

        ERC1967Proxy proxy = new ERC1967Proxy(address(new DLCNode()), "");
        DLCNode(address(proxy)).initialize(owner);
        dlcNode = DLCNode(address(proxy));

        uint256[] memory levels = new uint256[](3);
        levels[0] = 1;
        levels[1] = 2;
        levels[2] = 3;

        dlcNode.setMinterForLevels(address(this), levels);
        vm.stopPrank();
    }

    function testGetBalance() public {
        uint256[] memory mintLevels = new uint256[](3);
        mintLevels[0] = 1;
        mintLevels[1] = 2;
        mintLevels[2] = 3;

        uint256[] memory mintAmounts = new uint256[](3);
        mintAmounts[0] = 5;
        mintAmounts[1] = 10;
        mintAmounts[2] = 15;

        dlcNode.batchMint(user1, mintLevels, mintAmounts);

        uint256 queryAmount = 20;
        (uint256[] memory tokenIds, uint256[] memory amounts) = dlcNode.getBalance(user1, queryAmount);

        assertEq(tokenIds.length, 3);
        assertEq(amounts.length, 3);
        assertEq(tokenIds[0], 1);

        assertEq(amounts[0], 5);
        assertEq(tokenIds[1], 2);
        assertEq(amounts[1], 10);

        assertEq(tokenIds[2], 3);
        assertEq(amounts[2], 5);

        queryAmount = 5;
        (tokenIds, amounts) = dlcNode.getBalance(user1, queryAmount);
        assertEq(tokenIds.length, 1);
        assertEq(amounts.length, 1);
        assertEq(tokenIds[0], 1);
        assertEq(amounts[0], 5);

        queryAmount = 6;
        (tokenIds, amounts) = dlcNode.getBalance(user1, queryAmount);
        assertEq(tokenIds.length, 2);
        assertEq(amounts.length, 2);
        assertEq(tokenIds[0], 1);
        assertEq(amounts[0], 5);

        assertEq(tokenIds[1], 2);
        assertEq(amounts[1], 1);

        queryAmount = 3;
        (tokenIds, amounts) = dlcNode.getBalance(user1, queryAmount);
        assertEq(tokenIds.length, 1);
        assertEq(amounts.length, 1);
        assertEq(tokenIds[0], 1);
        assertEq(amounts[0], 3);

        queryAmount = 50;
        (tokenIds, amounts) = dlcNode.getBalance(user1, queryAmount);
        assertEq(tokenIds.length, 3);
        assertEq(amounts.length, 3);
        assertEq(tokenIds[0], 1);
        assertEq(amounts[0], 5);

        assertEq(tokenIds[1], 2);

        assertEq(amounts[1], 10);
        assertEq(tokenIds[2], 3);
        assertEq(amounts[2], 15);
    }

    function testGetBalance1() public {
        uint256[] memory mintLevels = new uint256[](2);
        mintLevels[0] = 1;
        mintLevels[1] = 2;

        uint256[] memory mintAmounts = new uint256[](2);
        mintAmounts[0] = 100;
        mintAmounts[1] = 30;

//        dlcNode.batchMint(user1, mintLevels, mintAmounts);
        dlcNode.mint(user1, 1, 20);
        dlcNode.mint(user1, 1, 100);
        dlcNode.mint(user1, 2, 30);

        uint256 queryAmount = 150;
        (uint256[] memory tokenIds, uint256[] memory amounts) = dlcNode.getBalance(user1, queryAmount);

        assertEq(tokenIds.length, 2);
        assertEq(amounts.length, 2);

        assertEq(tokenIds[0], 1,"11");
        assertEq(tokenIds[1], 2,"22");

        assertEq(amounts[0], 120,"33");
        assertEq(amounts[1], 30,"444");
    }

    function testGetBalanceEmptyAccount() public view {
        uint256 queryAmount = 10;
        (uint256[] memory tokenIds, uint256[] memory amounts) = dlcNode.getBalance(user2, queryAmount);

        assertEq(tokenIds.length, 0);
        assertEq(amounts.length, 0);
    }
}
