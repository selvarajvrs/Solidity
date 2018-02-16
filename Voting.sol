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
    address Election_commission;
    
    modifier only_Election_commission
    {
        require(Election_commission==msg.sender);
        _;
    }
    function voting() public
    {
        v["a"].name="A";
        v["b"].name="B";
        v["c"].name="C";
        v["a"].vote_count=0;
        v["b"].vote_count=0;
        v["c"].vote_count=0;
        count=0;
        Election_commission=msg.sender;
    }
    
    function setCountToZero() only_Election_commission
    {
        v["a"].vote_count=0;
        v["b"].vote_count=0;
        v["c"].vote_count=0;
    }
    function vote(string candidate_name,string voter_name) payable public
    {
        require(!voters[voter_name]);
        voters[voter_name]=true;
        v[candidate_name].vote_count++;
        count++;
    }
    
    function result()public view returns(string)
    {
        if((v["a"].vote_count>v["b"].vote_count)&&v["a"].vote_count>v["c"].vote_count)
            return "A is the winner";
        else if(v["b"].vote_count>v["a"].vote_count&&v["b"].vote_count>v["c"].vote_count)
            return "B is the winner";
        else if(v["c"].vote_count>v["a"].vote_count&&v["c"].vote_count>v["b"].vote_count)
            return "C is the Winner";
        if((v["a"].vote_count==v["b"].vote_count)||(v["a"].vote_count==v["c"].vote_count)||(v["b"].vote_count==v["b"].vote_count))
            return "Votes are Equal";
            
    }
}
