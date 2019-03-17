pragma solidity ^0.4.25;

import "./DogOwnership.sol";
import "./DogBase.sol";
import "./ERC721Burnable.sol";

contract DogDeal is DogBase, ERC721Burnable{

    struct Deal {

        /// The first person bringing the dog
        address owner1;
        /// The second person bringing the dog
        address owner2;
        uint256 dog1Id;
        uint256 dog2Id;
        uint price;

    }

    event CreateDeal(address owner1, address owner2, uint256 dog1Id, uint256 dog2Id, uint256 dealId);


    /// The Invoice struct
    struct Invoice {

        uint orderno;
        uint number;
        bool init;

    }

    /// The Shipment struct
    struct Shipment {
        address courier;
        uint price;
        uint safepay;
        address payer;
        uint date;
        uint real_date;

        bool init;
    }

    /// The mapping to store orders
    Deal[] deals;

    /// The mapping to store invoices
    mapping (uint => Invoice) invoices;

    event Create(address owner, uint money, uint256 participantId);

    struct Participant {
        address owner;
        uint money;
    }

    Participant[] participants;

    function _createParticipant(
        address _owner,
        uint _money
    )
    internal
    returns (uint)
    {
        Participant memory _participant = Participant ({
            owner: _owner,
            money: _money
        });

        uint256 _participantId = participants.push(_participant) - 1;

        emit Create(_owner, _money, _participantId);

        return _participantId;
    }

    function FindParticipant(address sender) public view returns (uint256) {
        uint256 resultat;

        for (uint256 i = 0; i < participants.length; i++){
            if(participants[i].owner == sender ) {
                resultat = i;
            }
        }
        return resultat;
    }

    struct Fight {
        address creator;
        uint256 dogId;
        uint price;
    }

    Fight[] fights;

    event CreateFight(address creator, uint fightId, uint256 dogID, uint price);


    function ProposeFight(
        address _creator, 
        uint256 _dogId, 
        uint _price
        ) 
        internal 
        returns (uint)
    {
        require(_creator == dogIndexToOwner[_dogId]);

        uint256 IsParticipant = FindParticipant(_creator);

        if(IsParticipant == uint256(-1)) {
            _createParticipant(_creator, 0);
        }

        Fight memory _fight = Fight({
            creator: _creator,
            dogId: _dogId,
            price: _price
        });

        uint fightId = fights.push(_fight) - 1;

        emit CreateFight (
            _creator,
            fightId,
            _dogId,
            _price
        );

        return fightId;
    }

    function FindDog(address owner, Dog[] _kennel) internal view returns (uint256){
        
        uint256 resultat = uint256(-1);

        for (uint256 i = 0; i < _kennel.length; i++){
            if(dogIndexToOwner[i] == owner) {
                resultat = i;
            }
        }

        return resultat;
    }

    function DealMade(
        address _owner1,
        address _owner2,
        uint256 _dog1Id,
        uint256 _dog2Id,
        uint _price
    )
        internal
        returns (uint)
    {
        Deal memory _deal = Deal({
            owner1: _owner1,
            owner2: _owner2,
            dog1Id: _dog1Id,
            dog2Id: _dog2Id,
            price: _price
        });

        uint256 newDealId = deals.push(_deal) - 1;

        emit CreateDeal(
            _owner1,
            _owner2,
            _dog1Id,
            _dog2Id,
            newDealId
        );

        return newDealId;
    }

    function UsingAgreeToFight(uint fightId, Dog[] _kennel) internal  returns (uint256) {
        
        Fight storage fight = fights[fightId];

        address owner1 = fight.creator;
        uint256 dog1Id = fight.dogId;

        address owner2 = msg.sender;
        require (ownershipTokenCount[owner2] > 0);
        uint256 dog2Id = FindDog(owner2, _kennel);

        uint price = fight.price;

        uint256 dealId = DealMade(owner1, owner2, dog1Id, dog2Id, price);

        return dealId;
    }

    function Winner(uint256 dealId) internal {
        Deal storage deal = deals[dealId];

        if(deal.dog1Id % 2 > deal.dog2Id) {
            _burn(deal.dog2Id);
            ownershipTokenCount[deal.owner2]--;
            uint256 Winner1Id = FindParticipant(deal.owner1);
            Participant memory winner1 = participants[Winner1Id];
            winner1.money += deal.price;
            uint256 Loser2Id = FindParticipant(deal.owner2);
            Participant memory loser2 = participants[Loser2Id];
            loser2.money -= deal.price;

        }
        else {
            _burn(deal.dog1Id);
            ownershipTokenCount[deal.owner1]--;
            uint256 Winner2Id = FindParticipant(deal.owner2);
            Participant memory winner2 = participants[Winner2Id];
            winner2.money += deal.price;
            uint256 Loser1Id = FindParticipant(deal.owner1);
            Participant memory loser1 = participants[Loser1Id];
            loser1.money -= deal.price;
        }
    }
}