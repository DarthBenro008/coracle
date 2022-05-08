pragma solidity >=0.5.0;

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
    function allowance(address _owner, address spender)
        external
        view
        returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}


contract Context {
    constructor() {}

    function _msgSender() internal view returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view returns (bytes memory) {
        this;
        return msg.data;
    }
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }


    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }


    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }


    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }


    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }


    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

 
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }


    function owner() public view returns (address) {
        return _owner;
    }

  
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

  
    function _transferOwnership(address newOwner) internal {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract BEP20Token is Context, IBEP20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint8 private _decimals;
    string private _symbol;
    string private _name;

    struct ColaData {
        uint256 id;
        string name;
        uint256 result;
        string api;
    }
    mapping(uint256 => ColaData) public colamos;
    mapping(uint256 => string) public colaQueue;
    uint256 public colamosCount;
    uint256 public queueCount;
    event ColamoUpdated(uint256 indexed id, string _name, uint256 result);
    event ColamoQueue(uint256 id, string name, uint256 result, string api);

    function addColamos(
        string memory _colaName,
        uint256 _result,
        string memory _api
    ) public {
        ColaData memory cold = ColaData(colamosCount, _colaName, _result, _api);
        colamos[colamosCount] = cold;
        colamosCount++;
    }

    function getById(uint256 _memberId) public view returns (ColaData memory) {
        return colamos[_memberId];
    }

    function getByName(string memory _colaName)
        public
        view
        returns (ColaData memory)
    {
        for (uint256 i = 0; i < colamosCount; i++) {
            if (
                keccak256(bytes(colamos[i].name)) == keccak256(bytes(_colaName))
            ) {
                return colamos[i];
            }
        }
        return colamos[0];
    }

    uint256 first = 1;
    uint256 last = 0;

    function enqueueCola(string memory _colaname) public {
        last += 1;
        colaQueue[last] = _colaname;
    }

    function dequeueCola() public returns (string memory data) {
        require(last >= first);

        data = colaQueue[first];

        delete colaQueue[first];
        first += 1;
    }

    // to add a request queue
    function addQueue(string memory _colaName) public {
        for (uint256 i = 0; i < colamosCount; i++) {
            if (
                keccak256(bytes(colamos[i].name)) == keccak256(bytes(_colaName))
            ) {
                emit ColamoQueue(
                    colamos[i].id,
                    colamos[i].name,
                    colamos[i].result,
                    colamos[i].api
                );
                enqueueCola(colamos[i].name);
                queueCount++;
            }
        }
    }

    // miner updating the value of the data
    function updateValue(string memory _colaName, uint256 result) public {
        for (uint256 i = 0; i < colamosCount; i++) {
            if (
                keccak256(bytes(colamos[i].name)) == keccak256(bytes(_colaName))
            ) {
                colamos[i].result = result;
                emit ColamoUpdated(
                    colamos[i].id,
                    colamos[i].name,
                    colamos[i].result
                );
                dequeueCola();
            }
        }
    }

    constructor() public {
        _name = "Colas";
        _symbol = "COLS";
        _decimals = 18;
        _totalSupply = 20000000;
        _balances[msg.sender] = _totalSupply;

        colamosCount = 0;
        queueCount = 0;
        addColamos("BTC/USD", 50, "https://api.pro.coinbase.com/products/BTC-USD/ticker");
        addColamos("ETH/USD", 50, "https://api.pro.coinbase.com/products/ETH-USD/ticker");
        addColamos("BNB/USD", 50, "https://dex.binance.org/api/v1/klines?symbol=BNB_USDSB-1AC&interval=1d&limit=1");
        addColamos("LTC/USD", 50, "https://api.binance.com/api/v1/klines?symbol=LTCUSDT&interval=1d&limit=1");
        addColamos("XRP/USD", 50, "https://api.binance.com/api/v1/klines?symbol=XRPUSDT&interval=1d&limit=1");
        addColamos("DOGE/USD", 50, "https://api.binance.com/api/v1/klines?symbol=XRPUSDT&interval=1d&limit=1");
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address) {
        return owner();
    }


    function decimals() external view returns (uint8) {
        return _decimals;
    }


    function symbol() external view returns (string memory) {
        return _symbol;
    }


    function name() external view returns (string memory) {
        return _name;
    }
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "BEP20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "BEP20: decreased allowance below zero"
            )
        );
        return true;
    }

    function mint(uint256 amount) public onlyOwner returns (bool) {
        _mint(_msgSender(), amount);
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(
            amount,
            "BEP20: transfer amount exceeds balance"
        );
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: burn from the zero address");

        _balances[account] = _balances[account].sub(
            amount,
            "BEP20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(
            account,
            _msgSender(),
            _allowances[account][_msgSender()].sub(
                amount,
                "BEP20: burn amount exceeds allowance"
            )
        );
    }
}
