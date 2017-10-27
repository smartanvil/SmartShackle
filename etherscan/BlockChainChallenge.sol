pragma solidity^ leaderHash) > difficulty)
          return false;

        //If player survived the checks, they've overcome difficulty level and beat the leader.
        //Update the difficulty. This makes the game progressively harder through the week.
        difficulty = (challengeHash ^ leaderHash);
        
        //Did they set a record?
        challengeWorldRecord(difficulty);
        
        //We have a new Leader
        leader = msg.sender;
        
        //The winning hash is our new hash. This undoes any work being done by competition!
        leaderHash = challengeHash;
        
        //Announce our new victor. Congratulations!    
        Leader("New leader! This is their address, and the new hash to collide.", leader, leaderHash);
        
        //Add to historical Winners
        winners[msg.sender]++;
        
        //Keep track of how many new leaders we've had this week.
        fallenLeaders++;
        
        return true;
  }
  
  function challengeWorldRecord (bytes32 difficultyChallenge) private {
      if(difficultyChallenge < difficultyWorldRecord) {
        difficultyWorldRecord = difficultyChallenge;
        WorldRecord("A record setting collision occcured!", difficultyWorldRecord, msg.sender);
      }
  }
  
  function changeLeaderMessage(string newMessage){
        //The leader gets to talk all kinds of shit. If abuse, might remove.
        if(msg.sender == leader)
            leaderMessage = newMessage;
  }
  
  //The following functions designed for mist UI
  function currentLeader() constant returns (address CurrentLeaderAddress){
      return leader;
  }
  function Difficulty() constant returns (bytes32 XorMustBeLessThan){
      return difficulty;
  }
  function TargetHash() constant returns (bytes32 leadingHash){
      return leaderHash;
  }
  function LeaderMessage() constant returns (string MessageOfTheDay){
      return leaderMessage;
  }
  function FallenLeaders() constant returns (uint Victors){
      return fallenLeaders;
  }
  function GameEnds() constant returns (uint EndingTime){
      return startingTime + gameLength;
  }
  function getWins(address check) constant returns (uint wins){
      return winners[check];
  }

  function kill(){
      if (msg.sender == admin){
        GameOver("The challenge has ended.");
        selfdestruct(admin);
      }
  }
}