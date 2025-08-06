// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Governor} from "lib/openzeppelin-contracts/contracts/governance/Governor.sol";
import {GovernorSettings} from "lib/openzeppelin-contracts/contracts/governance/extensions/GovernorSettings.sol";
import {GovernorCountingSimple} from "lib/openzeppelin-contracts/contracts/governance/extensions/GovernorCountingSimple.sol";
import {GovernorVotes} from "lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotes.sol";
import {GovernorVotesQuorumFraction} from "lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import {GovernorTimelockControl} from "lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol";
import {TimelockController} from "lib/openzeppelin-contracts/contracts/governance/TimelockController.sol";

import {IVotes} from "lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol";
import {IGovernor} from "lib/openzeppelin-contracts/contracts/governance/IGovernor.sol";

contract MyGovernor is
    Governor,
    GovernorSettings,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl
{
    constructor(
        IVotes _token,
        TimelockController _timelock
    )
        Governor("MyGovernor")
        GovernorSettings(1, /* 1 block */ 50400, /* 1 week */ 0)
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
        GovernorTimelockControl(_timelock)
    {}

    // The following functions are overrides required by Solidity.

    /// @notice Returns the delay (in blocks) before voting on a proposal may take place, after proposal is created.
    /// @dev This function overrides the votingDelay from IGovernor and GovernorSettings.
    /// @return The voting delay in blocks.
    function votingDelay()
        public
        view
        override(IGovernor, GovernorSettings)
        returns (uint256)
    {
        // Calls the parent contract's implementation of votingDelay
        return super.votingDelay();
    }

    /// @notice Returns the duration (in blocks) of the voting period for a proposal.
    /// @dev This function overrides the votingPeriod from IGovernor and GovernorSettings.
    /// @return The voting period in blocks.
    function votingPeriod()
        public
        view
        override(IGovernor, GovernorSettings)
        returns (uint256)
    {
        // Calls the parent contract's implementation of votingPeriod
        return super.votingPeriod();
    }

    /// @notice Returns the quorum required for a proposal to pass at a specific block number.
    /// @dev This function overrides the quorum from IGovernor and GovernorVotesQuorumFraction.
    /// @param blockNumber The block number to get the quorum for.
    /// @return The quorum required at the given block number.
    function quorum(
        uint256 blockNumber
    )
        public
        view
        override(IGovernor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        // Calls the parent contract's implementation of quorum
        return super.quorum(blockNumber);
    }

    /// @notice Returns the current state of a proposal.
    /// @dev This function overrides the state from Governor and GovernorTimelockControl.
    /// @param proposalId The id of the proposal.
    /// @return The current ProposalState.
    function state(
        uint256 proposalId
    )
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        // Calls the parent contract's implementation of state
        return super.state(proposalId);
    }

    /// @notice Creates a new proposal.
    /// @dev This function overrides the propose from Governor and IGovernor.
    /// @param targets The list of target addresses for calls to be made.
    /// @param values The list of values (i.e. msg.value) to be passed to the calls.
    /// @param calldatas The list of calldata to be used for each call.
    /// @param description The description of the proposal.
    /// @return The id of the newly created proposal.
    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public override(Governor, IGovernor) returns (uint256) {
        // Calls the parent contract's implementation of propose
        return super.propose(targets, values, calldatas, description);
    }

    /// @notice Returns the minimum number of votes required for a proposal to be created.
    /// @dev This function overrides the proposalThreshold from Governor and GovernorSettings.
    /// @return The proposal threshold.
    function proposalThreshold()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        // Calls the parent contract's implementation of proposalThreshold
        return super.proposalThreshold();
    }

    /// @notice Executes a successful proposal.
    /// @dev This function overrides the _execute from Governor and GovernorTimelockControl.
    /// @param proposalId The id of the proposal.
    /// @param targets The list of target addresses for calls to be made.
    /// @param values The list of values (i.e. msg.value) to be passed to the calls.
    /// @param calldatas The list of calldata to be used for each call.
    /// @param descriptionHash The hash of the proposal's description.
    function _execute(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) {
        // Calls the parent contract's implementation of _execute
        super._execute(proposalId, targets, values, calldatas, descriptionHash);
    }

    /// @notice Cancels a proposal.
    /// @dev This function overrides the _cancel from Governor and GovernorTimelockControl.
    /// @param targets The list of target addresses for calls to be made.
    /// @param values The list of values (i.e. msg.value) to be passed to the calls.
    /// @param calldatas The list of calldata to be used for each call.
    /// @param descriptionHash The hash of the proposal's description.
    /// @return The id of the canceled proposal.
    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) returns (uint256) {
        // Calls the parent contract's implementation of _cancel
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    /// @notice Returns the address of the executor for governance actions.
    /// @dev This function overrides the _executor from Governor and GovernorTimelockControl.
    /// @return The executor address.
    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        // Calls the parent contract's implementation of _executor
        return super._executor();
    }

    /// @notice Checks if the contract supports a given interface.
    /// @dev This function overrides the supportsInterface from Governor and GovernorTimelockControl.
    /// @param interfaceId The interface identifier, as specified in ERC-165.
    /// @return True if the contract supports the requested interface, false otherwise.
    function supportsInterface(
        bytes4 interfaceId
    ) public view override(Governor, GovernorTimelockControl) returns (bool) {
        // Calls the parent contract's implementation of supportsInterface
        return super.supportsInterface(interfaceId);
    }
}
