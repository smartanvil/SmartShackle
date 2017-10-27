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


contract Ethereum_twelve_bagger is usingOraclize
{

 							//declares global variables
string hexcomparisonchr;
string A;
string B;

uint8 lotteryticket;
address creator;
int lastgainloss;
string lastresult;
string K;
string information;
  
 
address player;
uint8 gameResult;
uint128 wager; 
 mapping (bytes32=>uint) bets;
mapping (bytes32 => address) gamesPlayer;
 

   function  Ethereum_twelve_bagger() private 
    { 
        creator = msg.sender; 								
    }

    function Set_your_game_number_between_1_15(string Set_your_game_number_between_1_15)			//sets game number
 {
	player=msg.sender;
    	A=Set_your_game_number_between_1_15;
	wager =uint128(msg.value);
	
	lastresult = "Waiting for a lottery number from Wolfram Alpha";
	lastgainloss = 0;
	B="The new right lottery number is not ready yet";
	information = "The new right lottery number is not ready yet";
	testWager();
	
	WolframAlpha();
}

     	 
	 
	


    

    function WolframAlpha() private {
	if (wager == 0) return;		//if wager is 0, abort 
        
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
     	bytes32 myid =  oraclize_query(0,"WolframAlpha", "random number between 1 and 15");
	bets[myid] = wager;
	gamesPlayer[myid] = player;
    }

 	    function __callback(bytes32 myid, string result, bytes proof) {
        if (msg.sender != oraclize_cbAddress()) throw;
	
        B = result;
	
	wager=uint128(bets[myid]);
	player=gamesPlayer[myid];
	test(A,B);
	returnmoneycreator(gameResult,wager);
	return;
        
}
 
function test(string A,string B) private
{ 
information ="The right lottery number is now ready. One Eth is 10**18 Wei.";
K="K";
bytes memory test = bytes(A);
bytes memory kill = bytes(K);
	 if (test[0]==kill[0] && player == creator)			//Creator can kill contract. Contract does not hold players money.
	{
		suicide(creator);} 
 
    	
    


if (equal(A,B))
{
lastgainloss =(12*wager);
	    	lastresult = "Win!";
	    	player.send(wager * 12);  

gameResult=0;
return;}
else 
{
lastgainloss = int(wager) * -1;
	    	lastresult = "Loss";
	    	gameResult=1;
	    									// Player lost. Return nothing.
	    	return;


 
	}
}


 
function testWager() private
{if((wager*12) > this.balance) 					// contract has to have 12*wager funds to be able to pay out. (current balance includes the wager sent)
    	{
    		lastresult = "Bet is larger than games's ability to pay";
    		lastgainloss = 0;
    		player.send(wager); // return wager
		gameResult=0;
		wager=0;
		B="Bet is larger than games's ability to pay";
		information ="Bet is larger than games's ability to pay";
    		return;
}

else if (wager < 100000000000000000)					// Minimum bet is 0.1 eth 
    	{
    		lastresult = "Minimum bet is 0.1 eth";
    		lastgainloss = 0;
    		player.send(wager); // return wager
		gameResult=0;
		wager=0;
		B="Minimum bet is 0.1 eth";
		information ="Minimum bet is 0.1 eth";
    		return;
}




	else if (wager == 0)
    	{
    		lastresult = "Wager was zero";
    		lastgainloss = 0;
		gameResult=0;
    		// nothing wagered, nothing returned
    		return;
    	}
}



    /// @dev Does a byte-by-byte lexicographical comparison of two strings.
    /// @return a negative number if `_a` is smaller, zero if they are equal
    /// and a positive numbe if `_b` is smaller.
    function compare(string A, string B) private returns (int) {
        bytes memory a = bytes(A);
        bytes memory b = bytes(B);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
    /// @dev Compares two strings and returns true iff they are equal.
    function equal(string A, string B) private returns (bool) 
       {
        return compare(A, B) == 0;
}

function returnmoneycreator(uint8 gameResult,uint wager) private		//If game has over 50 eth, contract will send all additional eth to owner
	{
	if (gameResult==1&&this.balance>50000000000000000000)
	{creator.send(wager);
	return; 
	}
 
	else if
	(
	gameResult==1&&this.balance>20000000000000000000)				//If game has over 20 eth, contract will send œ of any additional eth to owner
	{creator.send(wager/2);
	return; }
	}
 
/**********
functions below give information about the game in Ethereum Wallet
 **********/
 
 	function Results_of_the_last_round() constant returns (uint players_bet_in_Wei, string last_result,string Last_player_s_lottery_ticket,address last_player,string The_right_lottery_number,int Player_s_gain_or_Loss_in_Wei,string info)
    { 
   	last_player=player;	
	Last_player_s_lottery_ticket=A;
	The_right_lottery_number=B;
	last_result=lastresult;
	players_bet_in_Wei=wager;
	Player_s_gain_or_Loss_in_Wei=lastgainloss;
	info = information;
	
 
    }

 
    
   
	function Game_balance_in_Ethers() constant returns (uint balance, string info)
    { 
        info = "Choose number between 1 and 15. Win pays wager*12. Minimum bet is 0.1 eth. Maximum bet is game balance/12. Game balance is shown in full Ethers.";
    	balance=(this.balance/10**18);

    }
    
   
}