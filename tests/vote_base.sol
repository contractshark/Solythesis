pragma solidity ^0.5.0;
contract AdvancedTokenVote1202 {
uint256 memoryStart_0;
mapping (address=>bool) b_checker_6;
address[] b_store_7;
mapping (uint=>bool) a_checker_2;
uint[] a_store_3;
mapping (uint=>bool) c_checker_4;
uint[] c_store_5;
mapping (uint=>mapping (uint=>uint256)) sum_votes;
mapping (uint=>bool) x_checker_8;
uint[] x_store_9;
mapping (uint=>bool) y_checker_10;
uint[] y_store_11;
mapping (uint=>string) public issueDescriptions;
mapping (uint=>uint[]) internal options;
mapping (uint=>mapping (uint=>string)) internal optionDescMap;
mapping (uint=>bool) internal isOpen;
mapping (uint=>mapping (address=>uint256)) public weights;
mapping (uint=>mapping (uint=>uint256)) public weightedVoteCounts;
mapping (uint=>mapping (address=>uint)) public ballots;
constructor () public {
optionDescMap[0][1] = "No";
optionDescMap[0][2] = "Yes, 100 more";
optionDescMap[0][3] = "Yes, 200 more";
optionDescMap[1][1] = "No";
optionDescMap[1][2] = "Yes";
}

function createIssue (uint issueId, address _tokenAddr, uint[] memory options_, address[] memory qualifiedVoters_, string memory issueDesc_) public {
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

require(options_.length >= 2);
require(options[issueId].length == 0);
options[issueId] = options_;
isOpen[issueId] = true;
for (uint i = 0; i < qualifiedVoters_.length; i ++) {
address voter = qualifiedVoters_[i];
weights[issueId][voter] = 5;if (! b_checker_6[voter]) {
b_store_7.push(voter);
b_checker_6[voter] = true;
}
if (! a_checker_2[issueId]) {
a_store_3.push(issueId);
a_checker_2[issueId] = true;
}
if (! c_checker_4[ballots[issueId][voter]]) {
c_store_5.push(ballots[issueId][voter]);
c_checker_4[ballots[issueId][voter]] = true;
}

}

issueDescriptions[issueId] = issueDesc_;
if (entry_1 == 1) {
{
for (uint256 index_3 = 0; index_3 < a_store_3.length; index_3 += 1) {
for (uint256 index_4 = 0; index_4 < c_store_5.length; index_4 += 1) {
sum_votes[a_store_3[index_3]][c_store_5[index_4]] = 0;
}

}

for (uint256 index_5 = 0; index_5 < b_store_7.length; index_5 += 1) {
for (uint256 index_6 = 0; index_6 < a_store_3.length; index_6 += 1) {
sum_votes[a_store_3[index_6]][ballots[a_store_3[index_6]][b_store_7[index_5]]] += weights[a_store_3[index_6]][b_store_7[index_5]];
assert(sum_votes[a_store_3[index_6]][ballots[a_store_3[index_6]][b_store_7[index_5]]] >= weights[a_store_3[index_6]][b_store_7[index_5]]);
}

}

}

for (uint256 index_10 = 0; index_10 < x_store_9.length; index_10 += 1) {
for (uint256 index_11 = 0; index_11 < y_store_11.length; index_11 += 1) {
assert(y_store_11[index_11] == 0 || sum_votes[x_store_9[index_10]][y_store_11[index_11]] == weightedVoteCounts[x_store_9[index_10]][y_store_11[index_11]]);
}

}

memoryStart_0 = 0;
}

}

function vote (uint issueId, uint option) public returns (bool success) {
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

require(isOpen[issueId]);
uint256 weight = weights[issueId][msg.sender];
weightedVoteCounts[issueId][option] += weight;if (! y_checker_10[option]) {
y_store_11.push(option);
y_checker_10[option] = true;
}
if (! x_checker_8[issueId]) {
x_store_9.push(issueId);
x_checker_8[issueId] = true;
}

ballots[issueId][msg.sender] = option;if (! b_checker_6[msg.sender]) {
b_store_7.push(msg.sender);
b_checker_6[msg.sender] = true;
}
if (! a_checker_2[issueId]) {
a_store_3.push(issueId);
a_checker_2[issueId] = true;
}
if (! c_checker_4[ballots[issueId][msg.sender]]) {
c_store_5.push(ballots[issueId][msg.sender]);
c_checker_4[ballots[issueId][msg.sender]] = true;
}

emit OnVote(issueId, msg.sender, option);
{
bool tmp_13 = true;
if (entry_1 == 1) {
{
for (uint256 index_14 = 0; index_14 < a_store_3.length; index_14 += 1) {
for (uint256 index_15 = 0; index_15 < c_store_5.length; index_15 += 1) {
sum_votes[a_store_3[index_14]][c_store_5[index_15]] = 0;
}

}

for (uint256 index_16 = 0; index_16 < b_store_7.length; index_16 += 1) {
for (uint256 index_17 = 0; index_17 < a_store_3.length; index_17 += 1) {
sum_votes[a_store_3[index_17]][ballots[a_store_3[index_17]][b_store_7[index_16]]] += weights[a_store_3[index_17]][b_store_7[index_16]];
assert(sum_votes[a_store_3[index_17]][ballots[a_store_3[index_17]][b_store_7[index_16]]] >= weights[a_store_3[index_17]][b_store_7[index_16]]);
}

}

}

for (uint256 index_21 = 0; index_21 < x_store_9.length; index_21 += 1) {
for (uint256 index_22 = 0; index_22 < y_store_11.length; index_22 += 1) {
assert(y_store_11[index_22] == 0 || sum_votes[x_store_9[index_21]][y_store_11[index_22]] == weightedVoteCounts[x_store_9[index_21]][y_store_11[index_22]]);
}

}

memoryStart_0 = 0;
}

return (tmp_13);
}

if (entry_1 == 1) {
{
for (uint256 index_23 = 0; index_23 < a_store_3.length; index_23 += 1) {
for (uint256 index_24 = 0; index_24 < c_store_5.length; index_24 += 1) {
sum_votes[a_store_3[index_23]][c_store_5[index_24]] = 0;
}

}

for (uint256 index_25 = 0; index_25 < b_store_7.length; index_25 += 1) {
for (uint256 index_26 = 0; index_26 < a_store_3.length; index_26 += 1) {
sum_votes[a_store_3[index_26]][ballots[a_store_3[index_26]][b_store_7[index_25]]] += weights[a_store_3[index_26]][b_store_7[index_25]];
assert(sum_votes[a_store_3[index_26]][ballots[a_store_3[index_26]][b_store_7[index_25]]] >= weights[a_store_3[index_26]][b_store_7[index_25]]);
}

}

}

for (uint256 index_28 = 0; index_28 < x_store_9.length; index_28 += 1) {
for (uint256 index_29 = 0; index_29 < y_store_11.length; index_29 += 1) {
assert(y_store_11[index_29] == 0 || sum_votes[x_store_9[index_28]][y_store_11[index_29]] == weightedVoteCounts[x_store_9[index_28]][y_store_11[index_29]]);
}

}

memoryStart_0 = 0;
}

}

function setStatus (uint issueId, bool isOpen_) public returns (bool success) {
isOpen[issueId] = isOpen_;
emit OnStatusChange(issueId, isOpen_);
{
return true;
}

}

function ballotOf (uint issueId, address addr) public view returns (uint option) {
{
return ballots[issueId][addr];
}

}

function weightOf (uint issueId, address addr) public view returns (uint weight) {
{
return weights[issueId][addr];
}

}

function getStatus (uint issueId) public view returns (bool isOpen_) {
{
return isOpen[issueId];
}

}

function weightedVoteCountsOf (uint issueId, uint option) public view returns (uint count) {
{
return weightedVoteCounts[issueId][option];
}

}

function winningOption (uint issueId) public view returns (uint option) {
uint ci = 0;
for (uint i = 1; i < options[issueId].length; i ++) {
uint optionI = options[issueId][i];
uint optionCi = options[issueId][ci];
if (weightedVoteCounts[issueId][optionI] > weightedVoteCounts[issueId][optionCi]) {
ci = i;
}

}

{
return options[issueId][ci];
}

}

function issueDescription (uint issueId) public view returns (string memory desc) {
{
return issueDescriptions[issueId];
}

}

function availableOptions (uint issueId) public view returns (uint[] memory options_) {
{
return options[issueId];
}

}

function optionDescription (uint issueId, uint option) public view returns (string memory desc) {
{
return optionDescMap[issueId][option];
}

}

event OnVote(uint issueId, address indexed _from, uint _value);
event OnStatusChange(uint issueId, bool newIsOpen);
}
