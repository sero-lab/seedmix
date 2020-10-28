pragma solidity ^0.6.10;

library SafeMath {
	
	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		require(c >= a, "SafeMath: addition overflow");
		
		return c;
	}
	
	
	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		return sub(a, b, "SafeMath: subtraction overflow");
	}
	
	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
		require(b <= a, errorMessage);
		uint256 c = a - b;
		
		return c;
	}
	
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		
		if (a == 0) {
			return 0;
		}
		
		uint256 c = a * b;
		require(c / a == b, "SafeMath: multiplication overflow");
		
		return c;
	}
	
	
	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		return div(a, b, "SafeMath: division by zero");
	}
	
	
	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
		// Solidity only automatically asserts when dividing by 0
		require(b > 0, errorMessage);
		uint256 c = a / b;
		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
		
		return c;
	}
	
}


contract SeroInterface {
	
	bytes32 private topic_sero_issueToken = 0x3be6bf24d822bcd6f6348f6f5a5c2d3108f04991ee63e80cde49a8c4746a0ef3;
	bytes32 private topic_sero_balanceOf = 0xcf19eb4256453a4e30b6a06d651f1970c223fb6bd1826a28ed861f0e602db9b8;
	bytes32 private topic_sero_send = 0x868bd6629e7c2e3d2ccf7b9968fad79b448e7a2bfb3ee20ed1acbc695c3c8b23;
	bytes32 private topic_sero_currency = 0x7c98e64bd943448b4e24ef8c2cdec7b8b1275970cfe10daf2a9bfa4b04dce905;
	bytes32 private topic_sero_setCallValues  =  0xa6cafc6282f61eff9032603a017e652f68410d3d3c69f0a3eeca8f181aec1d17;
	
	
	function bytes32ToString(bytes32 x) internal pure returns (string memory) {
		uint charCount = 0;
		bytes memory bytesString = new bytes(32);
		for (uint j = 0; j < 32; j++) {
			byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
			if (char != 0) {
				bytesString[charCount] = char;
				charCount++;
			} else if (charCount != 0) {
				break;
			}
		}
		bytes memory bytesStringTrimmed = new bytes(charCount);
		for (uint j = 0; j < charCount; j++) {
			bytesStringTrimmed[j] = bytesString[j];
			
		}
		return string(bytesStringTrimmed);
	}
	
	function sero_msg_currency() internal returns (string memory) {
		bytes memory tmp = new bytes(32);
		bytes32 b32;
		assembly {
			log1(tmp, 0x20, sload(topic_sero_currency_slot))
			b32 := mload(tmp)
		}
		return bytes32ToString(b32);
	}
	
	
	function sero_setCallValues(string memory _currency, uint256 _amount, string memory _category, bytes32 _ticket) internal {
		bytes memory temp = new bytes(0x80);
		assembly {
			mstore(temp, _currency)
			mstore(add(temp, 0x20), _amount)
			mstore(add(temp, 0x40), _category)
			mstore(add(temp, 0x60), _ticket)
			log1(temp, 0x80, sload(topic_sero_setCallValues_slot))
		}
		return;
	}
	
	
	function sero_send_token(address _receiver, string memory _currency, uint256 _amount) internal returns (bool success){
		return sero_send(_receiver, _currency, _amount, "", 0);
	}
	
	function sero_send(address _receiver, string memory _currency, uint256 _amount, string memory _category, bytes32 _ticket) internal returns (bool success){
		bytes memory temp = new bytes(160);
		assembly {
			mstore(temp, _receiver)
			mstore(add(temp, 0x20), _currency)
			mstore(add(temp, 0x40), _amount)
			mstore(add(temp, 0x60), _category)
			mstore(add(temp, 0x80), _ticket)
			log1(temp, 0xa0, sload(topic_sero_send_slot))
			success := mload(add(temp, 0x80))
		}
		return success;
	}
	
	
	function sero_issueToken(uint256 _total,string memory _currency) internal returns (bool success){
		bytes memory temp = new bytes(64);
		assembly {
			mstore(temp, _currency)
			mstore(add(temp, 0x20), _total)
			log1(temp, 0x40, sload(topic_sero_issueToken_slot))
			success := mload(add(temp, 0x20))
		}
		return success;
	}
	
	function sero_balanceOf(string memory _currency) internal returns (uint256 amount){
		bytes memory temp = new bytes(32);
		assembly {
			mstore(temp, _currency)
			log1(temp, 0x20, sload(topic_sero_balanceOf_slot))
			amount := mload(temp)
		}
		return amount;
	}
}

contract SeedControl {
	
	
	address public owner;
	
	address public approver;
	
	address public operator;
	
	
	constructor() public {
		owner = msg.sender;
		operator = msg.sender;
	}
	
	modifier onlyOwner() {
		require(msg.sender == owner,"not owner");
		_;
	}
	
	modifier onlyApprover() {
		require(msg.sender == approver,"not approver");
		_;
	}
	
	
	function transferOwnership(address newOwner) public onlyOwner {
		if (newOwner != address(0)) {
			owner = newOwner;
		}
	}
	
	function delOperator() public onlyOwner {
		operator = address(0);
	}
	
	function setApprover(address newApprover) public {
		
		require(newApprover != address(0),"invalid approver");
		
		require(msg.sender == operator || msg.sender == approver,"invalid msg.sender");
		
		approver = newApprover;
	}
}


contract SeedMix  is SeroInterface,SeedControl  {
	
	using SafeMath for uint256;
	
	
	string private _name;
	string private _symbol;
	uint8 private _decimals;
	uint256 private _totalSupply;
	
	constructor(
	) public payable{
		
		_totalSupply = 0;
		
		_name = "SEEDMIX";
		
		_symbol = "SEEDMIX";
		
		_decimals = 18;
		
		require(sero_issueToken(_totalSupply,_symbol));
		
	}
	
	/**
	 * @return the name of the token.
	 */
	function name() public view returns (string memory) {
		return _name;
	}
	
	/**
	 * @return the symbol of the token.
	 */
	function symbol() public view returns (string memory) {
		return _symbol;
	}
	
	/**
	 * @return the number of decimals of the token.
	 */
	function decimals() public view returns (uint8) {
		return _decimals;
	}
	
	function totalSupply() public view returns (uint256) {
		return _totalSupply;
	}
	
	
	
	function mint(uint256 total) public onlyApprover {
		
		uint256 currentBalance = sero_balanceOf(_symbol);
		
		if (currentBalance<total){
			
			uint256 _mintAmount =total.sub(currentBalance);
			
			require(sero_issueToken(_mintAmount,_symbol));
			
		}
		
		_totalSupply = _totalSupply.add(total);
		
		require(sero_send_token(msg.sender,_symbol,total));
		
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
	
	
	function burned()public payable {
		
		string memory cy = sero_msg_currency();
		
		require(equals(cy,_symbol),"not supported cy");
		
		_totalSupply = _totalSupply.sub(msg.value);
		
	}
	
	
}