# rcc = 0.900  # C_C間距離(nm)
rcc = 1.500
rch = 0.109  # C_H間距離(nm)
a = rcc/3**0.5
b = rch/3**0.5
x = 22  # 箱の基準長さ
met = 1  # メタンの通し番号
atom = 1 # 原子の通し番号

print("methane")
print(x**3*5)
for i in range(int(x/2)):
    for j in range(int(x/2)):
        for k in range(int(x*2)):
            print(f"{'{:5d}'.format(met)}  MET    C"+'{:5d}'.format(atom), '{:7.3f}'.format(round(2*a*i, 3)), '{:7.3f}'.format(round(2*a*j, 3)), '{:7.3f}'.format(round(2*a*k, 3)))
            atom += 1
            print(f"{'{:5d}'.format(met)}  MET    H"+'{:5d}'.format(atom), '{:7.3f}'.format(round(2*a*i+b, 3)), '{:7.3f}'.format(round(2*a*j+b, 3)), '{:7.3f}'.format(round(2*a*k+b, 3)))
            atom += 1
            print(f"{'{:5d}'.format(met)}  MET    H"+'{:5d}'.format(atom), '{:7.3f}'.format(round(2*a*i+b, 3)), '{:7.3f}'.format(round(2*a*j-b, 3)), '{:7.3f}'.format(round(2*a*k-b, 3)))
            atom += 1
            print(f"{'{:5d}'.format(met)}  MET    H"+'{:5d}'.format(atom), '{:7.3f}'.format(round(2*a*i-b, 3)), '{:7.3f}'.format(round(2*a*j+b, 3)), '{:7.3f}'.format(round(2*a*k-b, 3)))
            atom += 1
            print(f"{'{:5d}'.format(met)}  MET    H"+'{:5d}'.format(atom), '{:7.3f}'.format(round(2*a*i-b, 3)), '{:7.3f}'.format(round(2*a*j-b, 3)), '{:7.3f}'.format(round(2*a*k+b, 3)))
            atom += 1
            met += 1
    for j in range(int(x/2)):
        for k in range(int(x*2)):
            print(f"{'{:5d}'.format(met)}  MET    C"+'{:5d}'.format(atom), '{:7.3f}'.format(round(2*a*i+a, 3)), '{:7.3f}'.format(round(2*a*j+a, 3)), '{:7.3f}'.format(round(2*a*k+a, 3)))
            atom += 1
            print(f"{'{:5d}'.format(met)}  MET    H"+'{:5d}'.format(atom), '{:7.3f}'.format(round(2*a*i+a+b, 3)), '{:7.3f}'.format(round(2*a*j+a+b, 3)), '{:7.3f}'.format(round(2*a*k+a+b, 3)))
            atom += 1
            print(f"{'{:5d}'.format(met)}  MET    H"+'{:5d}'.format(atom), '{:7.3f}'.format(round(2*a*i+a+b, 3)), '{:7.3f}'.format(round(2*a*j+a-b, 3)), '{:7.3f}'.format(round(2*a*k+a-b, 3)))
            atom += 1
            print(f"{'{:5d}'.format(met)}  MET    H"+'{:5d}'.format(atom), '{:7.3f}'.format(round(2*a*i+a-b, 3)), '{:7.3f}'.format(round(2*a*j+a+b, 3)), '{:7.3f}'.format(round(2*a*k+a-b, 3)))
            atom += 1
            print(f"{'{:5d}'.format(met)}  MET    H"+'{:5d}'.format(atom), '{:7.3f}'.format(round(2*a*i+a-b, 3)), '{:7.3f}'.format(round(2*a*j+a-b, 3)), '{:7.3f}'.format(round(2*a*k+a+b, 3)))
            atom += 1
            met += 1
print(round(x*a, 5), round(x*a, 5), round(4*x*a, 5))
