// SPDX-License-Identifier: MIT
/**
 *Submitted for verification at Etherscan.io on 2023-02-09
*/

pragma solidity ^0.8.0;

contract supplychain
{
    address public owner;

    function check() pure public returns(uint)
    {
        return 23;
    }
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
     
        param.index = Movers.length;
        Movers.push(param);

        adrToVendor[param.responsibleAddress] = vendor;
        
    }

    function modifyAdr(address adr, string memory vendor) public onlyOwner
    {
        adrToVendor[adr] = vendor;
    }

    //manufactering phase
    //combining shipments so they are brought together in a single package.

    function remove(uint index) onlyOwner public
    {
    Movers[index] = Movers[Movers.length - 1];
    Movers[index].index = index;
    Movers.pop();
    }

    function emitLocation(UNITS memory a) public
    {
        require(msg.sender == a.responsibleAddress, "not vendor");
        //only vendor can emit events related to location updates
        string memory vendor = adrToVendor[a.responsibleAddress];
        uint latitude = a.latitude;
        uint longitude = a.longitude;
        emit location(vendor, latitude, longitude);
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
        for(uint i=0;i < till-1 ;i++)
        {
            remove(units[i].index);
        }
        //Leaving last UNIT to be the integrated one
        units[till-1].responsibleAddress = RA;


    }
    //Distribution phase occurs when every event is combined to one.

    //In events processing JS, we are gonna need
    //a frontend that allows to combine events 
    //by notifying when a list of units share a common location
    //after which the owner can add the 

}
