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
        require(isOwner());
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
require(newOwner != address(0));
emit OwnershipTransferred(_owner, newOwner);
_owner = newOwner;
}

}
pragma solidity ^0.5.0;
library Roles {
struct Role {
        mapping (address => bool) bearer;
    }
function add (Role storage role, address account) internal {
require(account != address(0));
require(! has(role, account));
role.bearer[account] = true;
}

function remove (Role storage role, address account) internal {
require(account != address(0));
require(has(role, account));
role.bearer[account] = false;
}

function has (Role storage role, address account) internal view returns (bool) {
require(account != address(0));
{
return role.bearer[account];
}

}

}
pragma solidity ^0.5.0;
contract WhitelistAdminRole {
using Roles for Roles.Role;
event WhitelistAdminAdded(address indexed account);
event WhitelistAdminRemoved(address indexed account);
Roles.Role private _whitelistAdmins;
constructor () internal {
_addWhitelistAdmin(msg.sender);
}

modifier onlyWhitelistAdmin() {
        require(isWhitelistAdmin(msg.sender));
        _;
    }
function isWhitelistAdmin (address account) public view returns (bool) {
{
return _whitelistAdmins.has(account);
}

}

function addWhitelistAdmin (address account) onlyWhitelistAdmin public {
_addWhitelistAdmin(account);
}

function renounceWhitelistAdmin () public {
_removeWhitelistAdmin(msg.sender);
}

function _addWhitelistAdmin (address account) internal {
_whitelistAdmins.add(account);
emit WhitelistAdminAdded(account);
}

function _removeWhitelistAdmin (address account) internal {
_whitelistAdmins.remove(account);
emit WhitelistAdminRemoved(account);
}

}
pragma solidity ^0.5.0;
contract WhitelistedRole is WhitelistAdminRole {
using Roles for Roles.Role;
event WhitelistedAdded(address indexed account);
event WhitelistedRemoved(address indexed account);
Roles.Role private _whitelisteds;
modifier onlyWhitelisted() {
        require(isWhitelisted(msg.sender));
        _;
    }
function isWhitelisted (address account) public view returns (bool) {
{
return _whitelisteds.has(account);
}

}

function addWhitelisted (address account) onlyWhitelistAdmin public {
_addWhitelisted(account);
}

function removeWhitelisted (address account) onlyWhitelistAdmin public {
_removeWhitelisted(account);
}

function renounceWhitelisted () public {
_removeWhitelisted(msg.sender);
}

function _addWhitelisted (address account) internal {
_whitelisteds.add(account);
emit WhitelistedAdded(account);
}

function _removeWhitelisted (address account) internal {
_whitelisteds.remove(account);
emit WhitelistedRemoved(account);
}

}
pragma solidity ^0.5.0;
library Strings {
function strConcat (string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
bytes memory _ba = bytes(_a);
bytes memory _bb = bytes(_b);
bytes memory _bc = bytes(_c);
bytes memory _bd = bytes(_d);
bytes memory _be = bytes(_e);
string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
bytes memory babcde = bytes(abcde);
uint k = 0;
uint i = 0;
for (i = 0; i < _ba.length; i ++) {
babcde[k ++] = _ba[i];
}

for (i = 0; i < _bb.length; i ++) {
babcde[k ++] = _bb[i];
}

for (i = 0; i < _bc.length; i ++) {
babcde[k ++] = _bc[i];
}

for (i = 0; i < _bd.length; i ++) {
babcde[k ++] = _bd[i];
}

for (i = 0; i < _be.length; i ++) {
babcde[k ++] = _be[i];
}

{
return string(babcde);
}

}

function strConcat (string memory _a, string memory _b) internal pure returns (string memory) {
{
return strConcat(_a, _b, "", "", "");
}

}

function strConcat (string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
{
return strConcat(_a, _b, _c, "", "");
}

}

function uint2str (uint _i) internal pure returns (string memory _uintAsString) {
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
pragma solidity ^0.5.0;
interface IBlockCitiesCreator {
function createBuilding (
        uint256 _exteriorColorway,
        uint256 _backgroundColorway,
        uint256 _city,
        uint256 _building,
        uint256 _base,
        uint256 _body,
        uint256 _roof,
        uint256 _special,
        address _architect
    ) external returns (uint256 _tokenId);
}
pragma solidity ^0.5.0;
interface IERC165 {
function supportsInterface (bytes4 interfaceId) external view returns (bool);
}
pragma solidity ^0.5.0;
contract IERC721 is IERC165 {
event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
uint256[] internal _allTokens;
function balanceOf (address owner) public view returns (uint256 balance);
function ownerOf (uint256 tokenId) public view returns (address owner);
function approve (address to, uint256 tokenId) public;
function getApproved (uint256 tokenId) public view returns (address operator);
function setApprovalForAll (address operator, bool _approved) public;
function isApprovedForAll (address owner, address operator) public view returns (bool);
function transferFrom (address from, address to, uint256 tokenId) public;
function safeTransferFrom (address from, address to, uint256 tokenId) public;
function safeTransferFrom (address from, address to, uint256 tokenId, bytes memory data) public;
}
pragma solidity ^0.5.0;
contract IERC721Receiver {
function onERC721Received (address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4);
}
pragma solidity ^0.5.0;
library SafeMath {
function mul (uint256 a, uint256 b) internal pure returns (uint256) {
if (a == 0) {
{
return 0;
}

}

uint256 c = a * b;
require(c / a == b);
{
return c;
}

}

function div (uint256 a, uint256 b) internal pure returns (uint256) {
require(b > 0);
uint256 c = a / b;
{
return c;
}

}

function sub (uint256 a, uint256 b) internal pure returns (uint256) {
require(b <= a);
uint256 c = a - b;
{
return c;
}

}

function add (uint256 a, uint256 b) internal pure returns (uint256) {
uint256 c = a + b;
require(c >= a);
{
return c;
}

}

function mod (uint256 a, uint256 b) internal pure returns (uint256) {
require(b != 0);
{
return a % b;
}

}

}
pragma solidity ^0.5.0;
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
pragma solidity ^0.5.0;
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
require(interfaceId != 0xffffffff);
_supportedInterfaces[interfaceId] = true;
}

}
pragma solidity ^0.5.0;
contract ERC721 is ERC165, IERC721 {
uint256 memoryStart_0;
uint256 sum_tokenCount;
mapping (address=>uint256) sum_ownersToken;
uint256 a_addr_96;
using SafeMath for uint256;
using Address for address;
bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
mapping (uint256=>address) internal _tokenOwner;
mapping (uint256=>address) internal _tokenApprovals;
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
uint256 tmp_100;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_100 := mload(0x40)
mstore(0x40, add(tmp_100, 640))
sstore(memoryStart_0_slot, tmp_100)
mstore(add(tmp_100, 0), 0)
}

}

address[] memory a_97;
assembly {
a_97 := add(sload(memoryStart_0_slot), 0)
}

require(_isApprovedOrOwner(msg.sender, tokenId));
_transferFrom(from, to, tokenId);
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
for (uint256 index_98 = 0; index_98 < a_97.length; index_98 += 1) {
address tmp_99;
assembly {
tmp_99 := mload(add(a_97, mul(add(index_98, 1), 32)))
}

assert(_ownedTokensCount[tmp_99] == sum_ownersToken[tmp_99]);
}

memoryStart_0 = 0;
}

}

function safeTransferFrom (address from, address to, uint256 tokenId) public {
uint256 entry_1 = 0;
uint256 tmp_104;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_104 := mload(0x40)
mstore(0x40, add(tmp_104, 640))
sstore(memoryStart_0_slot, tmp_104)
mstore(add(tmp_104, 0), 0)
}

}

address[] memory a_101;
assembly {
a_101 := add(sload(memoryStart_0_slot), 0)
}

safeTransferFrom(from, to, tokenId, "");
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
for (uint256 index_102 = 0; index_102 < a_101.length; index_102 += 1) {
address tmp_103;
assembly {
tmp_103 := mload(add(a_101, mul(add(index_102, 1), 32)))
}

assert(_ownedTokensCount[tmp_103] == sum_ownersToken[tmp_103]);
}

memoryStart_0 = 0;
}

}

function safeTransferFrom (address from, address to, uint256 tokenId, bytes memory _data) public {
uint256 entry_1 = 0;
uint256 tmp_108;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_108 := mload(0x40)
mstore(0x40, add(tmp_108, 640))
sstore(memoryStart_0_slot, tmp_108)
mstore(add(tmp_108, 0), 0)
}

}

address[] memory a_105;
assembly {
a_105 := add(sload(memoryStart_0_slot), 0)
}

transferFrom(from, to, tokenId);
require(_checkOnERC721Received(from, to, tokenId, _data));
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
for (uint256 index_106 = 0; index_106 < a_105.length; index_106 += 1) {
address tmp_107;
assembly {
tmp_107 := mload(add(a_105, mul(add(index_106, 1), 32)))
}

assert(_ownedTokensCount[tmp_107] == sum_ownersToken[tmp_107]);
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
address[] memory a_110;
assembly {
a_110 := add(sload(memoryStart_0_slot), 0)
}

require(to != address(0));
require(! _exists(tokenId));
{
address opt_109 = _tokenOwner[tokenId];
{
if (opt_109 == opt_109 && opt_109 != 0x0000000000000000000000000000000000000000) {
assert(sum_ownersToken[opt_109] >= 1);
{
address tmp_111 = opt_109;
assembly {
let tmp := add(mload(a_110), 1)
mstore(a_110, tmp)
mstore(add(a_110, mul(tmp, 32)), tmp_111)
}

}
sum_ownersToken[opt_109] -= 1;
}

}

opt_109 = to;
{
if (opt_109 == opt_109 && opt_109 != 0x0000000000000000000000000000000000000000) {
{
address tmp_112 = opt_109;
assembly {
let tmp := add(mload(a_110), 1)
mstore(a_110, tmp)
mstore(add(a_110, mul(tmp, 32)), tmp_112)
}

}
sum_ownersToken[opt_109] += 1;
assert(sum_ownersToken[opt_109] >= 1);
}

}

_tokenOwner[tokenId] = opt_109;
}

{
uint256 opt_114 = _ownedTokensCount[to];
{
if (to != 0x0000000000000000000000000000000000000000) {
assert(sum_tokenCount >= opt_114);
sum_tokenCount -= opt_114;
}

}

{
address tmp_113 = to;
assembly {
let tmp := add(mload(a_110), 1)
mstore(a_110, tmp)
mstore(add(a_110, mul(tmp, 32)), tmp_113)
}

}

opt_114 = opt_114.add(1);
{
if (to != 0x0000000000000000000000000000000000000000) {
sum_tokenCount += opt_114;
assert(sum_tokenCount >= opt_114);
}

}

_ownedTokensCount[to] = opt_114;
}

emit Transfer(address(0), to, tokenId);
}

function _burn (address owner, uint256 tokenId) internal {
address[] memory a_116;
assembly {
a_116 := add(sload(memoryStart_0_slot), 0)
}

require(ownerOf(tokenId) == owner);
_clearApproval(tokenId);
{
uint256 opt_118 = _ownedTokensCount[owner];
{
if (owner != 0x0000000000000000000000000000000000000000) {
assert(sum_tokenCount >= opt_118);
sum_tokenCount -= opt_118;
}

}

{
address tmp_117 = owner;
assembly {
let tmp := add(mload(a_116), 1)
mstore(a_116, tmp)
mstore(add(a_116, mul(tmp, 32)), tmp_117)
}

}

opt_118 = opt_118.sub(1);
{
if (owner != 0x0000000000000000000000000000000000000000) {
sum_tokenCount += opt_118;
assert(sum_tokenCount >= opt_118);
}

}

_ownedTokensCount[owner] = opt_118;
}

{
address opt_120 = _tokenOwner[tokenId];
{
if (opt_120 == opt_120 && opt_120 != 0x0000000000000000000000000000000000000000) {
assert(sum_ownersToken[opt_120] >= 1);
{
address tmp_121 = opt_120;
assembly {
let tmp := add(mload(a_116), 1)
mstore(a_116, tmp)
mstore(add(a_116, mul(tmp, 32)), tmp_121)
}

}
sum_ownersToken[opt_120] -= 1;
}

}

opt_120 = address(0);
{
if (opt_120 == opt_120 && opt_120 != 0x0000000000000000000000000000000000000000) {
{
address tmp_122 = opt_120;
assembly {
let tmp := add(mload(a_116), 1)
mstore(a_116, tmp)
mstore(add(a_116, mul(tmp, 32)), tmp_122)
}

}
sum_ownersToken[opt_120] += 1;
assert(sum_ownersToken[opt_120] >= 1);
}

}

_tokenOwner[tokenId] = opt_120;
}

emit Transfer(owner, address(0), tokenId);
}

function _burn (uint256 tokenId) internal {
_burn(ownerOf(tokenId), tokenId);
}

function _transferFrom (address from, address to, uint256 tokenId) internal {
address[] memory a_123;
assembly {
a_123 := add(sload(memoryStart_0_slot), 0)
}

require(ownerOf(tokenId) == from);
require(to != address(0));
_clearApproval(tokenId);
{
uint256 opt_125 = _ownedTokensCount[from];
{
if (from != 0x0000000000000000000000000000000000000000) {
assert(sum_tokenCount >= opt_125);
sum_tokenCount -= opt_125;
}

}

{
address tmp_124 = from;
assembly {
let tmp := add(mload(a_123), 1)
mstore(a_123, tmp)
mstore(add(a_123, mul(tmp, 32)), tmp_124)
}

}

opt_125 = opt_125.sub(1);
{
if (from != 0x0000000000000000000000000000000000000000) {
sum_tokenCount += opt_125;
assert(sum_tokenCount >= opt_125);
}

}

_ownedTokensCount[from] = opt_125;
}

{
uint256 opt_128 = _ownedTokensCount[to];
{
if (to != 0x0000000000000000000000000000000000000000) {
assert(sum_tokenCount >= opt_128);
sum_tokenCount -= opt_128;
}

}

{
address tmp_127 = to;
assembly {
let tmp := add(mload(a_123), 1)
mstore(a_123, tmp)
mstore(add(a_123, mul(tmp, 32)), tmp_127)
}

}

opt_128 = opt_128.add(1);
{
if (to != 0x0000000000000000000000000000000000000000) {
sum_tokenCount += opt_128;
assert(sum_tokenCount >= opt_128);
}

}

_ownedTokensCount[to] = opt_128;
}

{
address opt_130 = _tokenOwner[tokenId];
{
if (opt_130 == opt_130 && opt_130 != 0x0000000000000000000000000000000000000000) {
assert(sum_ownersToken[opt_130] >= 1);
{
address tmp_131 = opt_130;
assembly {
let tmp := add(mload(a_123), 1)
mstore(a_123, tmp)
mstore(add(a_123, mul(tmp, 32)), tmp_131)
}

}
sum_ownersToken[opt_130] -= 1;
}

}

opt_130 = to;
{
if (opt_130 == opt_130 && opt_130 != 0x0000000000000000000000000000000000000000) {
{
address tmp_132 = opt_130;
assembly {
let tmp := add(mload(a_123), 1)
mstore(a_123, tmp)
mstore(add(a_123, mul(tmp, 32)), tmp_132)
}

}
sum_ownersToken[opt_130] += 1;
assert(sum_ownersToken[opt_130] >= 1);
}

}

_tokenOwner[tokenId] = opt_130;
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
pragma solidity ^0.5.0;
contract IERC721Enumerable is IERC721 {
function totalSupply () public view returns (uint256);
function tokenOfOwnerByIndex (address owner, uint256 index) public view returns (uint256 tokenId);
function tokenByIndex (uint256 index) public view returns (uint256);
}
pragma solidity ^0.5.0;
contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
mapping (address=>uint256[]) internal _ownedTokens;
mapping (uint256=>uint256) internal _ownedTokensIndex;
mapping (uint256=>uint256) internal _allTokensIndex;
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

function _mint (address to, uint256 tokenId) internal {
super._mint(to, tokenId);
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
pragma solidity ^0.5.0;
contract IERC721Metadata is IERC721 {
function name () external view returns (string memory);
function symbol () external view returns (string memory);
function tokenURI (uint256 tokenId) external view returns (string memory);
}
pragma solidity ^0.5.0;
contract ERC721MetadataWithoutTokenUri is ERC165, ERC721, IERC721Metadata {
string private _name;
string private _symbol;
bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
constructor (string memory name, string memory symbol) public {
_name = name;
_symbol = symbol;
_registerInterface(_INTERFACE_ID_ERC721_METADATA);
}

function name () external view returns (string memory) {
{
return _name;
}

}

function symbol () external view returns (string memory) {
{
return _symbol;
}

}

function _burn (address owner, uint256 tokenId) internal {
super._burn(owner, tokenId);
}

}
pragma solidity ^0.5.0;
contract CustomERC721Full is ERC721, ERC721Enumerable, ERC721MetadataWithoutTokenUri {
constructor (string memory name, string memory symbol) ERC721MetadataWithoutTokenUri(name, symbol) public {
}

}
pragma solidity ^0.5.0;
contract BlockCities is CustomERC721Full, WhitelistedRole, IBlockCitiesCreator {
using SafeMath for uint256;
string public tokenBaseURI = "";
event BuildingMinted(
        uint256 indexed _tokenId,
        address indexed _to,
        address indexed _architect
    );
uint256 public totalBuildings = 0;
uint256 public tokenIdPointer = 0;
struct Building {
        uint256 exteriorColorway;
        uint256 backgroundColorway;
        uint256 city;
        uint256 building;
        uint256 base;
        uint256 body;
        uint256 roof;
        uint256 special;
        address architect;
    }
mapping (uint256=>Building) internal buildings;
constructor () CustomERC721Full("BlockCities", "BKC") public {
super.addWhitelisted(msg.sender);
}

function createBuilding (
        uint256 _exteriorColorway,
        uint256 _backgroundColorway,
        uint256 _city,
        uint256 _building,
        uint256 _base,
        uint256 _body,
        uint256 _roof,
        uint256 _special,
        address _architect
    ) onlyWhitelisted public returns (uint256 _tokenId) {
uint256 entry_1 = 0;
uint256 tmp_138;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_138 := mload(0x40)
mstore(0x40, add(tmp_138, 640))
sstore(memoryStart_0_slot, tmp_138)
mstore(add(tmp_138, 0), 0)
}

}

address[] memory a_133;
assembly {
a_133 := add(sload(memoryStart_0_slot), 0)
}

uint256 tokenId = tokenIdPointer.add(1);
tokenIdPointer = tokenId;
buildings[tokenId] = Building({ exteriorColorway : _exteriorColorway, backgroundColorway : _backgroundColorway, city : _city, building : _building, base : _base, body : _body, roof : _roof, special : _special, architect : _architect });
totalBuildings = totalBuildings.add(1);
_mint(_architect, tokenId);
emit BuildingMinted(tokenId, _architect, _architect);
{
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
for (uint256 index_134 = 0; index_134 < a_133.length; index_134 += 1) {
address tmp_135;
assembly {
tmp_135 := mload(add(a_133, mul(add(index_134, 1), 32)))
}

assert(_ownedTokensCount[tmp_135] == sum_ownersToken[tmp_135]);
}

memoryStart_0 = 0;
}

return tokenId;
}

if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
for (uint256 index_136 = 0; index_136 < a_133.length; index_136 += 1) {
address tmp_137;
assembly {
tmp_137 := mload(add(a_133, mul(add(index_136, 1), 32)))
}

assert(_ownedTokensCount[tmp_137] == sum_ownersToken[tmp_137]);
}

memoryStart_0 = 0;
}

}

function mint (address to, uint256 id) public returns (uint) {
uint256 entry_1 = 0;
uint256 tmp_144;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_144 := mload(0x40)
mstore(0x40, add(tmp_144, 640))
sstore(memoryStart_0_slot, tmp_144)
mstore(add(tmp_144, 0), 0)
}

}

address[] memory a_139;
assembly {
a_139 := add(sload(memoryStart_0_slot), 0)
}

_mint(to, id);
{
if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
for (uint256 index_140 = 0; index_140 < a_139.length; index_140 += 1) {
address tmp_141;
assembly {
tmp_141 := mload(add(a_139, mul(add(index_140, 1), 32)))
}

assert(_ownedTokensCount[tmp_141] == sum_ownersToken[tmp_141]);
}

memoryStart_0 = 0;
}

return id;
}

if (entry_1 == 1) {
assert(sum_tokenCount == _allTokens.length);
for (uint256 index_142 = 0; index_142 < a_139.length; index_142 += 1) {
address tmp_143;
assembly {
tmp_143 := mload(add(a_139, mul(add(index_142, 1), 32)))
}

assert(_ownedTokensCount[tmp_143] == sum_ownersToken[tmp_143]);
}

memoryStart_0 = 0;
}

}

function tokenURI (uint256 tokenId) external view returns (string memory) {
require(_exists(tokenId));
{
return Strings.strConcat(tokenBaseURI, Strings.uint2str(tokenId));
}

}

function attributes (uint256 _tokenId) public view returns (
        uint256 _exteriorColorway,
        uint256 _backgroundColorway,
        uint256 _city,
        uint256 _building,
        uint256 _base,
        uint256 _body,
        uint256 _roof,
        uint256 _special,
        address _architect
    ) {
require(_exists(_tokenId), "Token ID not found");
Building storage building = buildings[_tokenId];
{
return (
        building.exteriorColorway,
        building.backgroundColorway,
        building.city,
        building.building,
        building.base,
        building.body,
        building.roof,
        building.special,
        building.architect
        );
}

}

function tokensOfOwner (address owner) public view returns (uint256[] memory) {
{
return _tokensOfOwner(owner);
}

}

function burn (uint256 _tokenId) onlyWhitelisted public returns (bool) {
_burn(_tokenId);
delete buildings[_tokenId];
{
return true;
}

}

function updateTokenBaseURI (string memory _newBaseURI) onlyWhitelisted public {
require(bytes(_newBaseURI).length != 0, "Base URI invalid");
tokenBaseURI = _newBaseURI;
}

}
