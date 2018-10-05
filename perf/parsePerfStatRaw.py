import sys


# Given two perf stat file, produce a table of comparison where each entry is normalized to the throughput
# file format has to be
#  <config name>,config
#  <actual throughput>,throughput
#  output of perf stat
#
fileName1 = str(sys.argv[1])
fileName2 = str(sys.argv[2])

PROPERTIES={ \
'config' : 'config', \
'throughput' : 'throughput', \
'task-clock' : 'task-clock', \
'cycles' : 'cycles', \
'instructions' : 'instructions', \
'cache-misses' : 'LLC.MISSES', \
'cache-references' : 'LLC.ACCESSES', \
'branch-misses' : 'branch-misses', \
'branches' : 'branches', \
'r0180' : 'ICACHE.HIT', \
'r0280' : 'ICACHE.MISSES', \
'r0380' : 'ICACHE.ACCESSES', \
'r81d0' : 'MEM_UOPS_RETIRED.ALL_LOADS', \
'r82d0' : 'MEM_UOPS_RETIRED.ALL_STORES', \
'r01d1' : 'MEM_LOAD_UOPS_RETIRED.L1_HIT', \
'r02d1' : 'MEM_LOAD_UOPS_RETIRED.L2_HIT', \
'r04d1' : 'MEM_LOAD_UOPS_RETIRED.L3_HIT', \
'r08d1' : 'MEM_LOAD_UOPS_RETIRED.L1_MISS', \
'r10d1' : 'MEM_LOAD_UOPS_RETIRED.L2_MISS', \
'r20d1' : 'MEM_LOAD_UOPS_RETIRED.L3_MISS', \
'L1-dcache-loads' : 'L1-dcache-loads', \
'L1-dcache-stores' : 'L1-dcache-stores', \
'L1-icache-load-misses' : 'L1-icache-load-misses', \
'LLC-load-misses' : 'LLC-load-misses', \
'LLC-loads' : 'LLC-loads', \
'LLC-store-misses' : 'LLC-store-misses', \
'LLC-stores' : 'LLC-stores', \
'branch-load-misses' : 'branch-load-misses', \
'branch-loads' : 'branch-loads', \
'dTLB-load-misses' : 'dTLB-load-misses', \
'dTLB-loads' : 'dTLB-loads', \
'dTLB-store-misses' : 'dTLB-store-misses', \
'dTLB-stores' : 'dTLB-stores', \
'iTLB-load-misses' : 'iTLB-load-misses', \
'iTLB-loads' : 'iTLB-loads', \
'page-faults' : 'page-faults', \
'minor-faults' : 'minor-faults', \
#'major-faults' : 'page-faults', \
'context-switches' : 'context-switches' \
}

PROPERTIES_LIST_IN_ORDER = [ \
'config', \
'throughput', \
'task-clock', \
'cycles', \
'instructions', \
'cpi', \
'LLC.MISSES', \
'LLC.ACCESSES', \
'LLC.MISSES.RATE', \
'branches', \
'branch-misses', \
'branch.miss.rate', \
'ICACHE.HIT', \
'ICACHE.ACCESSES', \
'ICACHE.MISSES', \
'ICACHE.MISS.RATE', \
'MEM_UOPS_RETIRED.ALL_LOADS', \
'MEM_UOPS_RETIRED.ALL_STORES', \
'MEM_LOAD_UOPS_RETIRED.L1_HIT', \
'MEM_LOAD_UOPS_RETIRED.L2_HIT', \
'MEM_LOAD_UOPS_RETIRED.L3_HIT', \
'MEM_LOAD_UOPS_RETIRED.L1_MISS', \
'MEM_LOAD_UOPS_RETIRED.L2_MISS', \
'MEM_LOAD_UOPS_RETIRED.L3_MISS', \
'MEM_LOAD_UOPS_RETIRED.L3_MISS.RATE', \
'page-faults', \
'minor-faults', \
'page-faults', \
'context-switches', \
'L1-dcache-loads', \
'L1-dcache-stores', \
'L1-icache-load-misses', \
'LLC-load-misses', \
'LLC-loads', \
'LLC-store-misses', \
'LLC-stores', \
'branch-load-misses', \
'branch-loads', \
'dTLB-load-misses', \
'dTLB-loads', \
'dTLB-store-misses', \
'dTLB-stores', \
'iTLB-load-misses', \
'iTLB-loads'
]


def relativeToKey(_data, baseKey):
    for key in _data:
        if key == baseKey:
            continue
        if not isNumber(_data[key]):
            continue
        _data[key] = _data[key]/_data[baseKey]
    return _data

def maxLengthOfString(strList):
    return len(max(strList, key=len))

# Format string for both decimal and integer
def getFormatString(formatWidth, precision = 0):
    if precision == 0:
        return "{:" + str(formatWidth) + 'd}'
    else:
        return "{:" + str(formatWidth) + '.' + str(precision) + 'f}'

def formatObject(obj, formatWidth, precision = 0):
    objType = type(obj)
    if objType is str:
        return ' ' * (formatWidth - len(obj)) + obj
    elif objType is float:
        return getFormatString(formatWidth, precision).format(obj)
    elif objType is int:
        return getFormatString(formatWidth).format(obj)
    # Better replace the following with exception?
    return None

def dumpDictionary(_dict, formatWidth, precision):
    alignment = maxLengthOfString(list(_dict.keys()))
    #valueFormatString = "{:15.4f}"
    # Print the dictionary with alignment
    for key in _dict:
        print(formatObject(key, alignment) + " : " + formatObject(_dict[key], formatWidth, precision))

def dumpThreeDictionaries(keyList, _dict1, _dict2, _dict3, formatWidth, precision):
    alignment = maxLengthOfString(list(_dict1.keys()))
    actualKeyList = _dict1.keys()
    for key in keyList:
        if key not in actualKeyList:
            continue
        print(formatObject(key, alignment) + " : " + formatObject(_dict1[key], formatWidth, precision) + " : " + formatObject(_dict2[key], formatWidth, precision) + " : " + formatObject(_dict3[key], formatWidth, precision))

def compareTwoStats(_dict1, _dict2):
    result = {}
    for key in _dict1:
        if not isNumber(_dict1[key]):
            result[key] = str(_dict1[key]) + '/' + str(_dict2[key])
            continue
        result[key] = _dict1[key]/_dict2[key]
    return result

#def dumpDictionariesWithTheSameKey(_dict1, _dict2):

def isNumber(string):
    try:
        float(string)
        return True
    except ValueError:
        return False

def processLine(line):
    if not line or line.isspace():
        return None
    line = line.strip()
    if line[0] == '#':
        return None
    s = list(filter(None, line.split(',')))
    if len(s) < 2:
        return None
#    if s[1] not in PROPERTIES:
#        return None
    # Replace PROPERTIES name with something meaningful
#    s[1] = s[1].replace(s[1], PROPERTIES[s[1]])
    # Swap the counter and the counter name
    s[0], s[1] = s[1], s[0]
    return s

def processPerfStat(fileName):
    data = {}
    # Parse the file
    with open(fileName) as fhand:
        for line in fhand:
            result = processLine(line)
            if result is None:
                continue
            # Handle non-numeric properties like configuration name
            if not isNumber(result[1]):
                data[result[0]] = result[1]
                continue
            data[result[0]] = float(result[1])

    # normalize the data
    #relativeToKey(data, "throughput")

    # Calculate cpi
    data["cpi"] = data["cycles"]/data["instructions"]

    #Calculate cache miss rates
    if "ICACHE.MISSES" in data:
       data["ICACHE.MISS.RATE"] = data["ICACHE.MISSES"]/data["ICACHE.ACCESSES"]
    if "branch-misses" in data:
       data["branch.miss.rate"] = data["branch-misses"]/data["branches"]
    if "LLC.MISSES" in data:
       data["LLC.MISSES.RATE"] = data["LLC.MISSES"]/data["LLC.ACCESSES"]
    if "MEM_LOAD_UOPS_RETIRED.L3_MISS" in data:
       data["MEM_LOAD_UOPS_RETIRED.L3_MISS.RATE"] = data["MEM_LOAD_UOPS_RETIRED.L3_MISS"]/(data["MEM_LOAD_UOPS_RETIRED.L3_MISS"] + data["MEM_LOAD_UOPS_RETIRED.L3_HIT"])
    return data

# Dump the dictionary to standard out
data1 = processPerfStat(fileName1)
data2 = processPerfStat(fileName2)
formatWidth = 20
precision = 4
#dumpDictionary(data1, formatWidth, precision)
#dumpDictionary(data2, formatWidth, precision)
comparison = compareTwoStats(data1, data2)
#dumpDictionary(comparison, formatWidth, precision)
print "Comparison of normalized perf stat"
#dumpThreeDictionaries(PROPERTIES_LIST_IN_ORDER, data1, data2, comparison, formatWidth, precision)
dumpThreeDictionaries(data1.keys(), data1, data2, comparison, formatWidth, precision)
