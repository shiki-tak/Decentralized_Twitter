pragma solidity ^0.4.16;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';

contract DTweetToken is ERC721Token {

  /* DATA TYPE */
  struct DTweet {
    string title;
    string content;
    bool publishing;
    address mintedBy;
    uint64 mintedAt;
  }

  /* STORAGE */
  DTweet[] DTweets;

  event Mint(address owner, uint256 tokenId);

  /* CONSTRUCTOR */
  function DTweetToken(string _name, string _symbol) public ERC721Token(_name, _symbol) {}

  /* ERC721 IMPLEMENTATION */
  function mint(string _title, string _content, bool _publishing) external returns (uint256) {
    require(msg.sender != address(0));
    DTweet memory dTweet = DTweet({
        title: _title,
        content: _content,
        publishing: _publishing,
        mintedBy: msg.sender,
        mintedAt: uint64(now)
      });
      uint256 tokenId = DTweets.push(dTweet) - 1;
      super._mint(msg.sender, tokenId);

      Mint(msg.sender, tokenId);
      return tokenId;
  }

  function burn(uint256 _tokenId) public {
    super._burn(ownerOf(_tokenId), _tokenId);
    if (DTweets.length != 0) {
      delete DTweets[_tokenId];
    }
  }

  function getArticle(uint256 _tokenId) external view returns (string title, string content, bool publishing, address mintedBy, uint64 mintedAt) {
    DTweet memory dTweet = DTweets[_tokenId];

    title = dTweet.title;
    content = dTweet.content;
    publishing = dTweet.publishing;
    mintedBy = dTweet.mintedBy;
    mintedAt = dTweet.mintedAt;
  }

  function getAllArticlesOfOwner(address _owner) external view returns (uint256[]) {
    return ownedTokens[_owner];
  }

  function getAllArticles() external view returns (uint256[]) {
    return allTokens;
  }
}
