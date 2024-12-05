f = open("2.txt", "r")

l = [[int(x) for x in line.split(" ")] for line in f] 

print(l)

safe = 0

for row in l:
    last = None
    p = 0
    for i in row:
        if last == None:
            last = i
            continue
            
        elif p == 0:
            if last > i:
                p = -1
            if last < i:
                p = 1
            if last == i:
                safe = False
                break
            
            
        else:
            if p == 1 and last > i:
                break
            
            if p == -1 and last < i:
                break
            
            if last == i:
                break

            if abs(last - i) > 3:
                break
 
        last = i
        
    else:
        print("ding")
        print(row)
        safe += 1
        
print(safe)