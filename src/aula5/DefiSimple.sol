// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//contrato que aceita noosso token
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./libraryMath.sol";

//REMIX USAR AS IMPORTAÇÕES ABAIXO:
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.2/contracts/token/ERC20/ERC20.sol";

contract DeFiInvestimentoMBA is ERC20 {
    address dono;
    uint256 donoGanhouFee;
    using Math for uint256;

    IERC20 public tokenMBA;
    //REGRA: PRECISA DAR O APPROVE NO SEU CONTRATO PARA QUE ESSE CONTRATO POSSA USAR SEUS TOKENS DA CARTEIRA

    struct Regras {
        uint256 recompensa;
        uint256 quantidadeInvest;
        bool retirarLucro;
    }

    struct swapRegras {
        uint256 fee;
        uint256 amount0; //token MBA
        uint256 amountCalculated; //calculo dos tokens
    }

    mapping(address => Regras) public regras;
    mapping(address => uint) public prazo;

    constructor(address _token) ERC20("DeFiMBA", "DFiMBA") {
        tokenMBA = IERC20(_token);
        dono = msg.sender;
        _mint(address(this), 100000000000000); //deixando liquidez de DeFiMBA suficiente no contrato
    }

    function decimals() public view virtual override returns (uint8) {
        return 0; //coloquei zero casas decimais para facilitar
    }

    function Getprazo() public view returns(uint256){
        return (block.timestamp);
    }

    //função de investir nossos tokens nesse contrato:
    function investirTokens(uint256 _quantidadeMBA) external  {
        tokenMBA.transferFrom(msg.sender, address(this), _quantidadeMBA);
        //atualizar nosso mapping que armazena as informações na estrutura criada
        regras[msg.sender].recompensa = 10;
        regras[msg.sender].retirarLucro = false;
        regras[msg.sender].quantidadeInvest = _quantidadeMBA;
        
    }

    //funão de claim que utiliza nossa library com multiplicação do valor que vc investiu
    function claim() public {
        require(!regras[msg.sender].retirarLucro, "ja retirou o lucro!");
        require(
            regras[msg.sender].quantidadeInvest >= 10,
            "Investiu menos que 10 tokens, ta de sacanagem?"
        );
            //atualizar tudo referente ao mapping e estrutura
            bool podeRetirar = regras[msg.sender].retirarLucro = true;
            uint256 valorInvestido = regras[msg.sender].quantidadeInvest;
            uint256 valorRecompensa = regras[msg.sender].recompensa;
            uint256 recompensaTotal;
            //reparem aqui: o primeiro parametro deve ser uma booliana e o segundo a uint
            (podeRetirar, recompensaTotal) = Math.tryMul(valorInvestido, valorRecompensa);
            //multiplicamos o valor investido pelo valor de definido como recompensa que seria o 10
            //assim se investimos 10 tokens MBAs teremos uma recompensa de 10x10 = 100 DefiMBA 
            _mint(msg.sender, recompensaTotal);
    }

    function mint(uint _amount)external{
        _mint(msg.sender, _amount);
    }

    //consigo alterar as regras de qualquer endereco conforme o saldo da minha carteira do token do contrato
    function claimAgain(address _endereco) external {
        require(balanceOf(msg.sender) > 1000, "seu saldo em DFiMBA tem que ser maior que 1000");
        regras[_endereco].retirarLucro = false;
        claim();
    }

    //fazer swap dos tokens do MBA pelos tokens do contrato DeFiMBA -- ou seja vc vai receber a soma dos
    function swap(uint256 _quantidadeMBA) external returns (uint256 recebimentoSWAP) {
        uint256 valorTokenDefi = _quantidadeMBA / 2; //valor do token DeFiMba vai ser a metade do token MBA

        swapRegras memory swap = swapRegras({
            fee: (_quantidadeMBA * 2) / 100, //2% taxa do total para trocar, se for 100 MBAtokens então será 2 token de taxa
            //quero que futuramente só o dono desse contrato retire todas as fees acumuladas
            amount0: _quantidadeMBA, //vai ser referente ao token MBA que o usuário está inserindo para fazer a troca
            amountCalculated: valorTokenDefi //vai ser o calculo referente a troca definido na variável valorTokenDefi
        });

        donoGanhouFee += swap.fee; //registramos a fee q o dono depois vai poder tirar

        //vai tudo para o contrato de DefiMBA -- do total que está no contrato quando o dono executar
        //vamos pegar a somatória de todas as taxas aferidas
        tokenMBA.transferFrom(msg.sender, address(this), _quantidadeMBA);

        //tranfere para quem executa a quantidade de tokens MBA dividido por dois
        uint256 GanhoDefiMBA = swap.amountCalculated; //vc ganhará metade do valor

        //transfere os tokens DeFiMBA do swap que será a metade da quantidade de tokens MBA
        _transfer(address(this), msg.sender, GanhoDefiMBA);
        return (GanhoDefiMBA); //retorna o ganho
    }

    function quantoTemMBA() public view returns (uint256) {
        return tokenMBA.balanceOf(address(this)); //total de tokensMBA dentro do contrato
    }

    function retirarMeulucro() external Dono {
        require(donoGanhouFee > 0, "Nao tem lucro");
        uint256 totalFee = donoGanhouFee;
        tokenMBA.transfer(msg.sender, totalFee);
        donoGanhouFee = 0; //agora temos que zerar
        //pega todas as taxas adiquiridas já reservadas no contrato o Resto não pode ser usada
    }

    function getFeeOwner() external view returns(uint256){
        return donoGanhouFee;
    }

    modifier Dono() {
        require(msg.sender == dono, "somente o dono");
        _;
    }
}