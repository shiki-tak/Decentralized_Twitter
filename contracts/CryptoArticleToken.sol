pragma solidity ^0.4.16;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';

contract CryptoArticleToken is ERC721Token {

  /* DATA TYPE */
  struct CryptoArticle {
    string title;
    string content;
    bool publishing;
    address mintedBy;
    uint64 mintedAt;
  }

  /* STORAGE */
  CryptoArticle[] cryptoArticles;

  event Mint(address owner, uint256 tokenId);

  /* CONSTRUCTOR */
  function CryptoArticleToken(string _name, string _symbol) public ERC721Token(_name, _symbol) {}

  /* ERC721 IMPLEMENTATION */
  function mint(string _title, string _content, bool _publishing) external returns (uint256) {
    require(msg.sender != address(0));
    CryptoArticle memory cryptoArticle = CryptoArticle({
        title: _title,
        content: _content,
        publishing: _publishing,
        mintedBy: msg.sender,
        mintedAt: uint64(now)
      });
      uint256 tokenId = cryptoArticles.push(cryptoArticle) - 1;
      super._mint(msg.sender, tokenId);

      Mint(msg.sender, tokenId);
      return tokenId;
  }

  function burn(uint256 _tokenId) public {
    super._burn(ownerOf(_tokenId), _tokenId);
    if (cryptoArticles.length != 0) {
      delete cryptoArticles[_tokenId];
    }
  }

  function getArticle(uint256 _tokenId) external view returns (string title, string content, bool publishing, address mintedBy, uint64 mintedAt) {
    CryptoArticle memory cryptoArticle = cryptoArticles[_tokenId];

    title = cryptoArticle.title;
    content = cryptoArticle.content;
    publishing = cryptoArticle.publishing;
    mintedBy = cryptoArticle.mintedBy;
    mintedAt = cryptoArticle.mintedAt;
  }

  function getAllArticlesOfOwner(address _owner) external view returns (uint256[]) {
    return ownedTokens[_owner];
  }

  function getAllArticles() external view returns (uint256[]) {
    return allTokens;
  }
}
