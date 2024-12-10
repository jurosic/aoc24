import 'dart:io';

class PathKeeper{
    int paths = 0;
    List<List<int>> ends = [];

    PathKeeper() {
        paths = 0;
        ends = [];
    }

    void addPath() {
        paths++;
    }

    void addEnd(int x, int y) {
        ends.add([x, y]);
    }

    bool checkEnd(int x, int y) {
        for (var i = 0; i < ends.length; i++) {
            if (ends[i][0] == x && ends[i][1] == y) {
                return true;
            }
        }
        return false;
    }

    int getPaths() {
        return paths;
    }
}

void main() {
    var file = File('10.txt');
    var lines = file.readAsLinesSync();

    var input = [];

    for (var line in lines) {
        var temp = [];
        for (var i = 0; i < line.length; i++) {
            temp.add(int.parse(line[i]));
        }
        input.add(temp);
    }


    var sum = 0;

    for (var i = 0; i < input.length; i++) {
        for (var j = 0; j < input[i].length; j++) {
            if (input[i][j] == 0) {
                var pk = PathKeeper();
                traverse(input, i, j, 0, pk);
                //print(pk.getPaths());
                sum += pk.getPaths();
            }
        }
    }


    printList(input, [0,0]);

    print(sum);
}

void traverse(List list, int x, int y, int nextstep, PathKeeper pathKeeper) {
    if (x < 0 || x >= list.length || y < 0 || y >= list[0].length) {
        return;
    }

    if (list[x][y] == 9 && nextstep == 9) {
        if (pathKeeper.checkEnd(x, y)) {
            return;
        }
        //print('x: $x, y: $y, nextstep: $nextstep');
        //print("path");
        //printList(list, [x, y]);
        pathKeeper.addPath();
        //pathKeeper.addEnd(x, y);
        return;
    }

    if (list[x][y] == nextstep) {
        //print('x: $x, y: $y, nextstep: $nextstep');
        //printList(list, [x, y]);
        traverse(list, x + 1, y, nextstep+1, pathKeeper);
        traverse(list, x - 1, y, nextstep+1, pathKeeper);
        traverse(list, x, y + 1, nextstep+1, pathKeeper);
        traverse(list, x, y - 1, nextstep+1, pathKeeper);
    }
}

void printList(List list, List highlight) {
    for (var i = 0; i < list.length; i++) {
        for (var j = 0; j < list[i].length; j++) {
            if (highlight != null) {
                if (i == highlight[0] && j == highlight[1]) {
                    stdout.write('X');
                } else {
                    stdout.write(list[i][j]);
                }
            } else {
                stdout.write(list[i][j]);
            }
        }
        stdout.write('\n');
    }
}