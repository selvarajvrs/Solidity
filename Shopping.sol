pragma solidity ^0.4.0;
import "./StandardToken.sol";
contract Shopping is StandardToken
{
    address admin;
    uint256 constant price=1 ether;
    bytes32[] productName;
    uint256[] productId;
    uint256 public count;
    mapping(uint256=>uint256)checkavail;
    uint256[] public available;
    uint256 lowCount;
    uint256 public billNum;
    uint256[] quantity;
    function Inventry() public
    {
        admin=msg.sender;
    }
    function () public payable
    {
        buyToken(1);
    }
     function buyToken(uint256 tokens) public payable
    {
        require(msg.value==(tokens * price)&& tokens <=balanceOf[admin]);
        balanceOf[msg.sender]+=tokens;
        balanceOf[admin]-=tokens;
        admin.transfer(msg.value);
        if(balanceOf[admin]==0)
        {
            selfdestruct(admin);
        }
    }
    struct products
    {
        bytes32 name;
        uint256 price;
        uint256 quantity;
        bool present;
        bool lowquantity;
    }
    struct bills
    {
        uint256 total_items;
        uint256 cost;
        bool received;
        address customer;
    }
    modifier OnlyOwner()
    {
        require(admin==msg.sender);
        _;
    }
    mapping(uint256=>products) product;
    mapping(uint256=>bills)bill;
    function add_Items(uint256 _pro_id1, bytes32 pro_name1, uint256 _price1,uint256 _quantity1) public OnlyOwner returns(bool)
    {
        if(product[_pro_id1].present)
        {
            product[_pro_id1].quantity+=_quantity1;
            product[_pro_id1].price=_price1;
            return true;
        }
        product[_pro_id1].name=pro_name1;
        product[_pro_id1].price=_price1;
        product[_pro_id1].quantity+=_quantity1;
        product[_pro_id1].present=true;
        productName.push(pro_name1);
        quantity.push(_quantity1);
        productId.push(_pro_id1);
        count++;
        if(product[_pro_id1].quantity<=5&&!product[_pro_id1].lowquantity)
        {
            product[_pro_id1].lowquantity=true;
            available.push(_pro_id1);
            lowCount++;
        }
        else
        {
            product[_pro_id1].lowquantity=false;
        }
        return true;
    }
    function showList() public view returns(uint256[],bytes32[],uint256[])
    {
        return (productId,productName,quantity);
    }
    function remove_Items(uint256 _pro_id) public OnlyOwner
    {
        product[_pro_id].name="";
        product[_pro_id].price=0;
        product[_pro_id].quantity=0;
        product[_pro_id].present=false;
    }
    function search_product(uint256 _pro_id) public view returns(uint256,uint256)
    {
        if(product[_pro_id].present)
            return (product[_pro_id].price,product[_pro_id].quantity);
    }
    function check() public
    {
        uint256 k=lowCount;
        while(k!=0)
        {
            uint256 x=available[k-1];
            uint256 y=product[x].quantity;
            if(y>5)
                available[k-1]=0;
            k--;
        }
    }
    function getLowProducts() public view returns(uint256[])
    {
        return available;
    }
    function buy_product(uint256 _pro_id,uint256 amount,uint256 _pro_count) public returns(string,uint256)
    {
        require((product[_pro_id].price*_pro_count)==amount);
        if(product[_pro_id].present&&product[_pro_id].quantity>_pro_count)
        {
            product[_pro_id].quantity-=_pro_count;
            billNum++;
            bill[billNum].total_items=_pro_count;
            bill[billNum].received=true;
            if((product[_pro_id].quantity)==0){
                product[_pro_id].present=false;
            }
            transfer(admin,amount);
            bill[billNum].customer=msg.sender;
            bill[billNum].cost=amount;
        }
        else
            return ("product not available",billNum);
        if(product[_pro_id].quantity<=5&&!product[_pro_id].lowquantity)
        {
            product[_pro_id].lowquantity=true;
            available.push(_pro_id);
            lowCount++;
        }
        return ("",billNum);
    }
    function getBill(uint256 _billNum) public view returns(uint256,uint256,bool,address)
    {
        return (bill[_billNum].total_items,bill[_billNum].cost,bill[_billNum].received,bill[_billNum].customer);
    }
}
