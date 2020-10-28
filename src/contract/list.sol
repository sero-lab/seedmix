pragma solidity ^0.6.10;

pragma experimental ABIEncoderV2;


library LibMap {
	
	struct itMapUint256 {
		mapping(uint256 => uint256) keyToIndex;
		uint256[] keys;
	}
	
	function remove(itMapUint256 storage self, uint256 key) internal returns (bool success) {
		uint256  keyIndex = self.keyToIndex[key];
		if (keyIndex == 0)
			return false;
		if (keyIndex <= self.keys.length) {
			// Move an existing element into the vacated key slot.
			self.keyToIndex[self.keys[self.keys.length - 1]] = keyIndex;
			self.keys[keyIndex - 1] = self.keys[self.keys.length - 1];
			self.keys.pop();
			delete self.keyToIndex[key];
			return true;
		}
	}
	
	function upSert(itMapUint256 storage self, uint256 key) internal returns (bool success) {
		
		uint256 keyIndex = self.keyToIndex[key];
		
		if (keyIndex == 0) {
			
			self.keyToIndex[key]=self.keys.length+1;
			
			self.keys.push(key);
		}
		return true;
	}
	
	function size(itMapUint256 storage self) internal view returns (uint256) {
		return self.keys.length;
	}
	
	function getKeyByIndex(itMapUint256 storage self, uint256 idx) internal view returns (uint256) {
		return self.keys[idx];
	}
	
	
	function all(itMapUint256 storage self) internal view returns(uint256[] memory result){
		result = new uint256[](size(self));
		uint256 index = 0;
		for(uint256 i = size(self);i>0;i--){
			result[index]= getKeyByIndex(self,i-1);
			index++;
		}
	}
}
