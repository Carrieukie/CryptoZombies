pragma solidity ^0.4.25;

contract ZombieFactory {

    //Create an event that blockchain clients can listen to
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    //Zombie blueprint
    struct Zombie {
        string name;
        uint dna;
    }

    //Make an array of zombies
    Zombie[] public zombies;

    //map zombies to their owners
    mapping (uint => address) public zombieToOwner;
    
    //map zombie owners to the amount of zombies they own
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) internal {
    
        //create a zombie and add them to the zombies array
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        
        //map the zombies id to their owner
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
