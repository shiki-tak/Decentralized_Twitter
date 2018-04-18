pragma solidity ^0.4.16;

import "./DTweetToken.sol";
import "./DTweetAuctionBase.sol";

contract DTweetAuction is DTweetToken, DTweetAuctionBase {

  /* function bid() {

  }

  function win_a_bid() {

  } */

  /* オークションを作成する */
  function createAuction(
    uint256 _tokenId,
    uint256 _startingPrice,
    uint256 _endingPrice,
    uint256 _duration
    ) external {
      require(_owns(msg.sender, _tokenId));
      _createAuction(
        _tokenId,
        _startingPrice,
        _endingPrice,
        _duration,
        msg.sender
    );
  }
}
