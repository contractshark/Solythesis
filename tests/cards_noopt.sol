pragma solidity ^0.5.0;
contract Ownable {
address private _owner;
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
constructor () internal {
_owner = msg.sender;
emit OwnershipTransferred(address(0), _owner);
}

function owner () public view returns (address) {
{
return _owner;
}

}

modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }
function isOwner () public view returns (bool) {
{
return msg.sender == _owner;
}

}

function renounceOwnership () onlyOwner public {
emit OwnershipTransferred(_owner, address(0));
_owner = address(0);
}

function transferOwnership (address newOwner) onlyOwner public {
_transferOwnership(newOwner);
}

function _transferOwnership (address newOwner) internal {
require(newOwner != address(0), "Ownable: new owner is the zero address");
emit OwnershipTransferred(_owner, newOwner);
_owner = newOwner;
}

}
library Roles {
struct Role {
        mapping (address => bool) bearer;
    }
function add (Role storage role, address account) internal {
require(! has(role, account), "Roles: account already has role");
role.bearer[account] = true;
}

function remove (Role storage role, address account) internal {
require(has(role, account), "Roles: account does not have role");
role.bearer[account] = false;
}

function has (Role storage role, address account) internal view returns (bool) {
require(account != address(0), "Roles: account is the zero address");
{
return role.bearer[account];
}

}

}
contract MinterRole {
using Roles for Roles.Role;
event MinterAdded(address indexed account);
event MinterRemoved(address indexed account);
Roles.Role private _minters;
constructor () internal {
_addMinter(msg.sender);
}

modifier onlyMinter() {
        require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
        _;
    }
function isMinter (address account) public view returns (bool) {
{
return _minters.has(account);
}

}

function addMinter (address account) onlyMinter public {
_addMinter(account);
}

function renounceMinter () public {
_removeMinter(msg.sender);
}

function _addMinter (address account) internal {
_minters.add(account);
emit MinterAdded(account);
}

function _removeMinter (address account) internal {
_minters.remove(account);
emit MinterRemoved(account);
}

}
interface IERC165 {
function supportsInterface (bytes4 interfaceId) external view returns (bool);
}
contract IERC721 is IERC165 {
event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
uint256[] internal _allTokens;
function balanceOf (address owner) public view returns (uint256 balance);
function ownerOf (uint256 tokenId) public view returns (address owner);
function safeTransferFrom (address from, address to, uint256 tokenId) public;
function transferFrom (address from, address to, uint256 tokenId) public;
function approve (address to, uint256 tokenId) public;
function getApproved (uint256 tokenId) public view returns (address operator);
function setApprovalForAll (address operator, bool _approved) public;
function isApprovedForAll (address owner, address operator) public view returns (bool);
function safeTransferFrom (address from, address to, uint256 tokenId, bytes memory data) public;
}
contract IERC721Enumerable is IERC721 {
function totalSupply () public view returns (uint256);
function tokenOfOwnerByIndex (address owner, uint256 index) public view returns (uint256 tokenId);
function tokenByIndex (uint256 index) public view returns (uint256);
}
contract ERC165 is IERC165 {
bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
mapping (bytes4=>bool) private _supportedInterfaces;
constructor () internal {
_registerInterface(_INTERFACE_ID_ERC165);
}

function supportsInterface (bytes4 interfaceId) external view returns (bool) {
{
return _supportedInterfaces[interfaceId];
}

}

function _registerInterface (bytes4 interfaceId) internal {
require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
_supportedInterfaces[interfaceId] = true;
}

}
contract IERC721Receiver {
function onERC721Received (address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4);
}
library SafeMath {
function add (uint256 a, uint256 b) internal pure returns (uint256) {
uint256 c = a + b;
require(c >= a, "SafeMath: addition overflow");
{
return c;
}

}

function sub (uint256 a, uint256 b) internal pure returns (uint256) {
require(b <= a, "SafeMath: subtraction overflow");
uint256 c = a - b;
{
return c;
}

}

function mul (uint256 a, uint256 b) internal pure returns (uint256) {
if (a == 0) {
{
return 0;
}

}

uint256 c = a * b;
require(c / a == b, "SafeMath: multiplication overflow");
{
return c;
}

}

function div (uint256 a, uint256 b) internal pure returns (uint256) {
require(b > 0, "SafeMath: division by zero");
uint256 c = a / b;
{
return c;
}

}

function mod (uint256 a, uint256 b) internal pure returns (uint256) {
require(b != 0, "SafeMath: modulo by zero");
{
return a % b;
}

}

}
library Address {
function isContract (address account) internal view returns (bool) {
uint256 size;
assembly {
size := extcodesize(account)
}

{
return size > 0;
}

}

}
contract ERC721 is ERC165, IERC721 {
uint256 memoryStart_0;
uint256 sum_tokenCount;
mapping (address=>uint256) sum_ownersToken;
address[] a;
using SafeMath for uint256;
using Address for address;
bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
mapping (uint256=>address) public _tokenOwner;
mapping (uint256=>address) private _tokenApprovals;
mapping (address=>uint256) internal _ownedTokensCount;
mapping (address=>mapping (address=>bool)) private _operatorApprovals;
bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
constructor () public {
_registerInterface(_INTERFACE_ID_ERC721);
}

function balanceOf (address owner) public view returns (uint256) {
require(owner != address(0));
{
return _ownedTokensCount[owner];
}

}

function ownerOf (uint256 tokenId) public view returns (address) {
address owner = _tokenOwner[tokenId];
require(owner != address(0));
{
return owner;
}

}

function approve (address to, uint256 tokenId) public {
address owner = ownerOf(tokenId);
require(to != owner);
require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
_tokenApprovals[tokenId] = to;
emit Approval(owner, to, tokenId);
}

function getApproved (uint256 tokenId) public view returns (address) {
require(_exists(tokenId));
{
return _tokenApprovals[tokenId];
}

}

function setApprovalForAll (address to, bool approved) public {
require(to != msg.sender);
_operatorApprovals[msg.sender][to] = approved;
emit ApprovalForAll(msg.sender, to, approved);
}

function isApprovedForAll (address owner, address operator) public view returns (bool) {
{
return _operatorApprovals[owner][operator];
}

}

function transferFrom (address from, address to, uint256 tokenId) public {
uint256 entry_1 = 0;
uint256 tmp_300;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_300 := mload(0x40)
mstore(0x40, add(tmp_300, 640))
sstore(memoryStart_0_slot, tmp_300)
mstore(add(tmp_300, 0), 0)
}

}

require(_isApprovedOrOwner(msg.sender, tokenId));
_transferFrom(from, to, tokenId);
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_299 = 0; index_299 < a.length; index_299 += 1) {
assert(_ownedTokensCount[a[index_299]] == sum_ownersToken[a[index_299]]);
}

a.length = 0;
}

memoryStart_0 = 0;
}

}

function fastTransferFrom (address from, address to, uint256 tokenId) public {
uint256 entry_1 = 0;
uint256 tmp_303;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_303 := mload(0x40)
mstore(0x40, add(tmp_303, 640))
sstore(memoryStart_0_slot, tmp_303)
mstore(add(tmp_303, 0), 0)
}

}

require(_isApprovedOrOwner(msg.sender, tokenId));
_fastTransferFrom(from, to, tokenId);
if (entry_1 == 1) {
{
for (uint256 index_302 = 0; index_302 < a.length; index_302 += 1) {
assert(_ownedTokensCount[a[index_302]] == sum_ownersToken[a[index_302]]);
}

a.length = 0;
}

memoryStart_0 = 0;
}

}

function safeTransferFrom (address from, address to, uint256 tokenId) public {
uint256 entry_1 = 0;
uint256 tmp_306;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_306 := mload(0x40)
mstore(0x40, add(tmp_306, 640))
sstore(memoryStart_0_slot, tmp_306)
mstore(add(tmp_306, 0), 0)
}

}

safeTransferFrom(from, to, tokenId, "");
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_305 = 0; index_305 < a.length; index_305 += 1) {
assert(_ownedTokensCount[a[index_305]] == sum_ownersToken[a[index_305]]);
}

a.length = 0;
}

memoryStart_0 = 0;
}

}

function safeTransferFrom (address from, address to, uint256 tokenId, bytes memory _data) public {
uint256 entry_1 = 0;
uint256 tmp_309;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_309 := mload(0x40)
mstore(0x40, add(tmp_309, 640))
sstore(memoryStart_0_slot, tmp_309)
mstore(add(tmp_309, 0), 0)
}

}

transferFrom(from, to, tokenId);
require(_checkOnERC721Received(from, to, tokenId, _data));
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_308 = 0; index_308 < a.length; index_308 += 1) {
assert(_ownedTokensCount[a[index_308]] == sum_ownersToken[a[index_308]]);
}

a.length = 0;
}

memoryStart_0 = 0;
}

}

function _exists (uint256 tokenId) internal view returns (bool) {
address owner = _tokenOwner[tokenId];
{
return owner != address(0);
}

}

function _isApprovedOrOwner (address spender, uint256 tokenId) internal view returns (bool) {
address owner = ownerOf(tokenId);
{
return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
}

}

function _mint (address to, uint256 tokenId) internal {
require(to != address(0));
require(! _exists(tokenId));
{
if (_tokenOwner[tokenId] == _tokenOwner[tokenId] && _tokenOwner[tokenId] != 0x0000000000000000000000000000000000000000) {
assert(sum_ownersToken[_tokenOwner[tokenId]] >= 1);
{
a.push(_tokenOwner[tokenId]);
}
sum_ownersToken[_tokenOwner[tokenId]] -= 1;
}

}
_tokenOwner[tokenId] = to;{
if (_tokenOwner[tokenId] == _tokenOwner[tokenId] && _tokenOwner[tokenId] != 0x0000000000000000000000000000000000000000) {
{
a.push(_tokenOwner[tokenId]);
}
sum_ownersToken[_tokenOwner[tokenId]] += 1;
assert(sum_ownersToken[_tokenOwner[tokenId]] >= 1);
}

}

{
if (to != 0x0000000000000000000000000000000000000000) {
assert(sum_tokenCount >= _ownedTokensCount[to]);
sum_tokenCount -= _ownedTokensCount[to];
}

}
{
a.push(to);
}
_ownedTokensCount[to] = _ownedTokensCount[to].add(1);{
if (to != 0x0000000000000000000000000000000000000000) {
sum_tokenCount += _ownedTokensCount[to];
assert(sum_tokenCount >= _ownedTokensCount[to]);
}

}

emit Transfer(address(0), to, tokenId);
}

function _fastMint (address to, uint256 tokenId) internal {
if (_tokenOwner[tokenId] == address(0)) {
{
if (_tokenOwner[tokenId] == _tokenOwner[tokenId] && _tokenOwner[tokenId] != 0x0000000000000000000000000000000000000000) {
assert(sum_ownersToken[_tokenOwner[tokenId]] >= 1);
{
a.push(_tokenOwner[tokenId]);
}
sum_ownersToken[_tokenOwner[tokenId]] -= 1;
}

}
_tokenOwner[tokenId] = to;{
if (_tokenOwner[tokenId] == _tokenOwner[tokenId] && _tokenOwner[tokenId] != 0x0000000000000000000000000000000000000000) {
{
a.push(_tokenOwner[tokenId]);
}
sum_ownersToken[_tokenOwner[tokenId]] += 1;
assert(sum_ownersToken[_tokenOwner[tokenId]] >= 1);
}

}

}

emit Transfer(address(0), to, tokenId);
}

function _burn (address owner, uint256 tokenId) internal {
require(ownerOf(tokenId) == owner);
_clearApproval(tokenId);
{
if (owner != 0x0000000000000000000000000000000000000000) {
assert(sum_tokenCount >= _ownedTokensCount[owner]);
sum_tokenCount -= _ownedTokensCount[owner];
}

}
{
a.push(owner);
}
_ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);{
if (owner != 0x0000000000000000000000000000000000000000) {
sum_tokenCount += _ownedTokensCount[owner];
assert(sum_tokenCount >= _ownedTokensCount[owner]);
}

}

{
if (_tokenOwner[tokenId] == _tokenOwner[tokenId] && _tokenOwner[tokenId] != 0x0000000000000000000000000000000000000000) {
assert(sum_ownersToken[_tokenOwner[tokenId]] >= 1);
{
a.push(_tokenOwner[tokenId]);
}
sum_ownersToken[_tokenOwner[tokenId]] -= 1;
}

}
_tokenOwner[tokenId] = address(0);{
if (_tokenOwner[tokenId] == _tokenOwner[tokenId] && _tokenOwner[tokenId] != 0x0000000000000000000000000000000000000000) {
{
a.push(_tokenOwner[tokenId]);
}
sum_ownersToken[_tokenOwner[tokenId]] += 1;
assert(sum_ownersToken[_tokenOwner[tokenId]] >= 1);
}

}

emit Transfer(owner, address(0), tokenId);
}

function _burn (uint256 tokenId) internal {
_burn(ownerOf(tokenId), tokenId);
}

function _transferFrom (address from, address to, uint256 tokenId) internal {
require(ownerOf(tokenId) == from);
require(to != address(0));
_clearApproval(tokenId);
{
if (from != 0x0000000000000000000000000000000000000000) {
assert(sum_tokenCount >= _ownedTokensCount[from]);
sum_tokenCount -= _ownedTokensCount[from];
}

}
{
a.push(from);
}
_ownedTokensCount[from] = _ownedTokensCount[from].sub(1);{
if (from != 0x0000000000000000000000000000000000000000) {
sum_tokenCount += _ownedTokensCount[from];
assert(sum_tokenCount >= _ownedTokensCount[from]);
}

}

{
if (to != 0x0000000000000000000000000000000000000000) {
assert(sum_tokenCount >= _ownedTokensCount[to]);
sum_tokenCount -= _ownedTokensCount[to];
}

}
{
a.push(to);
}
_ownedTokensCount[to] = _ownedTokensCount[to].add(1);{
if (to != 0x0000000000000000000000000000000000000000) {
sum_tokenCount += _ownedTokensCount[to];
assert(sum_tokenCount >= _ownedTokensCount[to]);
}

}

{
if (_tokenOwner[tokenId] == _tokenOwner[tokenId] && _tokenOwner[tokenId] != 0x0000000000000000000000000000000000000000) {
assert(sum_ownersToken[_tokenOwner[tokenId]] >= 1);
{
a.push(_tokenOwner[tokenId]);
}
sum_ownersToken[_tokenOwner[tokenId]] -= 1;
}

}
_tokenOwner[tokenId] = to;{
if (_tokenOwner[tokenId] == _tokenOwner[tokenId] && _tokenOwner[tokenId] != 0x0000000000000000000000000000000000000000) {
{
a.push(_tokenOwner[tokenId]);
}
sum_ownersToken[_tokenOwner[tokenId]] += 1;
assert(sum_ownersToken[_tokenOwner[tokenId]] >= 1);
}

}

emit Transfer(from, to, tokenId);
}

function _fastTransferFrom (address from, address to, uint256 tokenId) internal {
require(ownerOf(tokenId) == from);
_clearApproval(tokenId);
{
if (_tokenOwner[tokenId] == _tokenOwner[tokenId] && _tokenOwner[tokenId] != 0x0000000000000000000000000000000000000000) {
assert(sum_ownersToken[_tokenOwner[tokenId]] >= 1);
{
a.push(_tokenOwner[tokenId]);
}
sum_ownersToken[_tokenOwner[tokenId]] -= 1;
}

}
_tokenOwner[tokenId] = to;{
if (_tokenOwner[tokenId] == _tokenOwner[tokenId] && _tokenOwner[tokenId] != 0x0000000000000000000000000000000000000000) {
{
a.push(_tokenOwner[tokenId]);
}
sum_ownersToken[_tokenOwner[tokenId]] += 1;
assert(sum_ownersToken[_tokenOwner[tokenId]] >= 1);
}

}

emit Transfer(from, to, tokenId);
}

function _checkOnERC721Received (address from, address to, uint256 tokenId, bytes memory _data) internal returns (bool) {
if (! to.isContract()) {
{
return true;
}

}

bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
{
return (retval == _ERC721_RECEIVED);
}

}

function _clearApproval (uint256 tokenId) private {
if (_tokenApprovals[tokenId] != address(0)) {
_tokenApprovals[tokenId] = address(0);
}

}

}
contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
mapping (address=>uint256[]) private _ownedTokens;
mapping (uint256=>uint256) private _ownedTokensIndex;
mapping (uint256=>uint256) private _allTokensIndex;
bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
constructor () public {
_registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
}

function tokenOfOwnerByIndex (address owner, uint256 index) public view returns (uint256) {
require(index < balanceOf(owner));
{
return _ownedTokens[owner][index];
}

}

function totalSupply () public view returns (uint256) {
{
return _allTokens.length;
}

}

function tokenByIndex (uint256 index) public view returns (uint256) {
require(index < totalSupply());
{
return _allTokens[index];
}

}

function _transferFrom (address from, address to, uint256 tokenId) internal {
super._transferFrom(from, to, tokenId);
_removeTokenFromOwnerEnumeration(from, tokenId);
_addTokenToOwnerEnumeration(to, tokenId);
}

function _fastTransferFrom (address from, address to, uint256 tokenId) internal {
super._fastTransferFrom(from, to, tokenId);
_removeTokenFromOwnerEnumeration(from, tokenId);
_addTokenToOwnerEnumeration(to, tokenId);
}

function _mint (address to, uint256 tokenId) internal {
super._mint(to, tokenId);
_addTokenToOwnerEnumeration(to, tokenId);
_addTokenToAllTokensEnumeration(tokenId);
}

function _fastMint (address to, uint256 tokenId) internal {
super._fastMint(to, tokenId);
_addTokenToOwnerEnumeration(to, tokenId);
_addTokenToAllTokensEnumeration(tokenId);
}

function _burn (address owner, uint256 tokenId) internal {
super._burn(owner, tokenId);
_removeTokenFromOwnerEnumeration(owner, tokenId);
_ownedTokensIndex[tokenId] = 0;
_removeTokenFromAllTokensEnumeration(tokenId);
}

function _tokensOfOwner (address owner) internal view returns (uint256[] storage) {
{
return _ownedTokens[owner];
}

}

function _addTokenToOwnerEnumeration (address to, uint256 tokenId) private {
_ownedTokensIndex[tokenId] = _ownedTokens[to].length;
_ownedTokens[to].push(tokenId);
}

function _addTokenToAllTokensEnumeration (uint256 tokenId) private {
_allTokensIndex[tokenId] = _allTokens.length;
_allTokens.push(tokenId);
}

function _removeTokenFromOwnerEnumeration (address from, uint256 tokenId) private {
uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
uint256 tokenIndex = _ownedTokensIndex[tokenId];
if (tokenIndex != lastTokenIndex) {
uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
_ownedTokens[from][tokenIndex] = lastTokenId;
_ownedTokensIndex[lastTokenId] = tokenIndex;
}

_ownedTokens[from].length --;
}

function _removeTokenFromAllTokensEnumeration (uint256 tokenId) private {
uint256 lastTokenIndex = _allTokens.length.sub(1);
uint256 tokenIndex = _allTokensIndex[tokenId];
uint256 lastTokenId = _allTokens[lastTokenIndex];
_allTokens[tokenIndex] = lastTokenId;
_allTokensIndex[lastTokenId] = tokenIndex;
_allTokens.length --;
_allTokensIndex[tokenId] = 0;
}

}
contract OwnableDelegateProxy {
}
contract ProxyRegistry {
mapping (address=>OwnableDelegateProxy) public proxies;
}
contract CryptoCardsERC721Batched is ERC721Enumerable {
string internal _tokenName;
string internal _tokenSymbol;
string internal _baseTokenURI;
address internal _proxyRegistryAddress;
bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
event BatchTransfer(address from, address to, uint256[] tokenIds);
constructor (string memory name, string memory symbol, string memory uri) public {
_registerInterface(_INTERFACE_ID_ERC721_METADATA);
_tokenName = name;
_tokenSymbol = symbol;
_baseTokenURI = uri;
}

function getVersion () public pure returns (string memory) {
{
return "v2.2.1";
}

}

function name () external view returns (string memory) {
{
return _tokenName;
}

}

function symbol () external view returns (string memory) {
{
return _tokenSymbol;
}

}

function tokenURI (uint256 tokenId) public view returns (string memory) {
require(_exists(tokenId), "Token doesn't exist");
{
return string(abi.encodePacked(
                _baseTokenURI,
                uint2str(tokenId),
                ".json"
            ));
}

}

function exists (uint256 tokenId) public view returns (bool) {
{
return _exists(tokenId);
}

}

function batchTransferFrom (address from, address to, uint256[] memory tokenIds) public {
uint256 entry_1 = 0;
uint256 tmp_317;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_317 := mload(0x40)
mstore(0x40, add(tmp_317, 640))
sstore(memoryStart_0_slot, tmp_317)
mstore(add(tmp_317, 0), 0)
}

}

require(to != address(0));
for (uint256 i = 0; i < tokenIds.length; i ++) {
_fastTransferFrom(from, to, tokenIds[i]);
}

{
if (from != 0x0000000000000000000000000000000000000000) {
assert(sum_tokenCount >= _ownedTokensCount[from]);
sum_tokenCount -= _ownedTokensCount[from];
}

}
{
a.push(from);
}
_ownedTokensCount[from] = _ownedTokensCount[from].sub(tokenIds.length);{
if (from != 0x0000000000000000000000000000000000000000) {
sum_tokenCount += _ownedTokensCount[from];
assert(sum_tokenCount >= _ownedTokensCount[from]);
}

}

{
if (to != 0x0000000000000000000000000000000000000000) {
assert(sum_tokenCount >= _ownedTokensCount[to]);
sum_tokenCount -= _ownedTokensCount[to];
}

}
{
a.push(to);
}
_ownedTokensCount[to] = _ownedTokensCount[to].add(tokenIds.length);{
if (to != 0x0000000000000000000000000000000000000000) {
sum_tokenCount += _ownedTokensCount[to];
assert(sum_tokenCount >= _ownedTokensCount[to]);
}

}

if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_316 = 0; index_316 < a.length; index_316 += 1) {
assert(_ownedTokensCount[a[index_316]] == sum_ownersToken[a[index_316]]);
}

a.length = 0;
}

memoryStart_0 = 0;
}

}

function isApprovedForAll (address owner, address operator) public view returns (bool) {
ProxyRegistry proxyRegistry = ProxyRegistry(_proxyRegistryAddress);
if (address(proxyRegistry.proxies(owner)) == operator) {
{
return true;
}

}

{
return super.isApprovedForAll(owner, operator);
}

}

function _setProxyRegistryAddress (address proxy) internal {
_proxyRegistryAddress = proxy;
}

function _mintBatch (address to, uint256[] memory tokenIds) internal {
require(to != address(0));
for (uint256 i = 0; i < tokenIds.length; i ++) {
_fastMint(to, tokenIds[i]);
}

{
if (to != 0x0000000000000000000000000000000000000000) {
assert(sum_tokenCount >= _ownedTokensCount[to]);
sum_tokenCount -= _ownedTokensCount[to];
}

}
{
a.push(to);
}
_ownedTokensCount[to] = _ownedTokensCount[to].add(tokenIds.length);{
if (to != 0x0000000000000000000000000000000000000000) {
sum_tokenCount += _ownedTokensCount[to];
assert(sum_tokenCount >= _ownedTokensCount[to]);
}

}

}

function uint2str (uint _i) private pure returns (string memory _uintAsString) {
if (_i == 0) {
{
return "0";
}

}

uint j = _i;
uint len;
while (j != 0) {
            len++;
            j /= 10;
        }
bytes memory bstr = new bytes(len);
uint k = len - 1;
while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
{
return string(bstr);
}

}

}
contract CryptoCardsCardToken is CryptoCardsERC721Batched, MinterRole, Ownable {
uint internal constant ETH_DIV = 1000000;
uint internal constant ETH_MAX = 4194304;
mapping (uint=>bool) internal _printedTokens;
uint internal _wrappedEtherDemand;
event CardsCombined(address indexed owner, uint tokenA, uint tokenB, uint newTokenId, bytes16 uuid);
event CardPrinted(address indexed owner, uint tokenId, uint wrappedEther, bytes16 uuid);
event CardMelted(address indexed owner, uint tokenId, uint wrappedEther, uint wrappedGum, bytes16 uuid);
event WrappedEtherDeposit(uint amount);
constructor () CryptoCardsERC721Batched("Crypto-Cards - Cards", "CARDS", "https://crypto-cards.io/card-info/") public {
}

function getYear (uint tokenId) public pure returns (uint64) {
{
return _readBits(tokenId, 0, 4);
}

}

function getGeneration (uint tokenId) public pure returns (uint64) {
{
return _readBits(tokenId, 4, 6);
}

}

function getRank (uint tokenId) public pure returns (uint64) {
{
return _readBits(tokenId, 10, 10);
}

}

function getIssue (uint tokenId) public pure returns (uint64) {
{
return _readBits(tokenId, 20, 12);
}

}

function getTypeIndicators (uint tokenId) public pure returns (uint64, uint64, uint64) {
uint64 y = getYear(tokenId);
uint64 g = getGeneration(tokenId);
uint64 r = getRank(tokenId);
{
return (y, g, r);
}

}

function getWrappedGum (uint tokenId) public pure returns (uint64) {
{
return _readBits(tokenId, 32, 10);
}

}

function getWrappedEther (uint tokenId) public pure returns (uint) {
{
return _convertToEther(_getWrappedEtherRaw(tokenId));
}

}

function isTokenPrinted (uint tokenId) public view returns (bool) {
{
return _printedTokens[tokenId];
}

}

function canCombine (uint tokenA, uint tokenB) public view returns (bool) {
if (isTokenPrinted(tokenA) || isTokenPrinted(tokenB)) {
{
return false;
}

}

if (getGeneration(tokenA) < 1) {
{
return false;
}

}

uint32 typeA = uint32(_readBits(tokenA, 0, 20));
uint32 typeB = uint32(_readBits(tokenB, 0, 20));
{
return (typeA == typeB);
}

}

function mint (address to, uint tokenId) public {
uint256 entry_1 = 0;
uint256 tmp_321;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_321 := mload(0x40)
mstore(0x40, add(tmp_321, 640))
sstore(memoryStart_0_slot, tmp_321)
mstore(add(tmp_321, 0), 0)
}

}

_mint(to, tokenId);
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_320 = 0; index_320 < a.length; index_320 += 1) {
assert(_ownedTokensCount[a[index_320]] == sum_ownersToken[a[index_320]]);
}

a.length = 0;
}

memoryStart_0 = 0;
}

}

function mintCardsFromPack (address to, uint[] memory tokenIds) onlyMinter public {
uint256 entry_1 = 0;
uint256 tmp_324;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_324 := mload(0x40)
mstore(0x40, add(tmp_324, 640))
sstore(memoryStart_0_slot, tmp_324)
mstore(add(tmp_324, 0), 0)
}

}

_mintBatch(to, tokenIds);
uint totalWrappedEth;
for (uint i = 0; i < tokenIds.length; i ++) {
totalWrappedEth = totalWrappedEth + getWrappedEther(tokenIds[i]);
}

if (totalWrappedEth > 0) {
_wrappedEtherDemand = _wrappedEtherDemand + totalWrappedEth;
}

if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_323 = 0; index_323 < a.length; index_323 += 1) {
assert(_ownedTokensCount[a[index_323]] == sum_ownersToken[a[index_323]]);
}

a.length = 0;
}

memoryStart_0 = 0;
}

}

function migrateCards (address to, uint[] memory tokenIds) onlyMinter public {
uint256 entry_1 = 0;
uint256 tmp_327;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_327 := mload(0x40)
mstore(0x40, add(tmp_327, 640))
sstore(memoryStart_0_slot, tmp_327)
mstore(add(tmp_327, 0), 0)
}

}

_mintBatch(to, tokenIds);
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_326 = 0; index_326 < a.length; index_326 += 1) {
assert(_ownedTokensCount[a[index_326]] == sum_ownersToken[a[index_326]]);
}

a.length = 0;
}

memoryStart_0 = 0;
}

}

function printFor (address owner, uint tokenId, bytes16 uuid) onlyMinter public {
require(owner == ownerOf(tokenId), "User does not own this Card");
_printToken(owner, tokenId, uuid);
}

function combineFor (address owner, uint tokenA, uint tokenB, uint newIssue, bytes16 uuid) onlyMinter public returns (uint) {
uint256 entry_1 = 0;
uint256 tmp_331;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_331 := mload(0x40)
mstore(0x40, add(tmp_331, 640))
sstore(memoryStart_0_slot, tmp_331)
mstore(add(tmp_331, 0), 0)
}

}

require(owner == ownerOf(tokenA), "User does not own this Card");
{
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_329 = 0; index_329 < a.length; index_329 += 1) {
assert(_ownedTokensCount[a[index_329]] == sum_ownersToken[a[index_329]]);
}

a.length = 0;
}

memoryStart_0 = 0;
}

return _combineTokens(tokenA, tokenB, newIssue, uuid);
}

if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_330 = 0; index_330 < a.length; index_330 += 1) {
assert(_ownedTokensCount[a[index_330]] == sum_ownersToken[a[index_330]]);
}

a.length = 0;
}

memoryStart_0 = 0;
}

}

function meltFor (address owner, uint tokenId, bytes16 uuid) onlyMinter public returns (uint) {
require(owner == ownerOf(tokenId), "User does not own this Card");
{
return _meltToken(tokenId, uuid);
}

}

function tokenTransfer (address from, address to, uint tokenId) onlyMinter public {
uint256 entry_1 = 0;
uint256 tmp_334;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_334 := mload(0x40)
mstore(0x40, add(tmp_334, 640))
sstore(memoryStart_0_slot, tmp_334)
mstore(add(tmp_334, 0), 0)
}

}

_transferFrom(from, to, tokenId);
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_333 = 0; index_333 < a.length; index_333 += 1) {
assert(_ownedTokensCount[a[index_333]] == sum_ownersToken[a[index_333]]);
}

a.length = 0;
}

memoryStart_0 = 0;
}

}

function setBaseTokenURI (string memory uri) onlyOwner public {
_baseTokenURI = uri;
}

function setProxyRegistryAddress (address proxy) onlyOwner public {
_setProxyRegistryAddress(proxy);
}

function depositWrappedEther (uint amount) onlyOwner public payable {
require(amount == msg.value, "Specified amount does not match actual amount received");
emit WrappedEtherDeposit(amount);
}

function getWrappedEtherDemand () onlyOwner public view returns (uint) {
{
return _wrappedEtherDemand;
}

}

function _combineTokens (uint tokenA, uint tokenB, uint newIssue, bytes16 uuid) private returns (uint) {
address owner = ownerOf(tokenA);
require(owner == ownerOf(tokenB), "User does not own both Cards");
require(canCombine(tokenA, tokenB), "Cards are not compatible");
uint newTokenId = _generateCombinedToken(tokenA, tokenB, newIssue);
_mint(owner, newTokenId);
_burn(owner, tokenA);
_burn(owner, tokenB);
emit CardsCombined(owner, tokenA, tokenB, newTokenId, uuid);
{
return newTokenId;
}

}

function _printToken (address owner, uint tokenId, bytes16 uuid) private {
require(! isTokenPrinted(tokenId), "Card has already been printed");
uint wrappedEth = getWrappedEther(tokenId);
_printedTokens[tokenId] = true;
_payoutEther(owner, wrappedEth);
emit CardPrinted(owner, tokenId, wrappedEth, uuid);
}

function _meltToken (uint tokenId, bytes16 uuid) private returns (uint) {
require(! isTokenPrinted(tokenId), "Cannot melt printed Cards");
address owner = ownerOf(tokenId);
uint wrappedGum = getWrappedGum(tokenId);
uint wrappedEth = getWrappedEther(tokenId);
_burn(owner, tokenId);
_payoutEther(owner, wrappedEth);
emit CardMelted(owner, tokenId, wrappedEth, wrappedGum, uuid);
{
return wrappedGum;
}

}

function _payoutEther (address owner, uint256 ethAmount) private returns (uint) {
address ownerWallet = address(uint160(owner));
require(ethAmount <= address(this).balance, "Not enough funds to pay out wrapped ether, please try again later.");
_wrappedEtherDemand = _wrappedEtherDemand - ethAmount;
{
return ethAmount;
}

}

function _generateCombinedToken (uint tokenA, uint tokenB, uint newIssue) private returns (uint) {
uint64 y = getYear(tokenA);
uint64 g = getGeneration(tokenA) - 1;
uint64 r = getRank(tokenA);
uint64 eth = _getCombinedEtherRaw(tokenA, tokenB);
uint64[6] memory bits = [
            y, g, r, uint64(newIssue),
            getWrappedGum(tokenA) + getWrappedGum(tokenB),
            eth
        ];
{
return _generateTokenId(bits);
}

}

function _getCombinedEtherRaw (uint tokenA, uint tokenB) private returns (uint64) {
uint64 eA = _getWrappedEtherRaw(tokenA);
uint64 eB = _getWrappedEtherRaw(tokenB);
uint combined = uint(eA + eB);
if (combined > ETH_MAX) {
uint overage = _convertToEther(combined - ETH_MAX);
_payoutEther(ownerOf(tokenA), overage);
combined = ETH_MAX;
}

{
return uint64(combined);
}

}

function _getWrappedEtherRaw (uint tokenId) private pure returns (uint64) {
{
return _readBits(tokenId, 42, 22);
}

}

function _convertToEther (uint rawValue) private pure returns (uint) {
{
return rawValue * (1 ether) / ETH_DIV;
}

}

function _generateTokenId (uint64[6] memory bits) private pure returns (uint) {
{
return uint(bits[0] | (bits[1] << 4) | (bits[2] << 10) | (bits[3] << 20) | (bits[4] << 32) | (bits[5] << 42));
}

}

function _readBits (uint num, uint from, uint len) private pure returns (uint64) {
uint mask = ((1 << len) - 1) << from;
{
return uint64((num & mask) >> from);
}

}

function transfer (address _to, uint256 _tokenId) public {
uint256 entry_1 = 0;
uint256 tmp_337;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_337 := mload(0x40)
mstore(0x40, add(tmp_337, 640))
sstore(memoryStart_0_slot, tmp_337)
mstore(add(tmp_337, 0), 0)
}

}

safeTransferFrom(msg.sender, _to, _tokenId);
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_336 = 0; index_336 < a.length; index_336 += 1) {
assert(_ownedTokensCount[a[index_336]] == sum_ownersToken[a[index_336]]);
}

a.length = 0;
}

memoryStart_0 = 0;
}

}

}
