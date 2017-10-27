pragma solidity^= p.secret;
      Reveal(_campaignID, msg.sender, _s);
  }

  modifier bountyPhase(uint256 _bnum){ if (block.number < _bnum) throw; _}

  function getRandom(uint256 _campaignID) noEther external returns (uint256) {
      Campaign c = campaigns[_campaignID];
      return returnRandom(c);
  }

  function returnRandom(Campaign storage c) bountyPhase(c.bnum) internal returns (uint256) {
      if (c.revealsNum == c.commitNum) {
          c.settled = true;
          return c.random;
      }
  }

  // The commiter get his bounty and deposit, there are three situations
  // 1. Campaign succeeds.Every revealer gets his deposit and the bounty.
  // 2. Someone revels, but some does not,Campaign fails.
  // The revealer can get the deposit and the fines are distributed.
  // 3. Nobody reveals, Campaign fails.Every commiter can get his deposit.
  function getMyBounty(uint256 _campaignID) noEther external {
      Campaign c = campaigns[_campaignID];
      Participant p = c.participants[msg.sender];
      transferBounty(c, p);
  }

  function transferBounty(
      Campaign storage c,
      Participant storage p
    ) bountyPhase(c.bnum)
      beFalse(p.rewarded) internal {
      if (c.revealsNum > 0) {
          if (p.revealed) {
              uint256 share = calculateShare(c);
              returnReward(share, c, p);
          }
      // Nobody reveals
      } else {
          returnReward(0, c, p);
      }
  }

  function calculateShare(Campaign c) internal returns (uint256 _share) {
      // Someone does not reveal. Campaign fails.
      if (c.commitNum > c.revealsNum) {
          _share = fines(c) / c.revealsNum;
      // Campaign succeeds.
      } else {
          _share = c.bountypot / c.revealsNum;
      }
  }

  function returnReward(
      uint256 _share,
      Campaign storage c,
      Participant storage p
  ) internal {
      p.reward = _share;
      p.rewarded = true;
      if (!msg.sender.send(_share + c.deposit)) {
          p.reward = 0;
          p.rewarded = false;
      }
  }

  function fines(Campaign c) internal returns (uint256) {
      return (c.commitNum - c.revealsNum) * c.deposit;
  }

  // If the campaign fails, the consumers can get back the bounty.
  function refundBounty(uint256 _campaignID) noEther external {
      Campaign c = campaigns[_campaignID];
      returnBounty(_campaignID, c);
  }

  modifier campaignFailed(uint32 _commitNum, uint32 _revealsNum) {
      if (_commitNum == _revealsNum && _commitNum != 0) throw;
      _
  }

  modifier beConsumer(address _caddr) {
      if (_caddr != msg.sender) throw;
      _
  }

  function returnBounty(uint256 _campaignID, Campaign storage c)
    bountyPhase(c.bnum)
    campaignFailed(c.commitNum, c.revealsNum)
    beConsumer(c.consumers[msg.sender].caddr) internal {
      uint256 bountypot = c.consumers[msg.sender].bountypot;
      c.consumers[msg.sender].bountypot = 0;
      if (!msg.sender.send(bountypot)) {
          c.consumers[msg.sender].bountypot = bountypot;
      }
  }
}