// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import {IERC20}from "./IERC20.sol";
abstract contract ERC20 is IERC20{
    uint256 private _totalsupply;
    string private _name;
    string private _symbol;

    mapping (address=>mapping (address=>uint256)) private _allowed;
    
    mapping (address=>uint256) private _balance;
    constructor(string memory name_, string memory symbol_){
        _name=name_;
        _symbol=symbol_;
    }
    function name() public view virtual returns(string memory){
        return _name;
    }
    function symbol() public view virtual returns(string memory){
        return _symbol;
    }
    function decimals() public view virtual returns (uint8) {
        return 18;
    }
    function approve(address spender ,uint256 value)external  returns  (bool ){
       address owner=msg.sender;
       _approve(owner,spender,value,true);
    return true;
    } 
    function totalsupply()public view virtual returns (uint256){
        return  _totalsupply;
    }
    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowed[owner][spender];
    }

    function _update(address from ,address to, uint256 value) internal  virtual {
        if(from==address(0)){
         _totalsupply+=value;
        }
        else {
            uint256 balancefrom=_balance[from];
            if(balancefrom<value){
                revert();
            }
            unchecked{
                _balance[from]-=value;
            }
        }
        if (to==address(0)){
            _totalsupply-=value;
        }
        else{
           unchecked{
            _balance[to]+=value;
           }
        }
        emit Transfer(from,to,value);
    }
    function _transfer(address from ,address to,uint256 value) internal {
        if(from==address(0)){
            revert();

        }
        if(to==address(0)){
            revert();

        }
        _update(from, to, value);
    }
     function transfer(address to,uint256 value)public virtual returns(bool){
        address owner=msg.sender;
        _transfer(owner , to, value);
        return true;

    }
     function transferfrom(address from, address to,uint256 value) public  returns(bool){
       _spenderAllowance(from,to,value);
        _transfer(from, to, value);
      //注意顺序，先验证再转账
        return true;
    }
   

   
    function _balanceof(address account) public virtual view returns(uint256){
        return _balance[account];
    }
    function mint(address account,uint256 value)internal {
       if(account==address(0)){
        revert();
       }else{
        _update(address(0),account, value);
       }
       
    }
        function burn(address account,uint256 value)internal returns(bool){
        if(account==address(0)){
        revert();
       }else{
        _update(account,address(0), value);
       }
       return true;
        }
    function _spenderAllowance(address owner,address spender,uint256 value) internal virtual {
        uint256 currentAllowance=_allowed [owner][spender];
        if(currentAllowance<type(uint256).max){
            if(currentAllowance<value){
                revert();
            }
            unchecked{
                _approve(owner,spender,currentAllowance-value,false);
            }
        }
    }
    function _approve(address owner,address spender,uint256 value,bool emitevent )internal {
        if(owner==address(0)){
            revert();
        }
        if(spender==address(0)){
            revert();
        }
    _allowed[owner][spender]=value;
    if(emitevent){
        emit approval(owner,spender,value);
    }
    }
}