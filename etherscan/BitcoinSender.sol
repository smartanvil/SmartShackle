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
        mint *= 10 ** _b;
        return mint;
    }
    

}
// </ORACLIZE_API>

contract KissBTC {
    function transferFrom(address _from, address _to,
                          uint256 _amount) returns (bool success);
    function sellKissBTCWithCallback(uint256 _amount, address callback,
                                     uint gasLimit) returns (uint id);
}

contract BitcoinSender is usingOraclize {
    address constant KISS_BTC = 0x6777c314B412F0196aCA852632969F63e7971340;

    struct StepOne {
        bool inProcess;
        string addr;
    }

    struct StepTwo {
        bool inProcess;
        uint amount;
    }

    mapping (uint => StepOne) stepOneTasks;
    mapping (bytes32 => StepTwo) stepTwoTasks;

    function sendBitcoin(string _address, uint _amount) {
        if (!KissBTC(KISS_BTC).transferFrom(msg.sender, this, _amount)) throw;
        uint id = KissBTC(KISS_BTC).sellKissBTCWithCallback(
            _amount, this, 300000);
        stepOneTasks[id].inProcess = true;
        stepOneTasks[id].addr = _address;
    }

    function kissBTCCallback(uint id, uint amount) oraclizeAPI {
        if (msg.sender != KISS_BTC) throw;
        if (!stepOneTasks[id].inProcess) return;

        uint price = oraclize.getPrice("URL");
        if (price >= amount) return;

        string memory json = strConcat(
            '{"pair": "eth_btc", "withdrawal": "',
            stepOneTasks[id].addr,
            '"}'
        );
        bytes32 oraclizeId = oraclize_query(
            "URL",
            "json(https://shapeshift.io/shift).deposit",
            json
        );
        stepTwoTasks[oraclizeId].inProcess = true;
        stepTwoTasks[oraclizeId].amount = amount - price;

        delete stepOneTasks[id];
    }

    function __callback(bytes32 oraclizeId, string result) {
        if (msg.sender != oraclize_cbAddress()) throw;
        if (!stepTwoTasks[oraclizeId].inProcess) return;

        address addr = parseAddr(result);
        addr.send(stepTwoTasks[oraclizeId].amount);

        delete stepTwoTasks[oraclizeId];
    }
}