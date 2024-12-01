
def pone():
    f = open("1.txt", "r")

    a = []
    b = []

    for line in f:
        line = line.strip()
        s = line.split(" ")
        
        a.append(int(s[0]))
        b.append(int(s[-1]))


    a = sorted(a)
    b = sorted(b)

    s = 0
    for i in range(min(len(a), len(b))):
        s += abs(a[i] - b[i])
    print(s)
    
def ptwo():
    f = open("1.txt", "r")

    a = []
    b = []

    for line in f:
        line = line.strip()
        s = line.split(" ")
        
        a.append(int(s[0]))
        b.append(int(s[-1]))

    s = 0 
    
    for i in a:
        cnt = 0
        for j in b:
            if i == j:
                cnt += 1
        s += cnt*i
        
    print(s)
    
    
ptwo()