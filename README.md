# Decentralized Voting System

This is a decentralized voting smart contract developed in Solidity. It allows for the creation of proposals and voting by authorized addresses.

## Contract Deployment

The contract has been deployed on the Sepolia network. You can verify the deployment transaction at the following link:

[View contract on Etherscan](https://sepolia.etherscan.io/address/0x4BCb81F9757E5FfF0CD70772758b6a702eACC4f6)

## Contract Description

This contract includes the following functionalities:

- **Create proposals**: Only the address that deploys the contract has permission to add proposals.
- **Whitelist**: Only authorized addresses included in the whitelist can vote.
- **Voting period**: The voting period is limited to 3 days from the moment of contract deployment.
- **Vote control**: Each address can vote only once and only during the voting period.

## Contract Structure

### Main Variables

- `proposalAdder`: The address authorized to add proposals.
- `proposals`: List of all proposals created.
- `whitelist`: Mapping indicating which addresses are authorized to vote.
- `hasVoted`: Mapping recording if an address has already voted.
- `votingEndTime`: Timestamp when the voting period ends.

### Main Functions

1. **Constructor**

   The constructor initializes the contract with a list of authorized addresses (whitelist) and sets the voting period to 3 days from deployment.

2. **addAddressToWhitelist**

   Allows the contract deployer to add new addresses to the whitelist.

   ```solidity
   function addAddressToWhitelist(address _address) public;
   ```
3. **addProposal**
   
   Allows the administrator to add a new proposal.
   
   ```solidity
    function addProposal(string memory _name) public;
   ```
4. **vote**
   
   Allows an authorized address to vote on a proposal, as long as they have not voted before and the voting period is still active.

   ```solidity
    function vote(uint256 proposalIndex) public;
   ```
5. **getProposalsCount**
   
   Returns the total number of proposals.

   ```solidity
    function getProposalsCount() public view returns (uint256);
   ```
6. **getProposal**
   
   Returns the details of a specific proposal.

   ```solidity
   function getProposal(uint proposalIndex) public view returns (string memory name, uint voteCount);
   ```

## Voting Requirements

To vote, the following requirements must be met:

- Be included in the whitelist.
- Have not voted before.
- Vote before the voting period ends (3 days from deployment).
- Vote on a valid proposal.

## Example of Usage

### Deploying the Contract

When deploying the contract, a list of addresses authorized to vote (whitelist) must be provided:

```solidity
constructor(address[] memory _whitelist)
```

### Adding a Proposal

Only the administrator (the address that deployed the contract) can add proposals:

```solidity
addProposal("Proposal 1");
```

### Voting on a Proposal

An authorized address can vote on a specific proposal by using its index in the proposal list:

```solidity
vote(0); // Vote for the first proposal
```