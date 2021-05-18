// SPDX-License-Identifier: MPL-2.0
pragma solidity >=0.6.2;

import '@NutBerry/rollup-bricks/src/tsm/contracts/NutBerryTokenBridge.sol';
import '@NutBerry/rollup-bricks/src/bricked/contracts/UtilityBrick.sol';

/// @notice Global state and public utiltiy functions for the Habitat Rollup
contract HabitatBase is NutBerryTokenBridge, UtilityBrick {
  // xxx
  // - default community voting condition?
  // - execution permits

  function INSPECTION_PERIOD () public view virtual override returns (uint16) {
    // in blocks - ~84 hours
    return 21600;
  }

  function PROPOSAL_DELAY () public view virtual returns (uint256) {
    // in seconds
    return 3600 * 32;
  }

  function _commonChecks () internal view {
    // all power the core protocol
    require(msg.sender == address(this));
  }

  function _checkUpdateNonce (address msgSender, uint256 nonce) internal {
    require(nonce == txNonces(msgSender), 'NONCE');

    _incrementStorage(_TX_NONCE_KEY(msgSender));
  }

  function _calculateAddress (address msgSender, uint256 nonce, bytes32 salt) internal pure returns (address ret) {
    assembly {
      let backup := mload(64)
      mstore(0, msgSender)
      mstore(32, nonce)
      mstore(64, salt)
      ret := shr(96, keccak256(0, 96) )
      mstore(64, backup)
    }
  }

  // Storage helpers, functions will be replaced with special getters/setters to retrieve/store on the rollup
  function _incrementStorage (uint256 key, uint256 value) internal {
    uint256 oldValue;
    uint256 newValue;
    assembly {
      oldValue := sload(key)
      newValue := add(oldValue, value)
      sstore(key, newValue)
    }
    require(newValue >= oldValue, 'INCR');
  }

  function _incrementStorage (uint256 key) internal {
    _incrementStorage(key, 1);
  }

  function _decrementStorage (uint256 key, uint256 value) internal {
    uint256 oldValue;
    uint256 newValue;
    assembly {
      oldValue := sload(key)
      newValue := sub(oldValue, value)
      sstore(key, newValue)
    }
    require(newValue <= oldValue, 'DECR');
  }

  function _getStorage (uint256 key) internal view returns (uint256 ret) {
    assembly {
      ret := sload(key)
    }
  }

  function _setStorage (uint256 key, uint256 value) internal {
    assembly {
      sstore(key, value)
    }
  }

  function _setStorage (uint256 key, bytes32 value) internal {
    assembly {
      sstore(key, value)
    }
  }

  function _setStorage (uint256 key, address value) internal {
    assembly {
      sstore(key, value)
    }
  }
  // end of storage helpers

  function _TX_NONCE_KEY (address a) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x1baf1b358a7f0088724e8c8008c24c8182cafadcf6b7d0da2db2b55b40320fbf)
      mstore(32, a)
      ret := keccak256(0, 64)
    }
  }

  /// @notice The nonce of account `a`.
  function txNonces (address a) public virtual view returns (uint256 ret) {
    uint256 key = _TX_NONCE_KEY(a);
    assembly {
      ret := sload(key)
    }
  }

  function _ERC20_KEY (address tkn, address account) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x24de14bddef9089376483557827abada7f1c6135d6d379c3519e56e7bc9067b9)
      mstore(32, tkn)
      let tmp := mload(64)
      mstore(64, account)
      ret := keccak256(0, 96)
      mstore(64, tmp)
    }
  }

  function getBalance (address tkn, address account) public virtual view returns (uint256 ret) {
    uint256 key = _ERC20_KEY(tkn, account);
    assembly {
      ret := sload(key)
    }
  }

  function _ERC721_KEY (address tkn, uint256 b) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x0b0adec1d909ec867fdb1853ca8d859f7b8137ab9c01f734b3fbfc40d9061ded)
      mstore(32, tkn)
      let tmp := mload(64)
      mstore(64, b)
      ret := keccak256(0, 96)
      mstore(64, tmp)
    }
  }

  function getErc721Owner (address tkn, uint256 b) public virtual view returns (address ret) {
    uint256 key = _ERC721_KEY(tkn, b);
    assembly {
      ret := sload(key)
    }
  }

  function _VOTING_SHARES_KEY (bytes32 proposalId, address account) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x24ce236379086842ae19f4302972c7dd31f4c5054826cd3e431fd503205f3b67)
      mstore(32, proposalId)
      let tmp := mload(64)
      mstore(64, account)
      ret := keccak256(0, 96)
      mstore(64, tmp)
    }
  }

  function getVote (bytes32 proposalId, address account) public view returns (uint256 ret) {
    uint256 key = _VOTING_SHARES_KEY(proposalId, account);
    assembly {
      ret := sload(key)
    }
  }

  function _VOTING_SIGNAL_KEY (bytes32 proposalId, address account) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x12bc1ed237026cb917edecf1ca641d1047e3fc382300e8b3fab49ae10095e490)
      mstore(32, proposalId)
      let tmp := mload(64)
      mstore(64, account)
      ret := keccak256(0, 96)
      mstore(64, tmp)
    }
  }

  function _VOTING_COUNT_KEY (bytes32 proposalId) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x637730e93bbd8200299f72f559c841dfae36a36f86ace777eac8fe48f977a46d)
      mstore(32, proposalId)
      ret := keccak256(0, 64)
    }
  }

  function getVoteCount (bytes32 proposalId) public view returns (uint256 ret) {
    uint256 key = _VOTING_COUNT_KEY(proposalId);
    assembly {
      ret := sload(key)
    }
  }

  function _VOTING_TOTAL_SHARE_KEY (bytes32 proposalId) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x847f5cbc41e438ef8193df4d65950ec6de3a1197e7324bffd84284b7940b2d4a)
      mstore(32, proposalId)
      ret := keccak256(0, 64)
    }
  }

  function getTotalVotingShares (bytes32 proposalId) public view returns (uint256 ret) {
    uint256 key = _VOTING_TOTAL_SHARE_KEY(proposalId);
    assembly {
      ret := sload(key)
    }
  }

  function _VOTING_TOTAL_SIGNAL_KEY (bytes32 proposalId) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x3a5afbb81b36a1a15e90db8cc0deb491bf6379592f98c129fd8bdf0b887f82dc)
      mstore(32, proposalId)
      ret := keccak256(0, 64)
    }
  }

  function _MEMBER_OF_COMMUNITY_KEY (bytes32 communityId, address account) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x0ff6c2ccfae404e7ec55109209ac7c793d30e6818af453a7c519ca59596ccde1)
      mstore(32, communityId)
      let tmp := mload(64)
      mstore(64, account)
      ret := keccak256(0, 96)
      mstore(64, tmp)
    }
  }

  function _MEMBERS_TOTAL_COUNT_KEY (bytes32 communityId) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0xe1338c6a5be626513cff1cb54a827862ae2ab4810a79c8dfd1725e69363f4247)
      mstore(32, communityId)
      ret := keccak256(0, 64)
    }
  }

  function getTotalMemberCount (bytes32 communityId) public view returns (uint256 ret) {
    uint256 key = _MEMBERS_TOTAL_COUNT_KEY(communityId);
    assembly {
      ret := sload(key)
    }
  }

  function _NAME_TO_ADDRESS_KEY (bytes32 shortString) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x09ec9a99acfe90ba324ac042a90e28c5458cfd65beba073b0a92ea7457cdfc56)
      mstore(32, shortString)
      ret := keccak256(0, 64)
    }
  }

  function _ADDRESS_TO_NAME_KEY (address account) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x83cb99259282c2842186d0db03ab6fdfc530b2afa0eb2a4fe480c4815a5e1f34)
      mstore(32, account)
      ret := keccak256(0, 64)
    }
  }

  function _ACCOUNT_DELEGATE_KEY (address a) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0xa4cf686a12e967d8e7bd65750e2f83e9462cafbc9c0d8faf956478a83b935c62)
      mstore(32, a)
      ret := keccak256(0, 64)
    }
  }

  function _PROPOSAL_VAULT_KEY (bytes32 a) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x622061f2b694ba7aa754d63e7f341f02ac8341e2b36ccbb1d3fc1bf00b57162d)
      mstore(32, a)
      ret := keccak256(0, 64)
    }
  }

  function _PROPOSAL_START_DATE_KEY (bytes32 a) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x539a579b21c2852f7f3a22630162ab505d3fd0b33d6b46f926437d8082d494c1)
      mstore(32, a)
      ret := keccak256(0, 64)
    }
  }

  function _TOKEN_OF_COMMUNITY_KEY (bytes32 a) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0xeadaeda4a4005f296730d16d047925edeb6f21ddc028289ebdd9904f9d65a662)
      mstore(32, a)
      ret := keccak256(0, 64)
    }
  }

  /// @notice Governance Token of community.
  function tokenOfCommunity (bytes32 a) public virtual view returns (address ret) {
    uint256 key = _TOKEN_OF_COMMUNITY_KEY(a);
    assembly {
      ret := sload(key)
    }
  }

  function _COMMUNITY_OF_VAULT_KEY (address a) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0xf659eca1f5df040d1f35ff0bac6c4cd4017c26fe0dbe9317b2241af59edbfe06)
      mstore(32, a)
      ret := keccak256(0, 64)
    }
  }

  /// @notice The community of `vault`.
  function communityOfVault (address vault) public virtual view returns (bytes32 ret) {
    uint256 key = _COMMUNITY_OF_VAULT_KEY(vault);
    assembly {
      ret := sload(key)
    }
  }

  function _MODULE_HASH_KEY (address a) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0xe6ab7761f522dca2c6f74f7f7b1083a1b184fec6b893cb3418cb3121c5eda5aa)
      mstore(32, a)
      ret := keccak256(0, 64)
    }
  }

  function _VAULT_CONDITION_KEY (address a) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x615e61b2f7f9d8ca18a90a9b0d27a62ae27581219d586cb9aeb7c695bc7b92c8)
      mstore(32, a)
      ret := keccak256(0, 64)
    }
  }

  function _PROPOSAL_STATUS_KEY (bytes32 a) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x40e11895caf89e87d4485af91bd7e72b6a6e56b94f6ea4b7edb16e869adb7fe9)
      mstore(32, a)
      ret := keccak256(0, 64)
    }
  }

  /// @notice Returns the voting status of proposal id `a`.
  function getProposalStatus (bytes32 a) public virtual view returns (uint256 ret) {
    uint256 key = _PROPOSAL_STATUS_KEY(a);
    assembly {
      ret := sload(key)
    }
  }

  function _maybeUpdateMemberCount (bytes32 proposalId, address account) internal {
    address vault = address(_getStorage(_PROPOSAL_VAULT_KEY(proposalId)));
    bytes32 communityId = communityOfVault(vault);
    if (_getStorage(_MEMBER_OF_COMMUNITY_KEY(communityId, account)) == 0) {
      _setStorage(_MEMBER_OF_COMMUNITY_KEY(communityId, account), 1);
      _incrementStorage(_MEMBERS_TOTAL_COUNT_KEY(communityId));
    }
  }

  function _TOKEN_TVL_KEY (address a) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x4e7484f055e36257052a570831d7e3114ad145e0c8d8de63ded89925c7e17cb6)
      mstore(32, a)
      ret := keccak256(0, 64)
    }
  }

  function getTotalValueLocked (address token) public view virtual returns (uint256 value) {
    uint256 key = _TOKEN_TVL_KEY(token);
    assembly {
      value := sload(key)
    }
  }

  function _ACTIVATOR_OF_MODULE_KEY (bytes32 communityId, address condition) internal pure returns (uint256 ret) {
    assembly {
      let backup := mload(64)
      mstore(0, 0x447e3208ee953b940a0bd72b048754d7ee641b55c9d01ead253a9cb91f3442db)
      mstore(32, communityId)
      mstore(64, condition)
      ret := keccak256(0, 96)
      mstore(64, backup)
    }
  }

  function _PROPOSAL_HASH_INTERNAL_KEY (bytes32 proposalId) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0x9f6ffbe6bd26bda84ec854c7775d819340fd4340bc8fa1ab853cdee0d60e7141)
      mstore(32, proposalId)
      ret := keccak256(0, 64)
    }
  }

  function _PROPOSAL_HASH_EXTERNAL_KEY (bytes32 proposalId) internal pure returns (uint256 ret) {
    assembly {
      mstore(0, 0xcd566f7f1fd69d79df8b7e0a3e28a2b559ab3e7f081db4a0c0640de4db78de9a)
      mstore(32, proposalId)
      ret := keccak256(0, 64)
    }
  }

  function _EXECUTION_PERMIT_KEY (address vault, bytes32 proposalId) internal pure returns (uint256 ret) {
    assembly {
      let backup := mload(64)
      mstore(0, 0x8d47e278a5e048b636a1e1724246c4617684aff8b922d0878d0da2fb553d104e)
      mstore(32, vault)
      mstore(64, proposalId)
      ret := keccak256(0, 96)
      mstore(64, backup)
    }
  }

  /// @notice Execution permit for <vault, proposalId> = keccak256(actions).
  function executionPermit (address vault, bytes32 proposalId) external virtual view returns (bytes32 ret) {
    uint256 key = _EXECUTION_PERMIT_KEY(vault, proposalId);
    assembly {
      ret := sload(key)
    }
  }

  /// @dev Setter for `executionPermit`.
  /// Reflects the storage slot for `executionPermit` on L1.
  function _setExecutionPermit (address vault, bytes32 proposalId, bytes32 hash) internal {
    bytes32 key = bytes32(_EXECUTION_PERMIT_KEY(vault, proposalId));
    RollupStorage._setStorageL1(key, uint256(hash));
  }

  function _VOTING_ACTIVE_STAKE_KEY (address token, address account) internal pure returns (uint256 ret) {
    assembly {
      let backup := mload(64)
      mstore(0, 0x2a8a915836beef625eda7be8c32e4f94152e89551893f0eae870e80cab73c496)
      mstore(32, token)
      mstore(64, account)
      ret := keccak256(0, 96)
      mstore(64, backup)
    }
  }

  function getActiveVotingStake (address token, address account) public view returns (uint256 ret) {
    uint256 key = _VOTING_ACTIVE_STAKE_KEY(token, account);
    assembly {
      ret := sload(key)
    }
  }
}
