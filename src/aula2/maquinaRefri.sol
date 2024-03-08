// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.9;
//import "hardhat/console.sol";

contract MaquinaRefri {
    

    uint256 valorMinimo = 3 wei;
    string[] Refri = ["coca", "fanta", "guarana"];
    //opções:            0       1         2

    mapping(address => uint256) saldo;

    function depositarValor() public payable{
        require(msg.value >= valorMinimo, "Insira pelo menos tres weis");
        saldo[msg.sender] += msg.value;
        payable(msg.sender).transfer(msg.value);
    }

    function comprarRefri(string memory opcaoNum) public payable ConfereSaldo ConfereRefri(opcaoNum){
        if(compareStrings(opcaoNum, Refri[0])){
            require(msg.value == 3 wei, "valor da coca incorreto");
            saldo[msg.sender] -= msg.value;
        }if (compareStrings(opcaoNum, Refri[1])){
            require(msg.value == 2 wei, "valor da fanta incorreto");
             saldo[msg.sender] -= msg.value;
        }if (compareStrings(opcaoNum, Refri[2])){
            require(msg.value == 1 wei, "valor do guarana incorreto");
             saldo[msg.sender] -= msg.value;
        }
            string memory msge = "compra efetuada";
            //console.log(msge);
    }

    function conferirValorNaMaquin()public view returns(uint256){
        return saldo[msg.sender];
    }

    //Helpers -- vai chegcar se a string de a encodada vai ser a de b.
    function compareStrings(string memory a, string memory b) internal pure returns(bool){
        return (keccak256(abi.encodePacked(a)) ==  keccak256(abi.encodePacked(b)));
    }

    modifier ConfereSaldo(){
        require(conferirValorNaMaquin() > 0, "saldo zerado");//tem que ser
        _;
    }

    modifier ConfereRefri(string memory opcao){
        require(compareStrings(opcao, Refri[0]) ||
        compareStrings(opcao, Refri[1]) || 
        compareStrings(opcao, Refri[2]), "nao temos a opcao");
        _;
    }


}