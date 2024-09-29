// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Decentralized Voting System
 * @dev This contract allows for the creation of proposals and voting by authorized addresses.
 */
contract Voting {

    // Structure defining a proposal
    struct Proposal {
        string name;      // Name of the proposal
        uint256 voteCount;   // Number of votes received
    }

    address public proposalAdder;          // Address authorized to add proposals
    Proposal[] public proposals;           // List of all proposals

    mapping(address => bool) public whitelist;   // Whitelist of addresses authorized to vote
    mapping(address => bool) public hasVoted;    // Records of addresses that have voted

    uint256 public votingEndTime;             // Timestamp marking the end of the voting period

    /**
     * @dev Constructor that initializes the contract.
     * @param _whitelist Array of addresses to be added to the whitelist.
     */
    constructor(address[] memory _whitelist) {
        proposalAdder = msg.sender;                            // The deploying account is authorized to add proposals
        votingEndTime = block.timestamp + 3 days;              // Sets the voting period to end 3 days after deployment

        // Adds each provided address to the whitelist
        for (uint256 i = 0; i < _whitelist.length; i++) {
            whitelist[_whitelist[i]] = true;
        }
    }

    /**
     * @dev Adds a new proposal to the proposals list.
     * @param _name Name of the new proposal.
     *
     * Requirements:
     * - The caller must be the authorized proposal adder.
     */
    function addProposal(string memory _name) public {
        require(msg.sender == proposalAdder, "Only the administrator can add proposals");
        proposals.push(Proposal({name: _name, voteCount: 0}));
    }

    /**
     * @dev Allows a whitelisted address to vote for a specific proposal.
     * @param proposalIndex Index of the proposal in the `proposals` array.
     *
     * Requirements:
     * - The voting period must still be active.
     * - The caller must be in the whitelist.
     * - The caller must not have voted before.
     * - The proposal index must be valid.
     */
    function vote(uint256 proposalIndex) public {
        require(block.timestamp <= votingEndTime, "The voting period has ended");
        require(whitelist[msg.sender], "You are not authorized to vote");
        require(!hasVoted[msg.sender], "You have already voted");
        require(proposalIndex < proposals.length, "Invalid proposal");

        proposals[proposalIndex].voteCount += 1;   // Increments the vote count for the proposal
        hasVoted[msg.sender] = true;               // Marks the address as having voted
    }

    /**
     * @dev Retrieves the total number of proposals.
     * @return The number of existing proposals.
     */
    function getProposalsCount() public view returns (uint256) {
        return proposals.length;
    }

    /**
     * @dev Retrieves the details of a specific proposal.
     * @param proposalIndex Index of the proposal in the `proposals` array.
     * @return name Name of the proposal.
     * @return voteCount Number of votes the proposal has received.
     */
    function getProposal(uint proposalIndex) public view returns (string memory name, uint voteCount) {
        require(proposalIndex < proposals.length, "Invalid proposal");
        Proposal storage proposal = proposals[proposalIndex];
        return (proposal.name, proposal.voteCount);
    }
}