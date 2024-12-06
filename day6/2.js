//id rather wait half an hour

var showMarkedMap = function(map, marked) {
    process.stdout.write("---------------------\n");
    for (let i = 0; i < map.length; i++) {
        for (let j = 0; j < map[i].length; j++) {
            if (marked[i][j][1] == true) {
                process.stdout.write('+');
                continue;
            } else {
                process.stdout.write(marked[i][j][0] ? 'X' : map[i][j]);
            }
        }
        process.stdout.write('\n');
    }
}

var setHas = function(set, val) {
    for (let i of set) {
        if (i[0] == val[0] && i[1] == val[1]) {
            return true;
        }
    }
    return false;
}

var setVisitedIncrementUntil2 = function(set, val) {
    for (let i of set) {
        if (i[0] == val[0] && i[1] == val[1]) {
            i[2]++;
            if (i[2] == 4) {
                return true;
            }
        }
    }
    return false;
}


var find_visited = function(input, replace_dir) {
    let map = [];
    let marked = [];
    let dir_rot = [[-1, 0],[0, 1],[1, 0],[0, -1]];

    for (let i = 0; i < input.length; i++) {
        for (let j = 0; j < input[i].length; j++) {
            if (!map[i]) map[i] = [];
            map[i][j] = input[i][j];

            //--------
            if (!marked[j]) marked[j] = [];
            marked[i][j] = [false, false];
            //--------
        }
    }

    if (replace_dir) {
        map[replace_dir[0]][replace_dir[1]] = 'O';
    }

    //--------------------------------------------

    let dir_idx = -1;
    let x, y = 0;

    //find direction
    for (let i = 0; i < map.length; i++) {
        for (let j = 0; j < map[i].length; j++) {
            if (map[i][j] == '^') {
                x = i;
                y = j;
                dir_idx = 0;
            }
            if (map[i][j] == 'v') {
                x = i;
                y = j;
                dir_idx = 2;
            }
            if (map[i][j] == '<') {
                x = i;
                y = j;
                dir_idx = 3;
            }
            if (map[i][j] == '>') {
                x = i;
                y = j;
                dirx = 1;
                diry = 0;
                dir_idx = 1;
            }
        }
    }

    let visited = new Set();

    //visited.add([x, y, 0]);

    //run logic
    //check for map bounds
    while (x >= 0 && x < map.length && y >= 0 && y < map[x].length) {
        //check if checking forward doesnt go outside of bounds
        if (x+(dir_rot[dir_idx][0]) < 0 || x+(dir_rot[dir_idx][0]) >= map.length || y+(dir_rot[dir_idx][1]) < 0 || y+(dir_rot[dir_idx][1]) >= map[x].length) {
            break;
        } else {
            if (map[x+(dir_rot[dir_idx][0])][y+(dir_rot[dir_idx][1])] == "#" || 
                map[x+(dir_rot[dir_idx][0])][y+(dir_rot[dir_idx][1])] == "O") {
                dir_idx = (dir_idx + 1) % 4;
                marked[x][y][1] = true;
                if (setHas(visited, [x,y])) {
                    if (setVisitedIncrementUntil2(visited, [x,y])){
                        return [true, visited, marked, map];
                    };
                }
                continue;
            }
        }
        marked[x][y][0] = true; 
        x += dir_rot[dir_idx][0];
        y += dir_rot[dir_idx][1];
        if (!setHas(visited, [x,y])) {
            visited.add([x,y, 0]);
        }

    }
    //marked[x][y][0] = true;

    return [false, visited, marked, map];
}

const fs = require('fs');

const input = fs.readFileSync('./6.txt', 'utf8').split('\n');

let visited = find_visited(input)[1];

let looped = 0;

for (coords of visited) {
    let x = find_visited(input, coords);
    if (x[0]) {
        //showMarkedMap(x[3], x[2]);
        looped++;
    }
}

console.log(looped);


