#!/bin/python
import re
import statistics
import sys

def GdaxStatistics(filename):
    gdax_data = []
    with open(filename, 'r') as f:
        content = f.read()
        allruns = re.findall(r'(0-0\.49.*?19.99 s: \d+)', content, flags=re.DOTALL)
        for run in allruns:
            iterations = 0
            for entry in run.split('\n'):
                if entry:
                    (_, count) = entry.split(': ')
                    iterations += int(count)

            gdax_data.append(iterations)

    return gdax_data

def SiloStatistics(filename):
    data = []
    with open(filename, 'r') as f:
        content = f.read()
        allruns = re.findall(r'agg_throughput: (\d+\.\d+) ops', content)
        data = [float(x) for x in allruns]

    return data

def TimeStatistics(filename):
    data = []
    with open(filename, 'r') as f:
        content = f.read()
        allruns = re.findall(r'real.*?(\d+)m(\d+\.\d+)s', content)
        for run in allruns:
            (minute,second) = run
            time = int(minute) * 60 + float(second)
            data.append(time)

    return data

def JsbenchStatistics(filename):
     with open(filename, 'r') as f:
        content = f.read()
        result = re.search(r'(Final results.*?runs)', content, flags=re.DOTALL)
        print(result.group(0))

def printData(data):
    str_data = [str(x) for x in data]
    print 'raw data:', ', '.join(str_data)
    print 'mean:', statistics.mean(data)
    print 'stddev:', statistics.stdev(data)
    print ''

if __name__ == "__main__":
    base = '.'
    if len(sys.argv) == 2:
        base = sys.argv[1]

    print 'Silo measurement: agg_throughput, unit: ops/sec'
    printData(SiloStatistics( base + '/silo.log'))

    print 'Gdax measurement: number of iterations'
    printData(GdaxStatistics( base + '/gdax.log'))

    print 'Iris measurement: real time unit: seccond'
    printData(TimeStatistics( base + '/iris.log'))

    print 'Mabain measurement: real time, unit: second'
    printData(TimeStatistics( base + '/mabain.log'))

    print 'Jsbench results:'
    JsbenchStatistics( base + '/jsbench.log');
