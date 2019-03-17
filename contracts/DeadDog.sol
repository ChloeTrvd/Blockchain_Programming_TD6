pragma solidity ^0.4.25;

import "./ERC721Burnable.sol";

contract BurnableToken is ERC721Burnable {
    event Burn(address indexed burner, uint256 value);
    
    function burn(uint256 _value) public {
    _burn(msg.sender, _value);
    }

    function deadDog(address owner, uint256 newDogId) public returns (bool success) {
        _burn(newDogId);
        emit Burn(owner, newDogId);
        return true;
    }
}