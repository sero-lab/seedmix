pragma solidity ^0.6.10;

pragma experimental ABIEncoderV2;

interface ISeed {
	struct Record {
		address owner;
		uint256 createTime;
		uint256 lastWithDrawTime;
		uint256 total;
	}
	
	struct RecordInfo{
		uint256 index;
		Record data;
	}
	
	function withDraw(uint256 index) external returns(uint256);
	
	function exchange() external payable returns(uint256) ;
	
	function myRecordInfo()external view returns(RecordInfo[] memory result);
	
	function myValidRecordInfo()external view returns(RecordInfo[] memory result);
	
	function myExchangeValue()external view returns(uint256 backedValue,uint256 claimantValue);
}