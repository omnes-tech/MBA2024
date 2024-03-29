// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract PrevRandaoExercicio {
    uint256 idade = 18; //numero que vamos setar em uma funcao
    bool sucess; //o numero que setarmos deve ser igual

    string nome; //nome do usuario
    address endereco; //armazenando seu endereco ao entrar na plataforma
    uint256 private senha; //armazenando a senha gerada aleatoriamente

    function confereNumber(uint256 _idade) internal view {
        //inserimos o view pq nao modificaremos nada na blockchain e o internal e de função que somente pode ser lida
        // no contrato
        require(_idade >= idade, "nao e permitido");
    }

    function EntraPlataform(string memory _nome, uint256 _idade) external returns (bool) {
        //conta EOA poderá interagir
        confereNumber(_idade);
        nome = _nome;
        sucess = true;
        return sucess;
    }

    function gerarSenha() external returns (uint256) {
        uint256 randomness = uint256(keccak256(abi.encodePacked(msg.sender, /*block.difficulty*/ block.prevrandao, block.timestamp)));
        senha = randomness; ////                     endereco   -  dificuldade para minera o bloco   - tempo atual
        return randomness;

        //uint256 randomNumber = block.prevrandao; // entrará no lugar do block.difficulty
    }

    function entreComsenha(uint256 _senha) external view returns (string memory) {
        require(senha == _senha, "sua senha esta incorreta");
        return ("sucesso no login");
    }
}