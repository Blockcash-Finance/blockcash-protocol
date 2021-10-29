// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract StratManager is Ownable, Pausable {
  /**
   * @dev Blockcash Contracts:
   * {keeper} - Address to manage a few lower risk features of the strat
   * {strategist} - Address of the strategy author/deployer where strategist fee will go.
   * {vault} - Address of the vault that controls the strategy's funds.
   * {unirouter} - Address of exchange to execute swaps.
   */
  address public keeper;
  address public strategist;
  address public unirouter;
  address public vault;
  address public blockcashFeeRecipient;

  struct StratMgr {
    address keeper;
    address strategist;
    address unirouter;
    address vault;
    address blockcashFeeRecipient;
  }

  /**
   * @dev Initializes the base strategy.
   * @param stratMgr.keeper address to use as alternative owner.
   * @param stratMgr.strategist address where strategist fees go.
   * @param stratMgr.unirouter router to use for swaps
   * @param stratMgr.vault address of parent vault.
   * @param stratMgr.blockcashFeeRecipient address where to send blockcash's fees.
   */
  constructor(StratMgr memory stratMgr) public {
    keeper = stratMgr.keeper;
    strategist = stratMgr.strategist;
    unirouter = stratMgr.unirouter;
    vault = stratMgr.vault;
    blockcashFeeRecipient = stratMgr.blockcashFeeRecipient;
  }

  // checks that caller is either owner or keeper.
  modifier onlyManager() {
    require(msg.sender == owner() || msg.sender == keeper, "!manager");
    _;
  }

  /**
   * @dev Updates address of the strat keeper.
   * @param _keeper new keeper address.
   */
  function setKeeper(address _keeper) external onlyManager {
    keeper = _keeper;
  }

  /**
   * @dev Updates address where strategist fee earnings will go.
   * @param _strategist new strategist address.
   */
  function setStrategist(address _strategist) external {
    require(msg.sender == strategist, "!strategist");
    strategist = _strategist;
  }

  /**
   * @dev Updates router that will be used for swaps.
   * @param _unirouter new unirouter address.
   */
  function setUnirouter(address _unirouter) external onlyOwner {
    unirouter = _unirouter;
  }

  /**
   * @dev Updates parent vault.
   * @param _vault new vault address.
   */
  function setVault(address _vault) external onlyOwner {
    vault = _vault;
  }

  /**
   * @dev Updates blockcash fee recipient.
   * @param _blockcashFeeRecipient new blockcash fee recipient address.
   */
  function setBlockcashFeeRecipient(address _blockcashFeeRecipient)
    external
    onlyOwner
  {
    blockcashFeeRecipient = _blockcashFeeRecipient;
  }

  /**
   * @dev Function to synchronize balances before new user deposit.
   * Can be overridden in the strategy.
   */
  function beforeDeposit() external virtual {}
}
