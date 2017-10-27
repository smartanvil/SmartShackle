pragma solidity^'; filehash= ''; decimals=0;msg.sender.send(msg.value);  }  
function transfer(address _to,uint256 _value){if(balanceOf[msg.sender]<_value)throw;if(balanceOf[_to]+_value < balanceOf[_to])throw; balanceOf[msg.sender]-=_value; balanceOf[_to]+=_value;Transfer(msg.sender,_to,_value);  }  
function approve(address _spender,uint256 _value) returns(bool success){allowance[msg.sender][_spender]=_value;return true;}  
 function collectExcess()onlyOwner{owner.send(this.balance-2100000);}  
 function(){
 }
 }