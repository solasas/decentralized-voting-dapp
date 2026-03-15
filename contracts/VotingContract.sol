// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract Create {
    uint256 public _voterId;
    uint256 public _candidateId;

    address public votingOrganizer;

    constructor() {
        votingOrganizer = msg.sender;
    }

    // ---------------- Candidate ----------------

    struct Candidate {
        uint256 candidateId;
        string age;
        string name;
        string image;
        uint256 voteCount;
        address _address;
        string ipfs;
    }

    mapping(address => Candidate) public candidates;
    address[] public candidateAddresses;

    event CandidateCreate(
        uint256 indexed candidateId,
        string age,
        string name,
        string image,
        uint256 voteCount,
        address _address,
        string ipfs
    );

    function setCandidate(
        address _address,
        string memory _age,
        string memory _name,
        string memory _image,
        string memory _ipfs
    ) public {
        require(
            votingOrganizer == msg.sender,
            "Only organizer can create candidates"
        );

        _candidateId++;

        Candidate storage candidate = candidates[_address];

        candidate.age = _age;
        candidate.name = _name;
        candidate.candidateId = _candidateId;
        candidate.image = _image;
        candidate.voteCount = 0;
        candidate._address = _address;
        candidate.ipfs = _ipfs;

        candidateAddresses.push(_address);

        emit CandidateCreate(
            _candidateId,
            _age,
            _name,
            _image,
            candidate.voteCount,
            _address,
            _ipfs
        );
    }

    function getCandidate() public view returns (address[] memory) {
        return candidateAddresses;
    }

    function getCandidateLength() public view returns (uint256) {
        return candidateAddresses.length;
    }

    function getCandidateData(
        address _address
    )
        public
        view
        returns (
            string memory,
            string memory,
            uint256,
            string memory,
            uint256,
            string memory,
            address
        )
    {
        return (
            candidates[_address].age,
            candidates[_address].name,
            candidates[_address].candidateId,
            candidates[_address].image,
            candidates[_address].voteCount,
            candidates[_address].ipfs,
            candidates[_address]._address
        );
    }

    // ---------------- Voter ----------------

    struct Voter {
        uint256 voterId;
        string name;
        string image;
        address voter_address;
        uint256 voter_allowed;
        bool voter_voted;
        uint256 voter_vote;
        string ipfs;
    }

    mapping(address => Voter) public voters;
    address[] public votersAddresses;
    address[] public votedVoters;

    event VoterCreated(
        uint256 indexed voterId,
        string name,
        string image,
        address voter_address,
        uint256 voter_allowed,
        bool voter_voted,
        uint256 voter_vote,
        string ipfs
    );

    function voterRight(
        address _address,
        string memory _name,
        string memory _image,
        string memory _ipfs
    ) public {
        require(
            votingOrganizer == msg.sender,
            "Only organizer can create voter"
        );

        _voterId++;

        Voter storage voter = voters[_address];

        require(voter.voter_allowed == 0, "Voter already allowed");

        voter.voter_allowed = 1;
        voter.name = _name;
        voter.image = _image;
        voter.voter_address = _address;
        voter.voterId = _voterId;
        voter.voter_vote = 0;
        voter.voter_voted = false;
        voter.ipfs = _ipfs;

        votersAddresses.push(_address);

        emit VoterCreated(
            _voterId,
            _name,
            _image,
            _address,
            voter.voter_allowed,
            voter.voter_voted,
            voter.voter_vote,
            _ipfs
        );
    }

    function vote(address _candidateAddress) external {
        Voter storage voter = voters[msg.sender];

        require(!voter.voter_voted, "You already voted");
        require(voter.voter_allowed != 0, "You have no right to vote");

        voter.voter_voted = true;

        votedVoters.push(msg.sender);

        candidates[_candidateAddress].voteCount += 1;
    }

    function getVoterLength() public view returns (uint256) {
        return votersAddresses.length;
    }

    function getVoterdata(
        address _address
    )
        public
        view
        returns (
            uint256,
            string memory,
            string memory,
            address,
            string memory,
            uint256,
            bool
        )
    {
        return (
            voters[_address].voterId,
            voters[_address].name,
            voters[_address].image,
            voters[_address].voter_address,
            voters[_address].ipfs,
            voters[_address].voter_allowed,
            voters[_address].voter_voted
        );
    }

    function getVotedVoterList() public view returns (address[] memory) {
        return votedVoters;
    }

    function getVoterList() public view returns (address[] memory) {
        return votersAddresses;
    }
}
