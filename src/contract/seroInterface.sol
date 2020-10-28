pragma solidity ^0.6.10;


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