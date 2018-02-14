pragma solidity ^0.4.0;
contract voting
{
    struct  data 
    {
        string name;
        int vote_count;
    }
    mapping(string=>data) v;
    mapping(string=>bool) voters;
    uint256 count;
    function voting() public
    {
        v["a"].name="A";
        v["b"].name="B";
        v["c"].name="C";
        v["a"].vote_count=0;
        v["b"].vote_count=0;
        v["c"].vote_count=0;
        count=0;
    }
    function vote(string _name,string voter) payable public
    {
        require(!val(voter));
        voters[voter]=true;
        vot(_name);
        
    }
    function vot(string _name1) public
    {
        v[_name1].vote_count++;
    }
    function val(string _v) public view returns (bool)
    {
        return voters[_v];
    }
    function result(string can)public view returns(int)
    {
        return v[can].vote_count;
    }
}
