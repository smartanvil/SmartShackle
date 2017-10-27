pragma solidity^3 founder
        incentives.push(Incentive(0x11666F3492F03c930682D0a11c93BF708d916ad7, 19)); // 0.019 * 10^3 core angel
        incentives.push(Incentive(0x6c31dE34b5df94F681AFeF9757eC3ed1594F7D9e, 19)); // 0.019 * 10^3 core angel
        incentives.push(Incentive(0x5becE8B6Cb3fB8FAC39a09671a9c32872ACBF267, 9));  // 0.009 * 10^3 core early
        incentives.push(Incentive(0x00DdD4BB955e0C93beF9b9986b5F5F330Fd016c6, 5));  // 0.005 * 10^3 misc
    }


    /**
     * Starts incentive distribution 
     *
     * Called by the crowdsale contract when tokenholders voted 
     * for the transfer of ownership of the token contract to DCorp
     * 
     * @return Whether the incentive distribution was started
     */
    function startIncentiveDistribution() onlyOwner returns (bool success) {
        if (!incentiveDistributionStarted) {
            incentiveDistributionDate = now + incentiveDistributionInterval;
            incentiveDistributionStarted = true;
        }

        return incentiveDistributionStarted;
    }


    /**
     * Distributes incentives over the core team members as 
     * described in the whitepaper
     */
    function withdrawIncentives() {

        // Crowdsale triggers incentive distribution
        if (!incentiveDistributionStarted) {
            throw;
        }

        // Enforce max distribution rounds
        if (incentiveDistributionRound > incentiveDistributionMaxRounds) {
            throw;
        }

        // Enforce time interval
        if (now < incentiveDistributionDate) {
            throw;
        }

        uint256 totalSupplyToDate = totalSupply;
        uint256 denominator = 1;

        // Incentive decreased each round
        if (incentiveDistributionRound > 1) {
            denominator = incentiveDistributionRoundDenominator**(incentiveDistributionRound - 1);
        }

        for (uint256 i = 0; i < incentives.length; i++) {

            // totalSupplyToDate * (percentage * 10^3) / 10^3 / denominator
            uint256 amount = totalSupplyToDate * incentives[i].percentage / 10**3 / denominator; 
            address recipient =  incentives[i].recipient;

            // Create tokens
            balances[recipient] += amount;
            totalSupply += amount;

            // Notify listners
            Transfer(0, this, amount);
            Transfer(this, recipient, amount);
        }

        // Next round
        incentiveDistributionDate = now + incentiveDistributionInterval;
        incentiveDistributionRound++;
    }


    /**
     * Unlocks the token irreversibly so that the transfering of value is enabled 
     *
     * @return Whether the unlocking was successful or not
     */
    function unlock() onlyOwner returns (bool success)  {
        locked = false;
        return true;
    }


    /**
     * Issues `_value` new tokens to `_recipient` (_value < 0 guarantees that tokens are never removed)
     *
     * @param _recipient The address to which the tokens will be issued
     * @param _value The amount of new tokens to issue
     * @return Whether the approval was successful or not
     */
    function issue(address _recipient, uint256 _value) onlyOwner returns (bool success) {

        // Guarantee positive 
        if (_value < 0) {
            throw;
        }

        // Create tokens
        balances[_recipient] += _value;
        totalSupply += _value;

        // Notify listners
        Transfer(0, owner, _value);
        Transfer(owner, _recipient, _value);

        return true;
    }


    /**
     * Prevents accidental sending of ether
     */
    function () {
        throw;
    }
}