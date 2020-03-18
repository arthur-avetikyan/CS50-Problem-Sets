import csv
import cs50

from sys import argv, exit

if not len(argv) == 2:
    print("Usage: python dna.py data.csv sequence.txt")
    exit(1)

db = cs50.SQL("sqlite:///students.db")

with open(argv[1], "r") as file:
    reader = csv.DictReader(file)
    for row in reader:
        val = row['name']
        if val.count(' ') == 2:
            first_name = val[0: val.index(" ")]
            name = val[len(first_name) + 1 : len(val)]
            middle_name = name[0 : name.index(" ")]
            last_name = name[len(middle_name)+1:len(name)]
        else:
            first_name = val[0 : val.index(" ")]
            name = val[len(first_name) + 1 : len(val)]
            middle_name = None
            last_name = name[0:len(name)]
        db.execute("INSERT INTO students(first, middle, last, house, birth) VALUES(?,?,?,?,?)", first_name, middle_name, last_name, row['house'], row['birth'])

exit(0)