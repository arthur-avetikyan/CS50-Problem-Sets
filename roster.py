import cs50

from sys import exit, argv

if not len(argv) == 2:
    print("Usage: python dna.py data.csv sequence.txt")
    exit(1)

db = cs50.SQL("sqlite:///students.db")

students = db.execute(f"SELECT first, middle, last, birth FROM students WHERE house = '{argv[1]}' ORDER BY last, first")

for student in students:
    if student['middle'] == None:
        print(student['first'], student['last'], student['birth'])
    else:
        print(student['first'], student['middle'], student['last'], student['birth'])

exit(0)