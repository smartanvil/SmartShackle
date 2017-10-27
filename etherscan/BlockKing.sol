pragma solidity^_b)
    function parseInt(string _a, uint _b) internal returns (uint) {
        bytes memory bresult = bytes(_a);
        uint mint = 0;
        bool decimals = false;
        for (uint i=0; i<bresult.length; i++){
            if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
                if (decimals){
                   if (_b == 0) break;
                    else _b--;
                }
                mint *= 10;
                mint += uint(bresult[i]) - 48;
            } else if (bresult[i] == 46) decimals = true;
        }
        return mint;
    }
    


}
// </ORACLIZE_API>

contract BlockKing is usingOraclize{

  address public owner;
  address public king;
  address public warrior;
  address public contractAddress;
  uint public rewardPercent;
  uint public kingBlock;
  uint public warriorBlock;
  uint public randomNumber;
  uint public singleDigitBlock;
  uint public warriorGold;

  // this function is executed at initialization
  function BlockKing() {
    owner = msg.sender;
    king = msg.sender;
    warrior = msg.sender;
    contractAddress = this;
    rewardPercent = 50;
    kingBlock = block.number;
    warriorBlock = block.number;
    randomNumber = 0;
    singleDigitBlock = 0;
    warriorGold = 0;
  }

  // fallback function - simple transactions trigger this
  function() {
    enter();
  }
  
  function enter() {
    // 100 finney = .05 ether minimum payment otherwise refund payment and stop contract
    if (msg.value < 50 finney) {
      msg.sender.send(msg.value);
      return;
    }
    warrior = msg.sender;
    warriorGold = msg.value;
    warriorBlock = block.number;
    bytes32 myid = oraclize_query(0, "WolframAlpha", "random number between 1 and 9");
  }

  function __callback(bytes32 myid, string result) {
    if (msg.sender != oraclize_cbAddress()) throw;
    randomNumber = uint(bytes(result)[0]) - 48;
    process_payment();
  }
  
  function process_payment() {
    // Check if there is a new Block King
    // by comparing the last digit of the block number
    // against the Oraclize.it random number.
    uint singleDigit = warriorBlock;
	while (singleDigit > 1000000) {
		singleDigit -= 1000000;
	} 
	while (singleDigit > 100000) {
		singleDigit -= 100000;
	} 
	while (singleDigit > 10000) {
		singleDigit -= 10000;
	} 
	while (singleDigit > 1000) {
		singleDigit -= 1000;
	} 
	while (singleDigit > 100) {
		singleDigit -= 100;
	} 
	while (singleDigit > 10) {
		singleDigit -= 10;
	} 
    // Free round for the king
	if (singleDigit == 10) {
		singleDigit = 0;
	} 
	singleDigitBlock = singleDigit;
	if (singleDigitBlock == randomNumber) {
      rewardPercent = 50;
      // If the payment was more than .999 ether then increase reward percentage
      if (warriorGold > 999 finney) {
	  	rewardPercent = 75;
	  }	
      king = warrior;
      kingBlock = warriorBlock;
    }

	uint calculatedBlockDifference = kingBlock - warriorBlock;
	uint payoutPercentage = rewardPercent;
	// If the Block King has held the position for more
	// than 2000 blocks then increase the payout percentage.
	if (calculatedBlockDifference > 2000) {
	  	payoutPercentage = 90;		
	}

    // pay reward to BlockKing
    uint reward = (contractAddress.balance * payoutPercentage)/100;  
    king.send(reward);
    	
    // collect fee
    owner.send(contractAddress.balance);
  }
  function kill() { if (msg.sender == owner) suicide(owner); }
}