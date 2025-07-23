//SPDX-License-Identifier: Unlicensed
pragma solidity >=0.6.0;

//UNISWAP Interfaces and library imports
import "hardhat/console.sol";
import "./Libraries/UniswapV2Library.sol";
import "./Libraries/SafeERC20.sol";
import "./Interfaces/IUniswapV2Router02.sol";
import "./Interfaces/IUniswapV2Router01.sol";
import "./Interfaces/IUniswapV2Factory.sol";
import "./Interfaces/IUniswapV2Pair.sol";
import "./Interfaces/IERC20.sol";


contract PancakeFlashSwap {
    using SafeERC20 for IERC20; // allow us to use the benefit of erc20 safely to approve transaction
    // INITIATING VARIBALES 
    // Factory and Routing Address 
    address private constant PANCAKE_FACTORY = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73; // CHANGE WITH PANCAKE ADDRESS THIS CONTRCAT IS WORKING ON BSC
    address private constant PANCAKE_ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;  // CHANGE with pancake router address, know that hard coding address make gas fees less 
    
    // //Token addresses 
    address private constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address private constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address private constant CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
    address private constant LINK = 0xF8A0BF9cF54Bb92F17374d9e9A321E6a111a51bD;
    address private constant CROX = 0x2c094F5A7D1146BB93850f629501eB749f6Ed491;
    address private constant USDT = 0x55d398326f99059fF775485246999027B3197955;

    // //Trade Variable 
    uint256 private deadline = block.timestamp + 1 days;
    uint256 private constant MAX_INT = 115792089237316195423570985008687907853269984665640564039457584007913129639935; // smart must know how much it should approve on behalf of a sender to make a trafe or wahtever function

    //Funding Function for the contract it is not so important but it is good to be there for our case
    //addres of the onwer to fund the contract , address of the token to interact with to fund the contract and the amount to fund
    function FundFlashSwapContract (
        address _owner, 
        address _token, 
        uint256 _amount
        ) public {
        IERC20(_token).transferFrom(_owner, address(this), _amount);
    }
    //Get Contract balance, allows public view of the balance for contrat of any token
    function getBalanceToken (address _address) public view returns (uint256){
        return IERC20(_address).balanceOf(address(this));
    }
    
    // Initiate arbitrage 
    // begins receiving loan to performing arbitrage trade
    function startArbitrage(address _tokenBorrow, uint256 _amount) external {
        IERC20(BUSD).safeApprove(address(PANCAKE_ROUTER), MAX_INT);
        IERC20(CAKE).safeApprove(address(PANCAKE_ROUTER), MAX_INT);
        IERC20(CROX).safeApprove(address(PANCAKE_ROUTER), MAX_INT);
        IERC20(USDT).safeApprove(address(PANCAKE_ROUTER), MAX_INT);

        //GET THE FACTORY PAIR ADDRESS FOR COMBINED TOKENS
        address pair = IUniswapV2Factory(PANCAKE_FACTORY).getPair(
            _tokenBorrow,
            WBNB
        );
        // Return error if combination does not exist
        require(pair != address(0),"Pool does not exist");

        // Figure out which token 0or 1 has the amount and assign 
        address token0 = IUniswapV2Pair(pair).token0();
        address token1 = IUniswapV2Pair(pair).token1();
        uint amount0Out = _tokenBorrow == token0 ? _amount: 0;
        uint amount1Out = _tokenBorrow == token1 ? _amount: 0;

        //Passing data as bytes that the swap function knows it is a flashswap
        bytes memory data = abi.encode(_tokenBorrow,_amount);

        //Execute the swap to get the loan
        IUniswapV2Pair(pair).swap(amount0Out, amount1Out, address(this), data);

    }
    function pancakeCall(
        address _sender, 
        uint256 _amount0, 
        uint256 _amount1, 
        bytes calldata _data
    ) external {
         //Ensure the request came from the contract
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();
        address pair = IUniswapV2Factory(PANCAKE_FACTORY).getPair(
            token0,
            token1
        );
        require(msg.sender ==  pair, "the sender needs to match the pair");
        require(msg.sender ==  address(this), "sender needs to match this contraact");

        //decode the data to calculate the payment
        (address tokenBorrow, uint256 amount) = abi.decode(
            _data,
            (address, uint256)
        );
        //calculate the amount to repay 
        uint256 fee = ((amount *3)/997)+1;
        uint256 amountToRepay = amount + fee;

        //do arbitrage

        // pay yourself

        // paying the loan back 
        IERC20(tokenBorrow).transfer(pair, amountToRepay);

     }
}   
