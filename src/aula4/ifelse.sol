// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.9.0;

contract sentencia_if {
    uint256 private numero;

    constructor(uint256 _numero) {
        numero = _numero;
    }

    //Numero ganhador
    function provarSorte(uint256 _numero) public view returns (bool) {
        bool ganhador;
        if (_numero == numero) {
            //se for o numero igual a inserido na construção ele será o ganhador
            ganhador = true;
        } else {
            ganhador = false;
        }

        return ganhador;
    }

    //Votacao
    //Temos somente tres candidatos: Joao, Gabriela y Maria

    function votar(string memory _candidato) public pure returns (string memory) {
        string memory msgee;
        //require("joao" == _candidato,"");

        if (keccak256(abi.encodePacked(_candidato)) == keccak256(abi.encodePacked("Joao"))) {
            msgee = "Quem votou corretamente foi o Joao";
        } else {
            if (
                keccak256(abi.encodePacked(_candidato)) == keccak256(abi.encodePacked("Gabriela"))
            ) {
                msgee = "Quem votou corretamente foi a Gabriel";
            } else {
                if (
                    keccak256(abi.encodePacked(_candidato)) == keccak256(abi.encodePacked("Maria"))
                ) {
                    msgee = "Quem votou corretamente foi a Maria";
                } else {
                    msgee = "Quem votou nao esta na lista";
                }
            }
        }

        return msgee;
    }
}