pragma solidity ^0.6.10;

pragma experimental ABIEncoderV2;

interface IToken {
	
	function mint(uint256 total) external ;
	
	function burned()external payable;
	
	function setApprover(address newApprover) external;
}