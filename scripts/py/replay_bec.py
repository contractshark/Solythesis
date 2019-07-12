import sys
from web3 import Web3
import progressbar
import time
from bench import Bench
import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('endpoint')
parser.add_argument('csv')
parser.add_argument('path')
parser.add_argument('key1')
parser.add_argument('key2')
parser.add_argument("--pow", type=bool)
args = parser.parse_args()

if 'transfer' in args.csv:
    NUM_OF_CONTRACT = 155
else:
    NUM_OF_CONTRACT = 115

bench = Bench(args.endpoint, args.path, 'BecToken', args.pow)
a = [bench.import_account(args.key1), bench.import_account(args.key2)]

bec_addr = [bench.call_contract_function(a[0][0], 'constructor', [], private_key=a[0][1])
            for i in range(NUM_OF_CONTRACT)]
bec_addr = [bench.wait_for_result(x).contractAddress for x in bec_addr]

count = 0
ITER = 2000


def generate(idx, k):
    if 'transfer' in sys.argv[2]:
        return bench.call_contract_function(a[idx][0], 'transfer',
                                            [a[idx ^ 1][0], 1],
                                            bec_addr[k], a[idx][1])
    else:
        return bench.call_contract_function(a[idx][0], 'batchTransfer',
                                            [[a[idx ^ 1][0]] * 5, 1],
                                            bec_addr[k], a[idx][1])


bar = progressbar.ProgressBar(maxval=ITER,
                              widgets=[progressbar.Bar('=', '[', ']'), ' ', progressbar.Percentage()])
bar.start()

idx = 0
for i in range(ITER):
    bar.update(i)
    for k in range(NUM_OF_CONTRACT):
        result = generate(idx, k)
    tx_receipt = bench.wait_for_result(result)
    idx ^= 1
