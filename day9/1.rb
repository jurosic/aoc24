$stdout.sync = true

file = File.open("9.txt", "r")

#create array
inp = []
file.each_line do |line|
    line.each_char do |idx|
        inp << line[idx].to_i
    end
end


fofs = true
fidx = 0
arr = []

inp.each_index do |idx|
    for i in 0..inp[idx]-1
        if fofs == true
            arr << fidx
        end
        if fofs == false
            arr << '.'
        end
    end
    fofs = !fofs
    if fofs == true
        fidx += 1
    end
end

#sort 

arr.each_index do |idx|
    if arr[idx] == '.'
        #switch places with last number
        (arr.length - 1).downto(idx).each do |i|
            if arr[i] != '.'
                arr[idx] = arr[i]
                arr[i] = '.'
                break
            end
        end
    end
end

sum = 0

arr.each_index do |idx|
    if arr[idx] == '.'
        break
    end
    sum += arr[idx] * idx
end

arr.each_index do |idx|
    print arr[idx]
end
puts
puts sum
