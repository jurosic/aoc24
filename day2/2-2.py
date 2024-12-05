f = open("2.txt", "r")

l = [[int(x) for x in line.split(" ")] for line in f] 
l2 = []

safe = 0

for row in l:
    p = 1 if row[0] < row[1] else -1
    last = row[0]
    for i in range(1, len(row)):
        if p == 1 and last > row[i]:
            l2.append(row.copy())
            #l2[-1].pop(i-1)
            break
        
        if p == -1 and last < row[i]:
            l2.append(row.copy())
            #l2[-1].pop(i-1)
            break
        
        if last == row[i]:
            l2.append(row.copy())
            #l2[-1].pop(i-1)
            break
        
        if abs(last - row[i]) > 3:
            l2.append(row.copy())
            #l2[-1].pop(i)
            break
        
        last = row[i]
    else:
        print("ding")
        safe += 1
        


for row in l2:
    for i in range(len(row)):
        r = row.copy()
        r.pop(i)
        p = 1 if r[0] < r[1] else -1
        last = r[0]
        for j in range(1, len(r)):
            if p == 1 and last > r[j]:
                break
            if p == -1 and last < r[j]:
                break
            if last == r[j]:
                break
            if abs(last - r[j]) > 3:
                break
            
            last = r[j]
        else:
            safe += 1
            break
        
print(safe)