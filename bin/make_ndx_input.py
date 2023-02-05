input_file = input()

with open(input_file) as f:
    data = f.readlines()

del data[0]
atom = int(data[0])
del data[0]
size = data[atom].split()
z_range = float(size[2])
print("[ FIX ]")
fix = []
for i in range(int(atom/5)):
    line = data[i*5].split()
    if float(line[-4]) < z_range/2 and float(line[-4]) > 0:
        for j in range(1,6):
            num = str(i*5+j)
            if len(num) < 4:
                num = '{:>4s}'.format(num)
            fix.append(num)

mod = len(fix)%15
fix_line = len(fix)//15

for i in range(fix_line):
    for j in range(14):
        print(fix[i*15+j],end=" ")
    print(fix[i*15+14])
if mod != 0:
    if mod > 1:
        for i in range(-1*mod,-1,1):
            print(fix[i],end=" ")
    print(fix[-1])
