// SPDX-License-Identifier: MPL-2.0
pragma solidity >=0.6.2;

import '../IModule.sol';

contract OneThirdParticipationThreshold is IModule {
  function onCreateProposal (
    bytes32 communityId,
    uint256 totalMemberCount,
    uint256 totalValueLocked,
    address proposer,
    uint256 proposerBalance,
    uint256 startDate,
    bytes calldata internalActions,
    bytes calldata externalActions
  ) external view override
  {
    uint256 minProposerBalance = totalValueLocked / 10000;
    require(
      proposerBalance >= minProposerBalance,
      'Not enough balance'
    );
  }

  function onProcessProposal (
    bytes32 proposalId,
    bytes32 communityId,
    uint256 totalMemberCount,
    uint256 totalVoteCount,
    uint256 totalVotingShares,
    uint256 totalVotingSignal,
    uint256 totalValueLocked,
    uint256 secondsPassed
  ) external view override returns (VotingStatus, uint256) {

    if (totalVoteCount == 0 || secondsPassed < 1) {
      return (VotingStatus.OPEN, uint256(-1));
    }

    uint256 PRECISION = 10000;
    uint256 THRESHOLD = PRECISION - PRECISION / 3;
    uint256 averageSignal = totalVotingSignal / totalVoteCount;
    uint256 participation = (totalVoteCount * PRECISION) / totalMemberCount;

    if (participation > THRESHOLD) {
      if (averageSignal > 50) {
        return (VotingStatus.PASSED, 0);
      } else {
        return (VotingStatus.CLOSED, 0);
      }
    }

    return (VotingStatus.OPEN, 0);
  }
}
