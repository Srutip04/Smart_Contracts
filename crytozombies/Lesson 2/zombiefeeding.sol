
import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

  // Start here
  function feedAndMultiply(uint _zombieId,uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
  }

}
