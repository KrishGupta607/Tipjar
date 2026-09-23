// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts@5.7.0/access/Ownable.sol";
contract TipJar is Ownable{
    mapping(address => uint256) public totalTipped;
    uint256 public totalReceived;
    constructor() Ownable(msg.sender) {}
    event tipped(address indexed from, uint256 amount, uint256 newTotal);
    
    function deposit() external payable {
        require(msg.value > 0, "zero tip");
        totalReceived += msg.value;
        totalTipped[msg.sender] += msg.value;
        emit tipped(msg.sender, msg.value,  totalTipped[msg.sender]);
    }
    
    function withdraw() external onlyOwner {
        address ownerAddress = owner();
        address payable destination = payable(ownerAddress);
        uint256 amount = address(this).balance;
        (bool ok, ) = destination.call{value: amount}("");
        require(ok, "withdraw failed");
    }
}
