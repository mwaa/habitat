export default [
  'event BlockBeacon()',
  'event ClaimUsername(address indexed account, bytes32 indexed shortString)',
  'event ClaimedStakingReward(address indexed account, address indexed token, uint256 indexed epoch, uint256 amount)',
  'event CommunityCreated(address indexed governanceToken, bytes32 indexed communityId)',
  'event CustomBlockBeacon()',
  'event DelegatedAmount(address indexed account, address indexed delegatee, address indexed token, uint256 value)',
  'event DelegateeVotedOnProposal(address indexed account, bytes32 indexed proposalId, uint8 signalStrength, uint256 shares)',
  'event Deposit(address owner, address token, uint256 value, uint256 tokenType)',
  'event MetadataUpdated(uint256 indexed topic, bytes metadata)',
  'event NewSolution()',
  'event ProposalCreated(address indexed vault, bytes32 indexed proposalId, uint256 startDate)',
  'event ProposalProcessed(bytes32 indexed proposalId, uint256 indexed votingStatus)',
  'event RollupUpgrade(address target)',
  'event TokenTransfer(address indexed token, address indexed from, address indexed to, uint256 value)',
  'event VaultCreated(bytes32 indexed communityId, address indexed condition, address indexed vaultAddress)',
  'event VotedOnProposal(address indexed account, bytes32 indexed proposalId, uint8 signalStrength, uint256 shares)',
  'event Withdraw(address owner, address token, uint256 value)',
  'function EPOCH_GENESIS() returns (uint256)',
  'function INSPECTION_PERIOD() view returns (uint16)',
  'function INSPECTION_PERIOD_MULTIPLIER() view returns (uint256)',
  'function MAX_BLOCK_SIZE() view returns (uint24)',
  'function ROLLUP_MANAGER() view returns (address)',
  'function SECONDS_PER_EPOCH() returns (uint256)',
  'function STAKING_POOL_FEE_DIVISOR() returns (uint256)',
  'function blockMeta(uint256 height) view returns (uint256 ret)',
  'function canFinalizeBlock(uint256 blockNumber) view returns (bool)',
  'function challenge()',
  'function communityOfVault(address vault) returns (bytes32)',
  'function deposit(address token, uint256 amountOrId, address receiver)',
  'function dispute(uint256 blockNumber, uint256 bitmask)',
  'function executionPermit(address vault, bytes32 proposalId) view returns (bytes32 ret)',
  'function finalizeSolution()',
  'function finalizedHeight() view returns (uint256 ret)',
  'function getActiveDelegatedVotingStake(address token, address account) returns (uint256)',
  'function getActiveVotingStake(address token, address account) returns (uint256)',
  'function getBalance(address tkn, address account) returns (uint256)',
  'function getCurrentEpoch() returns (uint256)',
  'function getERC20Exit(address target, address owner) view returns (uint256)',
  'function getERC721Exit(address target, uint256 tokenId) view returns (address)',
  'function getErc721Owner(address tkn, uint256 b) returns (address)',
  'function getProposalStatus(bytes32 a) returns (uint256)',
  'function getTotalMemberCount(bytes32 communityId) returns (uint256)',
  'function getTotalValueLocked(address token) returns (uint256)',
  'function getTotalVotingShares(bytes32 proposalId) returns (uint256)',
  'function getUnlockedBalance(address token, address account) returns (uint256 ret)',
  'function onChallenge() returns (uint256)',
  'function onClaimStakingReward(address msgSender, uint256 nonce, address token, uint256 sinceEpoch)',
  'function onClaimUsername(address msgSender, uint256 nonce, bytes32 shortString)',
  'function onCreateCommunity(address msgSender, uint256 nonce, address governanceToken, bytes metadata)',
  'function onCreateProposal(address msgSender, uint256 nonce, uint256 startDate, address vault, bytes internalActions, bytes externalActions, bytes metadata)',
  'function onCreateVault(address msgSender, uint256 nonce, bytes32 communityId, address condition, bytes metadata)',
  'function onDelegateAmount(address msgSender, uint256 nonce, address delegatee, address token, uint256 newAllowance)',
  'function onDeposit(address owner, address token, uint256 value, uint256 tokenType)',
  'function onFinalizeSolution(uint256, bytes32 hash)',
  'function onModifyRollupStorage(address msgSender, uint256 nonce, bytes data)',
  'function onProcessProposal(address msgSender, uint256 nonce, bytes32 proposalId, bytes internalActions, bytes externalActions) returns (uint256 votingStatus, uint256 secondsTillClose, uint256 quorumPercent)',
  'function onSubmitModule(address msgSender, uint256 nonce, address contractAddress, bytes metadata)',
  'function onTransferToken(address msgSender, uint256 nonce, address token, address to, uint256 value)',
  'function onTributeForOperator(address msgSender, uint256 nonce, address operator, address token, uint256 amount)',
  'function onVoteOnProposal(address msgSender, uint256 nonce, bytes32 proposalId, uint256 shares, address delegatee, uint8 signalStrength)',
  'function pendingHeight() view returns (uint256 ret)',
  'function submitBlock()',
  'function submitSolution()',
  'function tokenOfCommunity(bytes32 a) returns (address)',
  'function txNonces(address a) returns (uint256)',
  'function upgradeRollup(address newImplementation)',
  'function withdraw(address owner, address token, uint256 tokenId)'
]
