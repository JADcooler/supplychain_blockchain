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
    mapping(address => string) adrToVendor;
    event location(string indexed vendor, uint latitiude, uint longitude);

    //supply phase: supply units
    struct UNITS 
    {     
        uint index;

        address responsibleAddress;   
        uint expected_time;
        uint quantity;
        uint exp_latitude;
        uint exp_longitude;

        
        uint latitude;
        uint longitude;
        uint time_began;
    }

    UNITS[] public Movers;

    function add_unit(UNITS memory param, string memory vendor) public onlyOwner
    {
        //responsible authority - RA
        param.index = Movers.length;
        Movers.push(param);
        
    }

    //manufactering phase
    //combining shipments so they are brought together in a single package.

    function remove(uint index) onlyOwner public
    {
    Movers[index] = Movers[Movers.length - 1];
    Movers[index].index = index;
    Movers.pop();
    }

    function checkLocation(UNITS[] memory units) public pure returns(bool)
    {
        UNITS memory x = units[0];
        for(uint i=0;i<units.length; i++)
        {
            if(x.latitude != units[i].latitude || x.longitude != units[i].longitude)
            {
                return false;
            }
        }
        return true;
    }

    //RA refers to responsible address
    function combineEvents(address RA, UNITS[] memory units) public onlyOwner
    {
        require(checkLocation(units), "Location of events don't match");

        uint till = units.length;
        for(uint i=0;i < till ;i++)
        {
            remove(units[i].index);
        }

        
    }
    //Distribution phase occurs when every event is combined to one.

    //In events processing JS, we are gonna need
    //a frontend that allows to combine events 
    //by notifying when a list of units share a common location
    //after which the owner can add the 

}
