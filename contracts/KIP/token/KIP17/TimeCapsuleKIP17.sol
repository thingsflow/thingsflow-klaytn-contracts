pragma solidity ^0.8.0;

import "./extensions/KIP17Burnable.sol";
import "./extensions/KIP17Enumerable.sol";
import "./extensions/KIP17MetadataMintable.sol";
import "./extensions/KIP17Pausable.sol";

contract TimeCapsuleKIP17Token is KIP17Burnable, KIP17MetadataMintable, KIP17Enumerable, KIP17Pausable {
    mapping(uint256 => string) private _tokenRevealedURIs;
    mapping(uint256 => uint256) private _tokenRevealableAts;

    constructor(string memory name, string memory symbol) KIP17(name, symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
    }

    function _setTokenRevealedURI(uint256 tokenId, string memory revealedURI) internal {
        require(_exists(tokenId), "KIP17Metadata: Revealed URI set of nonexistent token");
        _tokenRevealedURIs[tokenId] = revealedURI;
    }

    function _setTokenRevealableAt(uint256 tokenId, uint256 revealableAt) internal {
        require(_exists(tokenId), "KIP17Metadata: Reveal Date set of nonexistent token");
        _tokenRevealableAts[tokenId] = revealableAt;
    }

    function mintWithTokenURIAndRevealInfo(
        address to,
        uint256 tokenId,
        string memory _tokenURI,
        string memory revealedURI,
        uint256 revealableAt
    ) public virtual onlyRole(MINTER_ROLE) returns (bool) {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        _setTokenRevealedURI(tokenId, revealedURI);
        _setTokenRevealableAt(tokenId, revealableAt);
        return true;
    }

    function tokenURI(uint256 tokenId) public view override(KIP17URIStorage, KIP17) returns (string memory) {
        require(_exists(tokenId), "KIP17Metadata: URI query for nonexistent token");

        if (_tokenRevealableAts[tokenId] > 0) {
            return KIP17URIStorage.tokenURI(tokenId);
        } else {
            return _tokenRevealedURIs[tokenId];
        }
    }

    function reveal(uint256 tokenId) public returns (string memory) {
        require(_isApprovedOrOwner(msg.sender, tokenId), "KIP17Reveal: caller is not owner nor approved");
        require(_tokenRevealableAts[tokenId] < block.timestamp * 1000, "KIP17Reveal: cannot reveal yet");

        _setTokenRevealableAt(tokenId, 0);

        return _tokenRevealedURIs[tokenId];
    }

    function _burn(uint256 tokenId) internal virtual override(KIP17URIStorage, KIP17) {
        KIP17URIStorage._burn(tokenId);

        if (bytes(_tokenRevealedURIs[tokenId]).length != 0) {
            delete _tokenRevealedURIs[tokenId];
        }

        if (_tokenRevealableAts[tokenId] != 0) {
            delete _tokenRevealableAts[tokenId];
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(KIP17Enumerable, KIP17Pausable, KIP17) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(KIP17Burnable, KIP17Enumerable, KIP17MetadataMintable, KIP17Pausable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
