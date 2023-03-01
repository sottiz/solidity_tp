// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title BasicAMM
 * @dev Un modèle de base pour une AMM qui permet d'échanger un token ERC20 contre des ETH.
 */
contract AMM {
    using SafeMath for uint256;
    // Le token ERC20 qui peut être échangé contre des ETH
    ERC20 token;

    // La quantité de token dans la pool de liquidité
    uint256 tokenQuantity;

    // La quantité d'ETH dans la pool de liquidité
    uint256 ethQuantity;

    // Les frais pris sur les échanges
    uint256 feePercentage;

    // Le créateur du contrat
    address creator;

    /*
     * @dev Constructeur du contrat.
     * @param _token Le token ERC20 à échanger contre des ETH.
     * @param _tokenQuantity La quant

    /**
     * @dev Constructeur du contrat.
     * @param _token Le token ERC20 à échanger contre des ETH.
     * @param _tokenQuantity La quantité de token dans la pool de liquidité.
     * @param _ethQuantity La quantité d'ETH dans la pool de liquidité.
     * @param _feePercentage Les frais pris sur les échanges (en pourcentage).
     */
    constructor(ERC20 _token) public {

        token = _token;
        tokenQuantity = 1000000000000000000000000;
        ethQuantity = 1000000000000000000000000;
        feePercentage = 1;
        creator = msg.sender;
    }

    /**
     * @dev Ajoute de la liquidité à la pool.
     * @param _tokenQuantity La quantité de token à ajouter à la pool.
     * @param _ethQuantity La quantité d'ETH à ajouter à la pool.
     */
    function addLiquidity(uint256 _tokenQuantity, uint256 _ethQuantity) public {
        require(_tokenQuantity > 0, "Token quantity must be positive.");
        require(_ethQuantity > 0, "ETH quantity must be positive.");

        // Vérifie que le demandeur possède assez de chaque token pour les ajouter à la pool
        require(token.balanceOf(msg.sender) >= _tokenQuantity, "Requester does not own enough token.");
        require(msg.sender.balance >= _ethQuantity, "Requester does not own enough ETH.");

        // Envoie les tokens à la pool de liquidité
        token.transferFrom(msg.sender, address(this), _tokenQuantity);
        payable(address(msg.sender)).transfer(_ethQuantity);

        // Met à jour les quantités de tokens dans la pool
        tokenQuantity += _tokenQuantity;
        ethQuantity += _ethQuantity;
    }

    /**
     * @dev Enlève de la liquidité de la pool.
     * @param _tokenQuantity La quantité de token à retirer de la pool.
     * @param _ethQuantity La quantité d'ETH à retirer de la pool.
     */
    function removeLiquidity(uint256 _tokenQuantity, uint256 _ethQuantity) public {
        require(_tokenQuantity > 0, "Token quantity must be positive.");
        require(_ethQuantity > 0, "ETH quantity must be positive.");

        // Vérifie que la pool possède assez de chaque token pour les retirer
        require(tokenQuantity >= _tokenQuantity, "Pool does not own enough token.");
        require(ethQuantity >= _ethQuantity, "Pool does not own enough ETH.");

        // Envoie les tokens et l'ETH au demandeur
        token.transfer(msg.sender, _tokenQuantity);
        payable(address(msg.sender)).transfer(_ethQuantity);

        // Met à jour les quantités de tokens dans la pool
        tokenQuantity -= _tokenQuantity;
        ethQuantity -= _ethQuantity;
    }

    /**
     * @dev Échange des ETH contre du token.
     * @param _ethQuantity La quantité d'ETH à échanger.
     * @param _minTokenOut La quantité minimale de token à recevoir.
     * @param _slippage Le slippage acceptable (en pourcentage).
     */
    function swapETHForToken(uint256 _ethQuantity, uint256 _minTokenOut, uint256 _slippage) public {
        require(_ethQuantity > 0, "ETH quantity must be positive.");
        require(_minTokenOut > 0, "Minimum token quantity must be positive.");
        require(_slippage >= 0 && _slippage <= 100, "Slippage must be between 0 and 100.");

        // Vérifie que le demandeur possède assez d'ETH à échanger
        require(msg.sender.balance >= _ethQuantity, "Requester does not own enough ETH.");

        // Calcule la quantité de token à recevoir en prenant en compte les frais et le slippage
        uint256 tokenOut = calculateTokenOut(_ethQuantity, _minTokenOut, _slippage);

        // Vérifie que la pool possède assez de token à échanger
        require(tokenQuantity >= tokenOut, "Pool does not own enough token.");

        // Échange les tokens
        payable(address(msg.sender)).transfer(_ethQuantity);
        token.transfer(msg.sender, tokenOut);

        // Met à jour les quantités de tokens dans la pool
        ethQuantity -= _ethQuantity;
        tokenQuantity -= tokenOut;
    }

    /**
    
    /**
     * @dev Échange du token contre des ETH.
     * @param _tokenQuantity La quantité de token à échanger.
     * @param _minEthOut La quantité minimale d'ETH à recevoir.
     * @param _slippage Le slippage acceptable (en pourcentage).
     */
    function swapTokenForETH(uint256 _tokenQuantity, uint256 _minEthOut, uint256 _slippage) public {
        require(_tokenQuantity > 0, "Token quantity must be positive.");
        require(_minEthOut > 0, "Minimum ETH quantity must be positive.");
        require(_slippage >= 0 && _slippage <= 100, "Slippage must be between 0 and 100.");

        // Vérifie que le demandeur possède assez de token à échanger
        require(token.balanceOf(msg.sender) >= _tokenQuantity, "Requester does not own enough token.");

        // Calcule la quantité d'ETH à recevoir en prenant en compte les frais et le slippage
        uint256 ethOut = calculateEthOut(_tokenQuantity, _minEthOut, _slippage);

        // Vérifie que la pool possède assez d'ETH à donner
        require(ethQuantity >= ethOut, "Pool does not own enough ETH.");

        // Échange les ETH
        token.transferFrom(msg.sender, address(this), _tokenQuantity);
        payable(address(msg.sender)).transfer(ethOut);

        // Met à jour les quantités de tokens dans la pool
        tokenQuantity += _tokenQuantity;
        ethQuantity -= ethOut;
    }

    /**
     * @dev Calcule la quantité de token à recevoir en prenant en compte les frais et le slippage.
     * @param _ethQuantity La quantité d'ETH à échanger.
     * @param _minTokenOut La quantité minimale de token à recevoir.
     * @param _slippage Le slippage acceptable (en pourcentage).
     * @return La quantité de token à recevoir.
     */
    function calculateTokenOut(uint256 _ethQuantity, uint256 _minTokenOut, uint256 _slippage) internal view returns (uint256) {
        // Obtient le taux de change entre les ETH et le token
        uint256 exchangeRate = getExchangeRate();

        // Ajoute les frais au taux de change
        exchangeRate = addFeeToExchangeRate(exchangeRate);

        // Applique le slippage au taux de change
        exchangeRate = applySlippage(exchangeRate, _slippage);

        // Calcule la quantité de token à recevoir
        uint256 tokenOut = _ethQuantity.mul(exchangeRate).div(1e18);

        // Vérifie que la quantité de token à recevoir est supérieure à la quantité minimale demandée
        require(tokenOut >= _minTokenOut, "Slippage is too high.");

        return tokenOut;
    }

    /**
     * @dev Calcule la quantité d'ETH à recevoir en prenant en compte les frais et le slippage.
     * @param _tokenQuantity La quantité de token à échanger.
     * @param _minEthOut La quantité minimale d'ETH à recevoir.
     * @param _slippage Le slippage acceptable (en pourcentage).
     * @return La quantité d'ETH à recevoir.
     */
    function calculateEthOut(uint256 _tokenQuantity, uint256 _minEthOut, uint256 _slippage) internal view returns (uint256) {
        // Obtient le taux de change entre le token et les ETH
        uint256 exchangeRate = getExchangeRate();

        // Soustrait les frais au taux de change
        exchangeRate = subtractFeeFromExchangeRate(exchangeRate);

        // Applique le slippage au taux de change
        exchangeRate = applySlippage(exchangeRate, _slippage);

        // Calcule la quantité d'ETH à recevoir
        uint256 ethOut = _tokenQuantity.mul(exchangeRate).div(1e18);

        // Vérifie que la quantité d'ETH à recevoir est supérieure à la quantité minimale demandée
        require(ethOut >= _minEthOut, "Slippage is too high.");

        return ethOut;
    }

    /**
     * @dev Obtient le taux de change entre les ETH et

    /**
     * @dev Obtient le taux de change entre les ETH et le token.
     * @return Le taux de change.
     */
    function getExchangeRate() internal view returns (uint256) {
        return tokenQuantity.mul(1e18).div(ethQuantity);
    }

    /**
     * @dev Ajoute les frais au taux de change.
     * @param _exchangeRate Le taux de change.
     * @return Le taux de change avec les frais ajoutés.
     */
    function addFeeToExchangeRate(uint256 _exchangeRate) internal view returns (uint256) {
        return _exchangeRate.mul(100).div(100 - feePercentage);
    }

    /**
     * @dev Soustrait les frais au taux de change.
     * @param _exchangeRate Le taux de change.
     * @return Le taux de change avec les frais soustraits.
     */
    function subtractFeeFromExchangeRate(uint256 _exchangeRate) internal view returns (uint256) {
        return _exchangeRate.mul(100).div(100 + feePercentage);
    }

    /*
     * @dev Applique le slippage au taux de change.
     * @param _exchangeRate Le taux de change.
     * @param _slippage Le slippage acceptable (en pourcentage).
     * @return Le taux de change avec le slippage appliqué.
     */
    function applySlippage(uint256 _exchangeRate, uint256 _slippage) internal view returns (uint256) {
        // Calcule le taux de change maximal acceptable
        uint256 maxExchangeRate = _exchangeRate.mul(100 + _slippage).div(100);

        // Calcule le taux de change minimal acceptable
        uint256 minExchangeRate = _exchangeRate.mul(100 - _slippage).div(100);

        // Vérifie que le taux de change est compris entre le taux maximal et minimal acceptables
        require(_exchangeRate <= maxExchangeRate, "Exchange rate is higher than the maximum acceptable rate.");
        require(_exchangeRate >= minExchangeRate, "Exchange rate is lower than the minimum acceptable rate.");

        return _exchangeRate;
    }

    /**
     * @dev Modifie les frais pris sur les échanges.
     * @param _feePercentage Les frais à prendre sur les échanges (en pourcentage).
     */
    function setFeePercentage(uint256 _feePercentage) public {
        // Vérifie que seul le créateur du contrat peut modifier les frais
        require(msg.sender == creator, "Only the contract creator can change the fee.");

        // Vérifie que les frais sont compris entre 0% et 100%
        require(_feePercentage >= 0 && _feePercentage <= 100, "Fee percentage must be between 0% and 100%.");

        feePercentage = _feePercentage;
    }
}

