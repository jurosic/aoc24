const fs = require('fs');


const input = fs.readFileSync('./6.txt', 'utf8').split('\n');

let map = [];
let marked = [];
let dir_rot = [[-1, 0],[0, 1],[1, 0],[0, -1]];

for (let i = 0; i < input.length; i++) {
    for (let j = 0; j < input[i].length; j++) {
        if (!map[i]) map[i] = [];
        map[i][j] = input[i][j];

        //--------
        if (!marked[j]) marked[j] = [];
        marked[i][j] = false;
        //--------
    }
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

visited.add(x + "," + y);

//run logic
//check for map bounds
while (x-1 >= 0 && x+1 < map.length && y-1 >= 0 && y+1 < map[x].length) {
    //check if checking forward doesnt go outside of bound
    if (x+(dir_rot[dir_idx][0]) < 0 || x+(dir_rot[dir_idx][0]) >= map.length || y+(dir_rot[dir_idx][1]) < 0 || y+(dir_rot[dir_idx][1]) >= map[x].length) {
    } else {
        if (map[x+(dir_rot[dir_idx][0])][y+(dir_rot[dir_idx][1])] == "#") {
            dir_idx = (dir_idx + 1) % 4;
        }
    }
    marked[x][y] = true;
    x += dir_rot[dir_idx][0];
    y += dir_rot[dir_idx][1];
    if (!(x + "," + y in visited)) {
        visited.add(x + "," + y);
    }
    

}
marked[x][y] = true;


for (let i = 0; i < map.length; i++) {
    for (let j = 0; j < map[i].length; j++) {
        process.stdout.write(marked[i][j] ? 'X' : map[i][j]);
    }
    process.stdout.write('\n');
}

console.log(visited.size);