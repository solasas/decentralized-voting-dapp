//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
contract Create {
    using Counters for Counters.Counter;

    Counters.Counter public _voterId;
    Counters.Counter public _candidateId;

    address public votingOrganizer;

    struct Canditate {
        uint256 canditateId;
        string age;
        string name;
        string image;
        uint256 voteCount;
        address _address;
        string ipfs;

    }

    event CanditateCreate(
        uint256 indexed canditateId,
        string age,
        string name,
        string image,
        uint256 voteCount,
        address _address,
        string ipfs
    );
    address[] public canditateAddress;

    mapping(address=>Canditate) public canditates;

    ///END OF CANDITATE DATA

    address[] public votedVoters;
    address[] public votersAddresses;
    mapping(address=>Voter) public voters;

    struct Voter{
      uint256 voter_voterId;
      string voter_name;
      string voter_image;
      address voter_address;
      uint256 voter_allowed;
      bool voter_voted;
      uint256 voter_vote;
      string ipfs;
    }
      event VoterCreated(
      uint256 indexed voter_voterId,
      string voter_name,
      string voter_image,
      address voter_address,
      uint256 voter_allowed,
      bool voter_voted,
      uint256 voter_vote,
      string ipfs
      );

      ///end of voter data

      constructor(){
         votingOrganizer=msg.sender;
      }
      function setCanditate(address _address,string memory _age,string memory _image,string memory _ipfs)
      public{
         require(votingOrganizer==msg.sender,"Only organizer can create the canditates");
         _candidateId.increment();
         uint256 idNumber=_candidateId.current();
         Canditate storage canditate=canditates[_address];
         canditate.age=_age;
         canditate.name=_name;
         canditate.canditateId=_candidateId;
         canditate.image=_image;
         canditate.voteCount=0;
         canditate._address=_address;
         canditate.ipfs=_ipfs;

         canditateAddress.push(_address);

         emit CanditateCreate(idNumber,_age,_name,_image,canditate.voteCount,_address,_ipfs);
         

      }

      function getCanditate() public view returns (address[] memory){
         return canditateAddress;
      }

      function getCanditateLength() public view returns (uint256){
         return canditateAddress.length;
      }
      function getCanditatedata(address _address) public view returns(string memory ,string memory , uint256 , string memory ,uint256 , address
      ) {
         return (canditates[_address].age,
          canditates[_address].name,
          canditates[_address].canditateId,
          canditates[_address].image,
          canditates[_address].voteCount,
          canditates[_address].ipfs,
          canditates[_address]._address);

      }

      ////voter section

      function setVoter(address _address, string memory _name, string memory _image, string memory _ipfs) public {
         require(votingOrganizer == msg.sender, "Only organizer can create voters");
         _voterId.increment();
         uint256 idNumber = _voterId.current();
         Voter storage voter = voters[_address];
         voter.voter_voterId = idNumber;
         voter.voter_name = _name;
         voter.voter_image = _image;
         voter.voter_address = _address;
         voter.voter_allowed = 1;
         voter.voter_voted = false;
         voter.voter_vote = 0;
         voter.ipfs = _ipfs;
         votersAddresses.push(_address);
         emit VoterCreated(idNumber, _name, _image, _address, 1, false, 0, _ipfs);
      }

      function getVoters() public view returns (address[] memory) {
         return votersAddresses;
      }

      function getVotersLength() public view returns (uint256) {
         return votersAddresses.length;
      }

      function getVoterData(address _address) public view returns (
         uint256,
         string memory,
         string memory,
         address,
         uint256,
         bool,
         uint256,
         string memory
      ) {
         Voter storage voter = voters[_address];
         return (
            voter.voter_voterId,
            voter.voter_name,
            voter.voter_image,
            voter.voter_address,
            voter.voter_allowed,
            voter.voter_voted,
            voter.voter_vote,
            voter.ipfs
         );
      }

}
