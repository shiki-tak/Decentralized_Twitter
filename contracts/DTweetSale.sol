pragma solidity ^0.4.16;

import "./DTweetAuctionBase.sol";

contract DTweetSale is DTweetAuctionBase {

  function createAuction(
    uint256 _tokenId,
    uint256 _startingPrice,
    uint256 _endingPrice,
    uint256 _duration,
    address _seller
    )
      external {
        require(msg.sender == address(nonFungibleContract));
        _escrow(_seller, _tokenId);
        Auction memory auction = Auction(
          _seller,
          uint128(_startingPrice),
          uint64(_endingPrice),
          uint64(_duration),
          uint64(now)
        );
        _addAuction(_tokenId, auction);
  }
}
