// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

/*
Yul é uma fina camada de abstração na linguagem opcode EVM que pode ser usada 
em um arquivo de contrato Yul autônomo ou em um arquivo de contrato Solidity 
por meio de um assembly bloco.

Entendimento de gas e a importancia da eficiencia
*/

contract OpcodeGas {

//exemplo de shangai e PUSH0 com pequena economia de gas
     function unsafeAdd(uint256 a, uint256 b) external pure returns (uint256) {
        unchecked{
            return a+b; //781 sem ser shangai e 771 gas in shangai
        }
    }

    function somaEmsolidity(uint256 a, uint256 b) external pure returns (uint256) {
        uint256 soma = a + b;
        return soma; // 954 gas
    }

    function somaemOpcodeYul(uint256 a, uint256 b) external pure returns (uint256 result) {
        assembly {
            result := add(a, b)
        }
        return result; // 781 gas
    }
}