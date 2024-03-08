// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

//Lembre-se que o contrato abaixo e um exemplo de avancado e assim como exemplo para mostrarmos 
//que a blockchain e determinisica e sabemos o endereco antes de implementa-lo

contract DeployCreate2 { //exemplo de contrato que vamos descobrir o seu endereco
    address public owner;

    constructor(address _owner) {
        owner = _owner; //unico paraetro dele vai ser setar o owner
    }
}

contract Create2Factory {//contrato para criarmos e adivinharmos o endereco do contrato acima
    event Deploy(address addr);

    function deploy(uint256 _salt) external{
        DeployCreate2 _contract = new DeployCreate2{
            salt: bytes32(_salt)
        }(msg.sender);
        emit Deploy(address(_contract));
    }

    function getAddress(bytes memory bytecode, uint _salt)
    public view returns (address){
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff),
        address(this), _salt, keccak256((bytecode))));
        return address(uint160(uint(hash)));
        //em resumo estamos descobrindo o hash do endereco do contrato conforme seu bytecode descoberto na funcao abaixo
        //encodamos uma serie de fatores determinantes para descobrimos isso
    }

    function getBytecode(address _owner)public pure returns (bytes memory){
        bytes memory bytecode = type(DeployCreate2).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_owner));
        //retornar o bytecode conforme o parametro que deve ser setado no contrato
    }
}
