pragma solidity ^0.8.0;

contract supplychain
{
    address owner;
    constructor()
    {
        owner = msg.sender;
    }

    modifier onlyOwner()
    {
        require(msg.sender == owner, "Authorized only to Owner");
        _;
    }
    event location(string indexed vendor, uint latitiude, uint longitude);

    //supply phase: supply units
    struct units 
    {     
        address responsibleAddress;   
        uint expected_time;
        uint quantity;
        uint exp_latitude;
        uint exp_longitude;

        
        uint latitude;
        uint longitude;
        uint time_began;
    }

    //manufactering phase
    //combining shipments so they are brought together in a single package.
    function combineEvents(uint256[] units)
    {

    }
    //Distribution phase occurs when every event is combined to one.


}
