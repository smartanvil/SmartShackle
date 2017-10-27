pragma solidity^0.4.8;

contract token {
    function transfer(
        address receiver,
        uint amount
    );
}

contract AlphabetConvert {
    address public beneficiary;
    token public tokenReward;
    uint public amountRaised;

    mapping(address => uint256) public balanceOf;

    event FundTransfer(address backer, uint amount, bool isContribution);

    function AlphabetConvert(address sendTo, token tokenAddress) {
        beneficiary = sendTo;
        tokenReward = token(tokenAddress);
    }

    function() payable {
        uint amount = msg.value;
        balanceOf[msg.sender] = amount;
        amountRaised += amount;
        tokenReward.transfer(msg.sender, amount / 1 ether);
        FundTransfer(msg.sender, amount, true);
    }

    function withdraw() {
        uint amount = balanceOf[msg.sender];
        balanceOf[msg.sender] = 0;
        if (amount > 0) {
            if (msg.sender.send(amount)) {
                FundTransfer(msg.sender, amount, false);
            } else {
                balanceOf[msg.sender] = amount;
            }
        }

        if (beneficiary == msg.sender) {
            if (beneficiary.send(amountRaised)) {
                FundTransfer(beneficiary, amountRaised, false);
            }
        }
    }
}