// SPDX-License-Identifier: MIT
    pragma solidity 0.8.26;
    import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
    import "@openzeppelin/contracts/interfaces/IERC721.sol";
    contract Market{
         using SafeERC20 for IERC20;
        IERC20 public ERC20;
        IERC721 public  ERC721;
   constructor(address erc20,address erc721){
         require(erc20!=address(0),"zero address");
         require(erc721!=address(0),"zero address");
         ERC20=IERC20(erc20);
         ERC721=IERC721(erc721);
                                          }

    struct Order{
         address seller;
          uint256 tokenid;
         uint256 price;
                }
    mapping(uint256=>Order)public  OrderOfId;
    Order[] public orders ;
    event deal(address seller,address buyer,uint256 tokenid,uint256  price);
    event neworder(address seller,uint256 tokenid,uint256 price);
    event changeprice(address seller,uint256 tokenid,uint256 price,uint256 previoursprice);
    event ordercancelled(address seller,uint256 tokenid);
    function buy(uint256 tokenid) external {
        address seller=OrderOfId[tokenid].seller;
        address buyer=msg.sender;
        uint256 price=OrderOfId[tokenid].price;
       ERC20.safeTransferFrom(buyer,seller,price);
       ERC721.transferFrom(address(this), buyer, tokenid);
       emit deal(seller,buyer,tokenid,price);
    }
}