pragma solidity^0.4.11;

//Dentacoin token import
contract exToken {
  function transfer(address, uint256) returns (bool) {  }
  function balanceOf(address) constant returns (uint256) {  }
}


// Timelock
contract DentacoinTimeLock {

  uint constant public year = 2018;
  address public owner;
  uint public lockTime = 192 days;
  uint public startTime;
  uint256 lockedAmount;
  exToken public tokenAddress;

  modifier onlyBy(address _account){
    require(msg.sender == _account);
    _;
  }

  function () payable {}

  function DentacoinTimeLock() {

    //owner = msg.sender;
    owner = 0xd560Be7E053f6bDB113C2814Faa339e29f4a385f;  // Dentacoin Foundation owner
    startTime = now;
    tokenAddress = exToken(0x08d32b0da63e2C3bcF8019c9c5d849d7a9d791e6);
  }

  function withdraw() onlyBy(owner) {
    lockedAmount = tokenAddress.balanceOf(this);
    if ((startTime + lockTime) < now) {
      tokenAddress.transfer(owner, lockedAmount);
    } else { throw; }
  }
}