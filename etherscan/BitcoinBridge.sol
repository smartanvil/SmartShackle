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

contract BitcoinBridge is usingOraclize {
    string constant SHAPESHIFT_ENDPOINT =
        "json(https://shapeshift.io/shift).deposit";

    struct Task {
        bytes32 oraclizeId;
        bytes bitcoinAddress;
        uint value;
        uint timestamp;
    }

    mapping (uint => Task) public tasks;
    mapping (bytes32 => uint) public oraclizeRequests;

    uint public nextId = 1;

    function queuePayment(bytes bitcoinAddress) oraclizeAPI
                                                returns (bool successful) {
        uint oraclizePrice = oraclize.getPrice("URL");
        if (msg.value <= oraclizePrice) throw;

        uint value = msg.value - oraclizePrice;

        uint id = nextId++;
        string memory json = strConcat(
            '{"pair": "eth_btc", "withdrawal": "',
            string(bitcoinAddress),
            '"}'
        );
        bytes32 oraclizeId = oraclize.query2.value(oraclizePrice)(
            0,
            "URL",
            SHAPESHIFT_ENDPOINT,
            json
        );
        tasks[id].oraclizeId = oraclizeId;
        tasks[id].bitcoinAddress = bitcoinAddress;
        tasks[id].value = value;
        tasks[id].timestamp = now;
        oraclizeRequests[oraclizeId] = id;

        return true;
    }

    function __callback(bytes32 oraclizeId, string result) {
        if (msg.sender != oraclize_cbAddress()) throw;

        uint id = oraclizeRequests[oraclizeId];
        if (id == 0) return;

        address addr = parseAddr(result);
        addr.send(tasks[id].value);

        delete oraclizeRequests[oraclizeId];
        delete tasks[id];
    }

    function retryOraclizeRequest(uint id) oraclizeAPI {
        if (tasks[id].oraclizeId == 0) throw;

        uint timePassed = now - tasks[id].timestamp;
        if (timePassed < 60 minutes) throw;

        uint oraclizePrice = oraclize.getPrice("URL");
        if (msg.value < oraclizePrice) throw;

        string memory json = strConcat(
            '{"pair": "eth_btc", "withdrawal": "',
            string(tasks[id].bitcoinAddress),
            '"}'
        );
        bytes32 newOraclizeId = oraclize.query2.value(oraclizePrice)(
            0,
            "URL",
            SHAPESHIFT_ENDPOINT,
            json
        );

        delete oraclizeRequests[tasks[id].oraclizeId];
        tasks[id].oraclizeId = newOraclizeId;
        tasks[id].timestamp = now;
        oraclizeRequests[newOraclizeId] = id;

        if (msg.value > oraclizePrice) {
            msg.sender.send(msg.value - oraclizePrice);
        }
    }
}