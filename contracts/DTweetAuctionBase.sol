pragma solidity ^0.4.16;

import "zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol";

contract DTweetAuctionBase {

  struct Auction {
    address seller;
    uint128 startingPrice;
    uint128 endingPrice;
    uint64 duration;
    uint64 startedAt;
  }

  mapping (uint256 => Auction) tokenIdToAuction;

  event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
  
  /*** Base function start ***/
  ERC721Basic public nonFungibleContract;

  function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
    return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
  }

  /* このコントラクトに所有権を割り当て、NFTを強制終了する */
  function _escrow(address _owner, uint256 _tokenId) internal {
    nonFungibleContract.transferFrom(_owner, this, _tokenId);
  }

  function _addAuction(uint256 _tokenId, Auction _auction) internal {
    require(_auction.duration >= 1 days);
    tokenIdToAuction[_tokenId] = _auction;

    AuctionCreated(
      uint256(_tokenId),
      uint256(_auction.startingPrice),
      uint256(_auction.endingPrice),
      uint256(_auction.duration)
    );
  }


  /*** end ***/


}
