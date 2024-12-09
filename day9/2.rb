# again, id rather wait

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

dotidx = 0
dotidx_set = false
dotspace = 0
numidx = arr.length-1
numidx_set = false
numspace = 0
num = -1

while numidx >= 0
    (numidx).downto(0).each do |idx|
        if arr[idx] != '.'
            if numidx_set == false
                numidx_set = true
                numidx = idx
                num = arr[idx]
            end
            numspace += 1
        end
        if arr[idx-1] != num and numidx_set == true
            break
        end
    end

    while dotspace < numspace
        if arr[dotidx] == '.'
            dotspace += 1
            dotidx_set = true
        end
        if arr[dotidx+1] != '.' and dotidx_set == true and dotspace < numspace
            dotspace = 0
            dotidx_set = false
        end
        dotidx += 1
        if dotidx >= arr.length or dotidx > numidx
            break
        end
        #puts "numidx: #{numidx} num: #{num} numspace: #{numspace} dotidx: #{dotidx} dotspace: #{dotspace}"
    end

    #puts "dong"

    if dotspace >= numspace
        #puts "move"
        (dotidx-1).downto(dotidx-numspace).each do |idx|
            arr[idx] = num
        end
        (numidx).downto(numidx-numspace+1).each do |idx|
            arr[idx] = '.'
        end
    end
    numidx = numidx - numspace
    numidx_set = false
    numspace = 0
    dotidx = 0
    dotidx_set = false
    dotspace = 0
    num = -1

    perc = (numidx.to_f / arr.length.to_f) * 100
    print perc
    puts

end


sum = 0

arr.each_index do |idx|
    if arr[idx] != '.'
        sum += arr[idx] * idx
    end
end

puts
puts sum
