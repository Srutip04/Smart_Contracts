
contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function createZombie (string memory _name, uint _dna) public {
        // start here
        zombies.push(Zombie(_name,_dna));
    }

}
