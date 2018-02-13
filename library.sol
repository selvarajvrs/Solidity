pragma solidity ^0.4.0;
contract Library
{
    int public BookCount;
    uint256 public totalAccount=0;
    address owner;
    struct book
    {
        string name;
        int TotalCount;
        int available;
    }
    struct accountant
    {
        string name;
        uint256[] books;
        uint256 book_count;
        uint256 penalty;
        uint256 time;
        bool holding;
        bool status;
    }
    mapping(uint256=>book) BOOKS;
    mapping(uint256=>accountant) account;
    modifier onlyOwner()
    {
        require(msg.sender==owner);
        _;
    }
    modifier accountHolder(uint256 _id)
    {
        require(account[_id].holding==true);
        _;
    }
    function test() public
    {
        owner=msg.sender;
    }
    function addBooks(uint256 _isbn,string _name,int _count) onlyOwner
    {
        BOOKS[_isbn].name=_name;
        BOOKS[_isbn].TotalCount+=_count;
        BOOKS[_isbn].available+=_count;
        BookCount+=_count;
    }
    function getBook(uint256 _id,uint256 _isbn)public payable accountHolder(_id)
    {
        require(BOOKS[_isbn].available>0);
        require(!account[_id].status);
        BOOKS[_isbn].available-=1;
        account[_id].books.push(_isbn);
        account[_id].book_count++;
        account[_id].time= now;
        account[_id].status=true;
    }
    function returnBook(uint256 _id,uint256 _isbn) accountHolder(_id)
    {
        uint256 validity=864000;
        uint256 takenTime=now-account[_id].time;
        if(takenTime>validity)
        {
            takenTime=takenTime-validity;
            account[_id].penalty=(takenTime/86400)*1;
        }
        if(account[_id].status)
        {
            BOOKS[_isbn].available+=1;
            account[_id].status=false;
        }
    }
    function searchBook(uint256 _isbn) view returns(string,int)
    {
        return(BOOKS[_isbn].name,BOOKS[_isbn].available);
    }
    function addAccount(uint _id,string _name) onlyOwner
    {
        account[_id].name=_name;
        account[_id].book_count=0;
        account[_id].penalty=0;
        account[_id].holding=true;
        totalAccount++;
    }
}
