import csv
from sys import argv, exit

if not len(argv) == 3:
    print("Usage: python dna.py data.csv sequence.txt")
    exit(1)

dna_db = []
seq = []
dna_sample = []
count = 0
first_count = 0

with open(argv[2]) as sequence:
    reader = csv.reader(sequence)
    for row in reader:
        dna_sample = row

with open(argv[1]) as database:
    dictReader = csv.reader(database)
    for row in dictReader:
        dna_db.append(row)


for key in dna_db[0]:
    if not key == 'name':
        char = 0
        while char in range(len(dna_sample[0])):
            if dna_sample[0][char : char + len(key)] == key:
                first_count += 1
                char += len(key) - 1
            elif count < first_count:
                count = first_count
                first_count = 0
            char += 1
        seq.append(str(count))
        count = 0
        first_count = 0
print(seq)


for row in dna_db:
    if not row[0] == 'name':
        if set(row[1:len(row)]) == set(seq):
            print(row[0])
            exit(0)

print("No match")
exit(0)