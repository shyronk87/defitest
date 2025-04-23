// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
contract ERC20 {
    uint256 private _totalsupply;
    string private _name;
    string private _symbol;

    mapping (address=>mapping (address=>uint256)) private _allowed;
    
    mapping (address=>uint256) private balance;
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
    function approve(address spender ,uint256 value)public returns  (bool ){
        require(spender!=address(0));
    _allowed[spender][msg.sender]=value;
    emit Approve(spender,value);
    return true;
    } 
    function totalsupply()public view virtual returns (uint256){
        return  _totalsupply;
    }
    function transfer(address to,uint256 value)public virtual returns(bool){
        require(value<=balance[msg.sender]);
        require(to!=address[0]);
        balance[msg.sender]-=value;
        balance[to]+=value;
        emit Transer(to,value);
        return true;
    }
    // function transfer(address to, uint256 value) public virtual returns (bool) {
    //     address owner = _msgSender();
    //     _transfer(owner, to, value);
    //     return true;
    // }
    //  function _transfer(address from, address to, uint256 value) internal {
    //     if (from == address(0)) {
    //         revert ERC20InvalidSender(address(0));
    //     }
    //     if (to == address(0)) {
    //         revert ERC20InvalidReceiver(address(0));
    //     }
    //     _update(from, to, value);
    // }
    //   function _update(address from, address to, uint256 value) internal virtual {
    //     if (from == address(0)) {
    //         // Overflow check required: The rest of the code assumes that totalSupply never overflows
    //         _totalSupply += value;
    //     } else {
    //         uint256 fromBalance = _balances[from];
    //         if (fromBalance < value) {
    //             revert ERC20InsufficientBalance(from, fromBalance, value);
    //         }
    //         unchecked {
    //             // Overflow not possible: value <= fromBalance <= totalSupply.
    //             _balances[from] = fromBalance - value;
    //         }
    //     }

    //     if (to == address(0)) {
    //         unchecked {
    //             // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
    //             _totalSupply -= value;
    //         }
    //     } else {
    //         unchecked {
    //             // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
    //             _balances[to] += value;
    //         }
    //     }

    //     emit Transfer(from, to, value);
    // }

    function transferfrom(address from, address to,uint256 value) public  returns(bool){
        require(value<=balance[from]);
        require(to!=address[0]);
        balance[from]-=value;
        balance[to]+=value;
          emit transferfrom(from, to, value);
        return true;
    }
    function balanceof(address account) public virtual view returns(uint256){
        return balance[account];
    }
    function mint(address account,uint256 value)internal {
        require(account!=address[0]);
        _totalsupply+=value;
        balanceof(account)+=value;
        emit Mint(account,value);
       
    }
        function burn(address spender,uint256 value)internal returns(bool){
        require(spender!=address[0]);
        require(value<=balance[spender]);
        _totalsupply-=value;
        balanceof(spender)-=value;
        emit Burn(spender,value);
        return true;
        }
    
}