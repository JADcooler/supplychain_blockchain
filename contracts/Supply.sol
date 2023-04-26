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
   

    modifier onlyOwner()
    {
        require(msg.sender == owner, "Authorized only to Owner");
        _;
    }
    mapping(address => string) public adrToVendor;
    event location(string indexed vendor, uint latitiude, uint longitude);


    mapping(address => uint) adrToIndex;
    
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

    
    function len() public view returns(uint256)
    {
        return Movers.length;
    }

    function add_unit(UNITS memory param, string memory vendor) public onlyOwner
    {
     
        param.index = Movers.length;
        Movers.push(param);

        adrToVendor[param.responsibleAddress] = vendor;
        adrToIndex[param.responsibleAddress] = param.index;
    }

    constructor()
    {
        owner = msg.sender;
        UNITS memory dummy; //dummy to make check through index possible (else default will be 0)
        add_unit(dummy,"");  
    }

    function modifyAdr(address adr, string memory vendor) public onlyOwner
    {
        adrToVendor[adr] = vendor;
    }

    //manufactering phase
    //combining shipments so they are brought together in a single package.

    function remove(uint index) onlyOwner public
    {
        require(index!=0, "Cannot remove dummy Supplier unit at start of Movers array");
        Movers[index] = Movers[Movers.length - 1];
        Movers[index].index = index;
        Movers.pop();
    }

    function emitLocation(uint256 lat, uint256 long) public
    {
        uint ind = adrToIndex[msg.sender];
        require( (ind > 0) && (ind < Movers.length), "not vendor");
        //only vendor can emit events related to location updates
        Movers[ind].latitude = lat;
        Movers[ind].longitude = long;

        string memory vendor = adrToVendor[msg.sender];        
        emit location(vendor, lat, long);
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
        add_unit(units[till-1],adrToVendor[units[till-1].responsibleAddress]);


    }
    //Distribution phase occurs when every event is combined to one.

    //In events processing JS, we are gonna need
    //a frontend that allows to combine events 
    //by notifying when a list of units share a common location
    //after which the owner can add the 

}
