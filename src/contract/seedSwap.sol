pragma solidity ^0.6.10;

pragma experimental ABIEncoderV2;


import "./seroInterface.sol";

import "./safeMath.sol";

import "./list.sol";

import "./IToken.sol";

contract SeedMixSwap  is SeroInterface  {
	
	address public owner;
	
	using SafeMath for uint256;
	
	using LibMap for *;
	
	uint256 constant UNIT = 1 days;//prod 1 days;test 5*60
	
	string constant SERO_COIN = "SERO";
	
	string constant SEEDMIX_COIN = "SEEDMIX";

	uint256 constant COIN_UNIT = 1e18;
	
	uint256 constant RATIO=100;
	
	bool public pause = false;
	
	IToken seed;
	
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
	
	struct ExchangeBalance {
		uint256 backedValue;
		uint256 withDrawValue;
		uint256 returnValue;
	}
	
	Record[] public records;
	
	mapping(address => ExchangeBalance) myExchangeBalance;
	
	mapping(address => uint256[]) myRecords;
	
	mapping(address=>LibMap.itMapUint256) myValidRecords;
	
    uint256[] withDrawRatio = [14,13,12,11,10,10,9,8,7,6];

	
	constructor(
		address seedToken
	) public  {
		
		seed =IToken(seedToken);
		
		owner = msg.sender;
		
		records.push(Record(address(0),0,0,0));
	}

	
	function transferSeed(address newAddress) public {
		
		require(msg.sender == owner,"not owner");
		
		seed.setApprover(newAddress);
	}
	
	function setPause(bool _pause) public {
		
		require(msg.sender == owner,"not owner");
		pause = _pause;
		
	}
	
	
	function len() public view returns(uint256){
		return records.length;
	}
	
	
	/**
	 * mint
	 */
	function _mint(uint256 total) internal{
		
		seed.mint(total);
		
	}
	
	
	function equals(string memory a, string memory b) internal pure returns (bool) {
		if (bytes(a).length != bytes(b).length) {
			return false;
		}
		for (uint i = 0; i < bytes(a).length; i ++) {
			if(bytes(a)[i] != bytes(b)[i]) {
				return false;
			}
		}
		return true;
	}
	
	function _burned(uint256 amount)internal {
		sero_setCallValues(SEEDMIX_COIN,amount,"",0);
		seed.burned();
	}
	
	function myValidRecordInfo()public view returns(RecordInfo[] memory result){
		uint256[] memory indexs = myValidRecords[msg.sender].all();
		result = new RecordInfo[](indexs.length);
		for(uint256 i= 0;i< indexs.length;i++){
			result[i] = RecordInfo(indexs[i],records[indexs[i]]);
		}
		return result;
	}
	
	function myRecordInfo()public view returns(RecordInfo[] memory result){
		uint256[] memory rs = myRecords[msg.sender];
		uint256 size = rs.length;
		result = new RecordInfo[](size);
		for(uint256 i= 0;i< size;i++){
			result[size-i-1] = RecordInfo(rs[i],records[rs[i]]);
		}
		return result;
	}
	
	
	function calWithdrawIndex(uint256 index,uint256 currentTime) public view returns(uint256 begin,uint256 end){
		require(index>0 && index <  records.length,"invalid index");
		if (currentTime == 0){
			currentTime = now;
		}
		
		Record memory record = records[index];
		
		if (record.lastWithDrawTime > 0){
			
			begin = (record.lastWithDrawTime - record.createTime)/UNIT + 1;
		}
		
		
		end = (currentTime-record.createTime)/UNIT + 1;
		
		if (end > withDrawRatio.length){
			end = withDrawRatio.length;
		}
		
	}
	
	function _recordEndTime(uint256 index) internal view returns(uint256){
		Record memory record = records[index];
		return record.createTime + UNIT * (withDrawRatio.length-1);
	}
	
	function withDraw(uint256 index) public returns(uint256) {
		
		require(index>0 && index < records.length,"invalid index");
		
		Record storage record = records[index];
		
		uint256 currentTime = now;
		
		(uint256 begin,uint256 end) = calWithdrawIndex(index,currentTime);
		
		require(begin<end,"has closed");
		
		uint256 sendValue = 0;
		
		record.lastWithDrawTime = currentTime;
		
		
		for(uint256 i=begin;i<end;i++){
			sendValue = sendValue.add(record.total.mul(withDrawRatio[i]).div(100));
		}
		
		_mint(sendValue);
		
		myExchangeBalance[msg.sender].withDrawValue = myExchangeBalance[msg.sender].withDrawValue.add(sendValue);
		
		require(sero_send_token(record.owner,SEEDMIX_COIN,sendValue),"send failed");
		
		return sendValue;
	}
	
	function exchange() public payable returns(uint256){
		
		string memory cy = sero_msg_currency();
		
		if (equals(cy,SERO_COIN)){
			
			require(!pause,"paused");
			
			
			require(msg.value >0 && msg.value % (COIN_UNIT*RATIO) == 0,"msg.value too small");
			
			
			uint256 seedValue = msg.value.div(RATIO);
			
			Record memory record = Record(msg.sender,now,0,seedValue);
			
			uint256 index  = records.length;
			
			records.push(record);
			
			myValidRecords[msg.sender].upSert(index);
			
			myRecords[msg.sender].push(index);
			
			myExchangeBalance[msg.sender].backedValue = myExchangeBalance[msg.sender].backedValue.add(msg.value);
			
			return seedValue;
			
		}else if (equals(cy,SEEDMIX_COIN)){
			
			require(msg.value >0 && msg.value % COIN_UNIT == 0,"msg.value too small");
			
			require(myExchangeBalance[msg.sender].returnValue.add(msg.value) <= myExchangeBalance[msg.sender].withDrawValue,"msg.value to big");
			
			_burned(msg.value);
			
			myExchangeBalance[msg.sender].returnValue = myExchangeBalance[msg.sender].returnValue.add(msg.value);
			
			uint256 sendValue = msg.value.mul(RATIO);
			
			require(sero_send_token(msg.sender,SERO_COIN,sendValue),"send sero failed");
			
			return sendValue;
			
		}else {
			require(false,"not support cy");
		}
	}
	
	
	function myExchangeValue()public view returns(uint256 backedValue,uint256 withDrawValue,uint256 returnValue){
		backedValue = myExchangeBalance[msg.sender].backedValue;
		withDrawValue = myExchangeBalance[msg.sender].withDrawValue;
		returnValue = myExchangeBalance[msg.sender].returnValue;
		return (backedValue,withDrawValue,returnValue);
	}

	receive() external payable {

	}

}