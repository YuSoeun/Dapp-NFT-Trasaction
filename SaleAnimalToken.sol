// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "MintAnimalToken.sol";

contract SaleAnimalToken {
    MintAnimalToken public mintAnimalTokenAddress;

    constructor(address _mintAnimalTokenAddress) {
        mintAnimalTokenAddress = MintAnimalToken(_mintAnimalTokenAddress);
    }

    mapping (uint256 => uint256) public animalTokenPrices;
    uint256[] public onSaleAnimalTokenArray;

    function setForSaleAnimalToken(uint256 _animalTokenId, uint256 _price) public {
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId);

        require(animalTokenOwner == msg.sender, "not owner");   // 주인이여야 등록
        require(_price > 0 , "lower price");
        require(animalTokenPrices[_animalTokenId]==0, "already on sale");
        require(mintAnimalTokenAddress.isApprovedForAll(animalTokenOwner,address(this)),"Animal token owner did not approve token");

        animalTokenPrices[_animalTokenId] = _price;

        onSaleAnimalTokenArray.push(_animalTokenId);
    }

    function purchaseAnimalToken(uint256 _animalTokenId) public payable {
        uint256 price = animalTokenPrices[_animalTokenId];
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId);

        require(price > 0, "AnimalToken not sale");             // 등록 안되어있는 것
        require(price <= msg.value , "not money");
        require(animalTokenOwner != msg.sender , "not owner");  // 주인이 아니여야 구입

        payable(animalTokenOwner).transfer(msg.value);
        // 보내는 사람, 받는 사람, 뭘 보낼 것인가
        mintAnimalTokenAddress.safeTransferFrom(animalTokenOwner,msg.sender, _animalTokenId);

        animalTokenPrices[_animalTokenId] = 0;

        for (uint256 i = 0; i < onSaleAnimalTokenArray.length; i++) {
            if (animalTokenPrices[onSaleAnimalTokenArray[i]] == 0) {
                // 맨 뒤에 애랑 i번째 교체하고 pop
                onSaleAnimalTokenArray[i] = onSaleAnimalTokenArray[onSaleAnimalTokenArray.length-1];
                onSaleAnimalTokenArray.pop();
            }
        }
    }
    
    // 판매중인 animal token 읽기
    function getOnSaleAnimalTokenArrayLength() view public returns (uint256){
        return onSaleAnimalTokenArray.length;
    }
}