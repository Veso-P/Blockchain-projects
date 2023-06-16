// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Lottery {
    address payable [] public players;
    address public owner;

    uint public ticketPrice;
    uint public gameEnd;

    constructor (uint _ticketPrice, uint _endsIn) {
        owner = msg.sender;
        ticketPrice = _ticketPrice;
        gameEnd = block.timestamp + _endsIn;
    }

    receive() external payable {
        require(msg.sender != owner, "Not allowed to participate!");
        require(msg.value == ticketPrice, "Ammount not appropriate!");
        players.push(payable(msg.sender));
    }

    function getBalance() public view onlyOwner returns (uint) {       
        return address(this).balance;
    }

    // Pseudo-random. To be improved ...
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public onlyOwner { 
        require(block.timestamp >= gameEnd, "Still active!");
        uint randomNumber = random();
        uint winnerIndex = randomNumber % players.length;
        
        players[winnerIndex].transfer(getBalance());
    }
    
    modifier onlyOwner () {
        require(msg.sender == owner,"Not owner");       
        _;
    }
}