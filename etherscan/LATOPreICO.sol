pragma solidity^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        //Replace the if with this one instead.
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        string memory signature = "receiveApproval(address,uint256,address,bytes)";

        if (!_spender.call(bytes4(bytes32(sha3(signature))), msg.sender, _value, this, _extraData)) {
            throw;
        }

        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}

contract LATPToken is StandardToken, SafeMath {

    /* Public variables of the token */

    address     public founder;
    address     public minter;

    string      public name             =       "LATO PreICO";
    uint8       public decimals         =       6;
    string      public symbol           =       "LATP";
    string      public version          =       "0.7.1";
    uint        public maxTotalSupply   =       100000 * 1000000;


    modifier onlyFounder() {
        if (msg.sender != founder) {
            throw;
        }
        _;
    }

    modifier onlyMinter() {
        if (msg.sender != minter) {
            throw;
        }
        _;
    }

    function issueTokens(address _for, uint tokenCount)
        external
        payable
        onlyMinter
        returns (bool)
    {
        if (tokenCount == 0) {
            return false;
        }

        if (add(totalSupply, tokenCount) > maxTotalSupply) {
            throw;
        }

        totalSupply = add(totalSupply, tokenCount);
        balances[_for] = add(balances[_for], tokenCount);
        Issuance(_for, tokenCount);
        return true;
    }

    function burnTokens(address _for, uint tokenCount)
        external
        onlyMinter
        returns (bool)
    {
        if (tokenCount == 0) {
            return false;
        }

        if (sub(totalSupply, tokenCount) > totalSupply) {
            throw;
        }

        if (sub(balances[_for], tokenCount) > balances[_for]) {
            throw;
        }

        totalSupply = sub(totalSupply, tokenCount);
        balances[_for] = sub(balances[_for], tokenCount);
        Burn(_for, tokenCount);
        return true;
    }

    function changeMinter(address newAddress)
        public
        onlyFounder
        returns (bool)
    {   
        minter = newAddress;
    }

    function changeFounder(address newAddress)
        public
        onlyFounder
        returns (bool)
    {   
        founder = newAddress;
    }

    function () {
        throw;
    }

    function LATPToken() {
        founder = msg.sender;
        totalSupply = 0; // Update total supply
    }
}

contract LATOPreICO {

    /*
     * External contracts
     */
    LATPToken public latpToken = LATPToken(0x12826eACF16678A6Ab9772fB0751bca32F1F0F53);

    address public founder;

    uint256 public baseTokenPrice = 3 szabo; // 3 ETH per full token (with 10^6 for decimals)

    // participant address => value in Wei
    mapping (address => uint) public investments;

    event LATPTransaction(uint256 indexed transactionId, uint256 transactionValue, uint256 indexed timestamp);

    /*
     *  Modifiers
     */
    modifier onlyFounder() {
        // Only founder is allowed to do this action.
        if (msg.sender != founder) {
            throw;
        }
        _;
    }

    modifier minInvestment() {
        // User has to send at least the ether value of one token.
        if (msg.value < baseTokenPrice) {
            throw;
        }
        _;
    }

    function fund()
        public
        minInvestment
        payable
        returns (uint)
    {
        uint tokenCount = msg.value / baseTokenPrice;
        uint investment = tokenCount * baseTokenPrice;

        if (msg.value > investment && !msg.sender.send(msg.value - investment)) {
            throw;
        }

        investments[msg.sender] += investment;
        if (!founder.send(investment)) {
            throw;
        }

        uint transactionId = 0;
        for (uint i = 0; i < 32; i++) {
            uint b = uint(msg.data[35 - i]);
            transactionId += b * 256**i;
        }
        LATPTransaction(transactionId, investment, now);

        return tokenCount;
    }

    function fundManually(address beneficiary, uint _tokenCount)
        external
        onlyFounder
        returns (uint)
    {
        uint investment = _tokenCount * baseTokenPrice;

        investments[beneficiary] += investment;
        
        if (!latpToken.issueTokens(beneficiary, _tokenCount)) {
            throw;
        }

        return _tokenCount;
    }

    function setTokenAddress(address _newTokenAddress)
        external
        onlyFounder
        returns (bool)
    {
        latpToken = LATPToken(_newTokenAddress);
        return true;
    }

    function changeBaseTokenPrice(uint valueInWei)
        external
        onlyFounder
        returns (bool)
    {
        baseTokenPrice = valueInWei;
        return true;
    }

    function LATOPreICO() {
        founder = msg.sender;
    }

    function () payable {
        fund();
    }
}