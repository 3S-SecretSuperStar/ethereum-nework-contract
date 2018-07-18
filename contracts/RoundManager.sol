pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract RoundManager is Ownable {
  using SafeMath for uint;

  // Round number of the last round
  uint public roundNumber;
  // Block number of the start of the last round
  uint public startOfCurrentRound;

  uint public electionPeriodLength;
  uint public rateLockDeadline;
  // The time (in number of blocks) that a Delegator has to wait before he can withdraw() his tokens
  uint public unbondingPeriod;

  modifier onlyBeforeActiveRoundIsLocked() {
    require(block.number.sub(startOfCurrentRound) < electionPeriodLength.sub(rateLockDeadline));
    _;
  }

  function setElectionPeriodLength(uint _electionPeriodLength) public onlyOwner {
    electionPeriodLength = _electionPeriodLength;
  }

  function setRateLockDeadline(uint _rateLockDeadline) public onlyOwner {
    rateLockDeadline = _rateLockDeadline;
  }

  function setUnbondingPeriod(uint _unbondingPeriod) public onlyOwner {
    unbondingPeriod = _unbondingPeriod;
  }

  function initializeRound() external {
    require(block.number.sub(startOfCurrentRound) >= electionPeriodLength);
    roundNumber = roundNumber.add(1);
    startOfCurrentRound = block.number;
  }
}
