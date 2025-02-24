pragma solidity ^0.5.0;
contract DSMath {
function add (uint x, uint y) internal pure returns (uint z) {
require((z = x + y) >= x);
}

function sub (uint x, uint y) internal pure returns (uint z) {
require((z = x - y) <= x);
}

function mul (uint x, uint y) internal pure returns (uint z) {
require(y == 0 || (z = x * y) / y == x);
}

function min (uint x, uint y) internal pure returns (uint z) {
{
return x <= y ? x : y;
}

}

function max (uint x, uint y) internal pure returns (uint z) {
{
return x >= y ? x : y;
}

}

function imin (int x, int y) internal pure returns (int z) {
{
return x <= y ? x : y;
}

}

function imax (int x, int y) internal pure returns (int z) {
{
return x >= y ? x : y;
}

}

uint constant WAD = 10 ** 18;
uint constant RAY = 10 ** 27;
function wmul (uint x, uint y) internal pure returns (uint z) {
z = add(mul(x, y), WAD / 2) / WAD;
}

function rmul (uint x, uint y) internal pure returns (uint z) {
z = add(mul(x, y), RAY / 2) / RAY;
}

function wdiv (uint x, uint y) internal pure returns (uint z) {
z = add(mul(x, WAD), y / 2) / y;
}

function rdiv (uint x, uint y) internal pure returns (uint z) {
z = add(mul(x, RAY), y / 2) / y;
}

function rpow (uint x, uint n) internal pure returns (uint z) {
z = n % 2 != 0 ? x : RAY;
for (n /= 2; n != 0; n /= 2) {
x = rmul(x, x);
if (n % 2 != 0) {
z = rmul(z, x);
}

}

}

}
contract DSAuthority {
function canCall (
        address src, address dst, bytes4 sig
    ) public view returns (bool);
}
contract DSAuthEvents {
event LogSetAuthority (address indexed authority);
event LogSetOwner     (address indexed owner);
}
contract DSAuth is DSAuthEvents {
DSAuthority public authority;
address public owner;
constructor () public {
owner = msg.sender;
emit LogSetOwner(msg.sender);
}

function setOwner (address owner_) auth public {
owner = owner_;
emit LogSetOwner(owner);
}

function setAuthority (DSAuthority authority_) auth public {
authority = authority_;
emit LogSetAuthority(address(authority));
}

modifier auth {
        require(isAuthorized(msg.sender, msg.sig));
        _;
    }
function isAuthorized (address src, bytes4 sig) internal view returns (bool) {
if (src == address(this)) {
{
return true;
}

}
 else if (src == owner) {
{
return true;
}

}
 else if (authority == DSAuthority(0)) {
{
return false;
}

}
 else {
{
return authority.canCall(src, address(this), sig);
}

}

}

}
contract DSNote {
event LogNote(
        bytes4   indexed  sig,
        address  indexed  guy,
        bytes32  indexed  foo,
        bytes32  indexed  bar,
        uint              wad,
        bytes             fax
    ) anonymous;
modifier note {
        bytes32 foo;
        bytes32 bar;

        assembly {
            foo := calldataload(4)
            bar := calldataload(36)
        }

        emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);

        _;
    }
}
contract DSStop is DSNote, DSAuth {
bool public stopped;
modifier stoppable {
        require(!stopped);
        _;
    }
function stop () auth note public payable {
stopped = true;
}

function start () auth note public payable {
stopped = false;
}

}
contract ERC20Events {
event Approval(address indexed src, address indexed guy, uint wad);
event Transfer(address indexed src, address indexed dst, uint wad);
}
contract ERC20 is ERC20Events {
function totalSupply () public view returns (uint);
function balanceOf (address guy) public view returns (uint);
function allowance (address src, address guy) public view returns (uint);
function approve (address guy, uint wad) public returns (bool);
function transfer (address dst, uint wad) public returns (bool);
function transferFrom (
        address src, address dst, uint wad
    ) public returns (bool);
}
contract DSTokenBase is ERC20, DSMath {
uint256 memoryStart_0;
mapping (address=>bool) a_checker_1;
address[] a_store_2;
uint256 sum_balance;
uint256 _supply;
mapping (address=>uint256) _balances;
mapping (address=>mapping (address=>uint256)) _approvals;
constructor (uint supply) public {
uint256 entry_1 = 0;
uint256 tmp_4;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_4 := mload(0x40)
mstore(0x40, add(tmp_4, 0))
sstore(memoryStart_0_slot, tmp_4)
}

}

_balances[msg.sender] = supply;if (! a_checker_1[msg.sender]) {
a_store_2.push(msg.sender);
a_checker_1[msg.sender] = true;
}

_supply = supply;
if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_3 = 0; index_3 < a_store_2.length; index_3 += 1) {
sum_balance += _balances[a_store_2[index_3]];
assert(sum_balance >= _balances[a_store_2[index_3]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

function totalSupply () public view returns (uint) {
{
return _supply;
}

}

function balanceOf (address src) public view returns (uint) {
{
return _balances[src];
}

}

function allowance (address src, address guy) public view returns (uint) {
{
return _approvals[src][guy];
}

}

function transfer (address dst, uint wad) public returns (bool) {
uint256 entry_1 = 0;
uint256 tmp_7;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_7 := mload(0x40)
mstore(0x40, add(tmp_7, 0))
sstore(memoryStart_0_slot, tmp_7)
}

}

{
if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_5 = 0; index_5 < a_store_2.length; index_5 += 1) {
sum_balance += _balances[a_store_2[index_5]];
assert(sum_balance >= _balances[a_store_2[index_5]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

return transferFrom(msg.sender, dst, wad);
}

if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_6 = 0; index_6 < a_store_2.length; index_6 += 1) {
sum_balance += _balances[a_store_2[index_6]];
assert(sum_balance >= _balances[a_store_2[index_6]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

function transferFrom (address src, address dst, uint wad) public returns (bool) {
uint256 entry_1 = 0;
uint256 tmp_10;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_10 := mload(0x40)
mstore(0x40, add(tmp_10, 0))
sstore(memoryStart_0_slot, tmp_10)
}

}

if (src != msg.sender) {
_approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
}

_balances[src] = sub(_balances[src], wad);if (! a_checker_1[src]) {
a_store_2.push(src);
a_checker_1[src] = true;
}

_balances[dst] = add(_balances[dst], wad);if (! a_checker_1[dst]) {
a_store_2.push(dst);
a_checker_1[dst] = true;
}

emit Transfer(src, dst, wad);
{
if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_8 = 0; index_8 < a_store_2.length; index_8 += 1) {
sum_balance += _balances[a_store_2[index_8]];
assert(sum_balance >= _balances[a_store_2[index_8]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

return true;
}

if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_9 = 0; index_9 < a_store_2.length; index_9 += 1) {
sum_balance += _balances[a_store_2[index_9]];
assert(sum_balance >= _balances[a_store_2[index_9]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

function approve (address guy, uint wad) public returns (bool) {
_approvals[msg.sender][guy] = wad;
emit Approval(msg.sender, guy, wad);
{
return true;
}

}

}
contract DSToken is DSTokenBase(0), DSStop {
bytes32 public symbol = '';
uint256 public decimals = 18;
constructor () public {
uint256 entry_1 = 0;
uint256 tmp_12;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_12 := mload(0x40)
mstore(0x40, add(tmp_12, 0))
sstore(memoryStart_0_slot, tmp_12)
}

}

_supply = 3000000000000;
_balances[msg.sender] = _supply;if (! a_checker_1[msg.sender]) {
a_store_2.push(msg.sender);
a_checker_1[msg.sender] = true;
}

if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_11 = 0; index_11 < a_store_2.length; index_11 += 1) {
sum_balance += _balances[a_store_2[index_11]];
assert(sum_balance >= _balances[a_store_2[index_11]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

event Mint(address indexed guy, uint wad);
event Burn(address indexed guy, uint wad);
function approve (address guy) stoppable public returns (bool) {
{
return super.approve(guy, uint(-1));
}

}

function approve (address guy, uint wad) stoppable public returns (bool) {
{
return super.approve(guy, wad);
}

}

function transfer (address dst, uint wad) public returns (bool) {
uint256 entry_1 = 0;
uint256 tmp_15;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_15 := mload(0x40)
mstore(0x40, add(tmp_15, 0))
sstore(memoryStart_0_slot, tmp_15)
}

}

{
if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_13 = 0; index_13 < a_store_2.length; index_13 += 1) {
sum_balance += _balances[a_store_2[index_13]];
assert(sum_balance >= _balances[a_store_2[index_13]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

return transferFrom(msg.sender, dst, wad);
}

if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_14 = 0; index_14 < a_store_2.length; index_14 += 1) {
sum_balance += _balances[a_store_2[index_14]];
assert(sum_balance >= _balances[a_store_2[index_14]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

function transferFrom (address src, address dst, uint wad) stoppable public returns (bool) {
uint256 entry_1 = 0;
uint256 tmp_18;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_18 := mload(0x40)
mstore(0x40, add(tmp_18, 0))
sstore(memoryStart_0_slot, tmp_18)
}

}

if (src != msg.sender && _approvals[src][msg.sender] != uint(- 1)) {
_approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
}

_balances[src] = sub(_balances[src], wad);if (! a_checker_1[src]) {
a_store_2.push(src);
a_checker_1[src] = true;
}

_balances[dst] = add(_balances[dst], wad);if (! a_checker_1[dst]) {
a_store_2.push(dst);
a_checker_1[dst] = true;
}

emit Transfer(src, dst, wad);
{
if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_16 = 0; index_16 < a_store_2.length; index_16 += 1) {
sum_balance += _balances[a_store_2[index_16]];
assert(sum_balance >= _balances[a_store_2[index_16]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

return true;
}

if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_17 = 0; index_17 < a_store_2.length; index_17 += 1) {
sum_balance += _balances[a_store_2[index_17]];
assert(sum_balance >= _balances[a_store_2[index_17]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

function push (address dst, uint wad) public {
uint256 entry_1 = 0;
uint256 tmp_20;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_20 := mload(0x40)
mstore(0x40, add(tmp_20, 0))
sstore(memoryStart_0_slot, tmp_20)
}

}

transferFrom(msg.sender, dst, wad);
if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_19 = 0; index_19 < a_store_2.length; index_19 += 1) {
sum_balance += _balances[a_store_2[index_19]];
assert(sum_balance >= _balances[a_store_2[index_19]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

function pull (address src, uint wad) public {
uint256 entry_1 = 0;
uint256 tmp_22;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_22 := mload(0x40)
mstore(0x40, add(tmp_22, 0))
sstore(memoryStart_0_slot, tmp_22)
}

}

transferFrom(src, msg.sender, wad);
if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_21 = 0; index_21 < a_store_2.length; index_21 += 1) {
sum_balance += _balances[a_store_2[index_21]];
assert(sum_balance >= _balances[a_store_2[index_21]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

function move (address src, address dst, uint wad) public {
uint256 entry_1 = 0;
uint256 tmp_24;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_24 := mload(0x40)
mstore(0x40, add(tmp_24, 0))
sstore(memoryStart_0_slot, tmp_24)
}

}

transferFrom(src, dst, wad);
if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_23 = 0; index_23 < a_store_2.length; index_23 += 1) {
sum_balance += _balances[a_store_2[index_23]];
assert(sum_balance >= _balances[a_store_2[index_23]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

function mint (uint wad) public {
uint256 entry_1 = 0;
uint256 tmp_26;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_26 := mload(0x40)
mstore(0x40, add(tmp_26, 0))
sstore(memoryStart_0_slot, tmp_26)
}

}

mint(msg.sender, wad);
if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_25 = 0; index_25 < a_store_2.length; index_25 += 1) {
sum_balance += _balances[a_store_2[index_25]];
assert(sum_balance >= _balances[a_store_2[index_25]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

function burn (uint wad) public {
uint256 entry_1 = 0;
uint256 tmp_28;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_28 := mload(0x40)
mstore(0x40, add(tmp_28, 0))
sstore(memoryStart_0_slot, tmp_28)
}

}

burn(msg.sender, wad);
if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_27 = 0; index_27 < a_store_2.length; index_27 += 1) {
sum_balance += _balances[a_store_2[index_27]];
assert(sum_balance >= _balances[a_store_2[index_27]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

function mint (address guy, uint wad) auth stoppable public {
uint256 entry_1 = 0;
uint256 tmp_30;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_30 := mload(0x40)
mstore(0x40, add(tmp_30, 0))
sstore(memoryStart_0_slot, tmp_30)
}

}

_balances[guy] = add(_balances[guy], wad);if (! a_checker_1[guy]) {
a_store_2.push(guy);
a_checker_1[guy] = true;
}

_supply = add(_supply, wad);
emit Mint(guy, wad);
if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_29 = 0; index_29 < a_store_2.length; index_29 += 1) {
sum_balance += _balances[a_store_2[index_29]];
assert(sum_balance >= _balances[a_store_2[index_29]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

function burn (address guy, uint wad) auth stoppable public {
uint256 entry_1 = 0;
uint256 tmp_32;
if (memoryStart_0 == 0) {
entry_1 = 1;
assembly {
tmp_32 := mload(0x40)
mstore(0x40, add(tmp_32, 0))
sstore(memoryStart_0_slot, tmp_32)
}

}

if (guy != msg.sender && _approvals[guy][msg.sender] != uint(- 1)) {
_approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
}

_balances[guy] = sub(_balances[guy], wad);if (! a_checker_1[guy]) {
a_store_2.push(guy);
a_checker_1[guy] = true;
}

_supply = sub(_supply, wad);
emit Burn(guy, wad);
if (entry_1 == 1) {
{
{
sum_balance = 0;
}

for (uint256 index_31 = 0; index_31 < a_store_2.length; index_31 += 1) {
sum_balance += _balances[a_store_2[index_31]];
assert(sum_balance >= _balances[a_store_2[index_31]]);
}

}

assert(_supply == sum_balance);
memoryStart_0 = 0;
}

}

bytes32 public name = "";
function setName (bytes32 name_) auth public {
name = name_;
}

}
