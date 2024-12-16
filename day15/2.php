<?php
//never doing something willfully in php again

function readMap($filename) {
    $file = fopen($filename, 'r');
    $map = [];
    while ($line = fgets($file)) {
        if ($line === "\n") {
            break;
        }
        $row = [];
        foreach (str_split(trim($line)) as $char) {
            if ($char === "O") {
                $row[] = "[";
                $row[] = "]";
            } elseif ($char === "@") {
                $row[] = "@";
                $row[] = ".";
            } else {
                $row[] = $char;
                $row[] = $char;
            }
        }
        $map[] = $row;
    }
    fclose($file);
    return $map;
}

function readCommands($filename) {
    $file = fopen($filename, 'r');
    $commands = "";
    $rc = false;
    while ($line = fgets($file)) {
        if ($line === "\n") {
            $rc = true;
            continue;
        }
        if ($rc) {
            $commands .= trim($line);
        }
    }

    fclose($file);
    return $commands;
}

function findStartingPos($map) {
    for ($i = 0; $i < count($map); $i++) {
        for ($j = 0; $j < count($map[0]); $j++) {
            if ($map[$i][$j] == "@") {
                return [$i, $j];
            }
        }
    }
}

function findBoxes($map) {
    $boxLocations = [];
    for ($i = 0; $i < count($map); $i++) {
        for ($j = 0; $j < count($map[0]); $j++) {
            if ($map[$i][$j] == "[") {
                $boxLocations[] = [$i, $j];
            }
        }
    }
    return $boxLocations;
}

function canShiftBox($map, $i, $j, $di, $dj, &$checked) {
    if (in_array([$i, $j], $checked)) {
        return true;
    }
    $checked[] = [$i, $j];

    $new_i = $i + $di;
    $new_j = $j + $dj;

    if ($map[$new_i][$new_j] == "#") {
        return false;
    } elseif ($map[$new_i][$new_j] == "[") {
        return canShiftBox($map, $new_i, $new_j, $di, $dj, $checked) && canShiftBox($map, $new_i, $new_j + 1, $di, $dj, $checked);
    } elseif ($map[$new_i][$new_j] == "]") {
        return canShiftBox($map, $new_i, $new_j, $di, $dj, $checked) && canShiftBox($map, $new_i, $new_j - 1, $di, $dj, $checked);
    }
    return true;
}

function isPositionValid($map, $i, $j) {
    return 0 <= $i && $i < count($map) && 0 <= $j && $j < count($map[0]) && $map[$i][$j] != "#";
}

function run(&$map, $i, $j, $command) {
    if ($command == "^"){
        $di = -1;
        $dj = 0;
    } elseif ($command == "v") {
        $di = 1;
        $dj = 0;
    } elseif ($command == "<") {
        $di = 0;
        $dj = -1;
    } elseif ($command == ">") {
        $di = 0;
        $dj = 1;
    }

    $new_i = $i + $di;
    $new_j = $j + $dj;

    if (!isPositionValid($map, $new_i, $new_j)) {
        return [$i, $j];
    }

    if ($map[$new_i][$new_j] == "[" or $map[$new_i][$new_j] == "]") {
        $checked = [];

        if (!canShiftBox($map, $i, $j, $di, $dj, $checked)) {
            return [$i, $j];
        }

        while (count($checked) > 0) {
            foreach ($checked as $key => $pos) {
                list($box_i, $box_j) = $pos;
                $new_box_i = $box_i + $di;
                $new_box_j = $box_j + $dj;
                if (!in_array([$new_box_i, $new_box_j], $checked)) {
                    if ($map[$new_box_i][$new_box_j] != "@" && $map[$box_i][$box_j] != "@") {
                        $map[$new_box_i][$new_box_j] = $map[$box_i][$box_j];
                        $map[$box_i][$box_j] = ".";
                    }
                    unset($checked[$key]);
                }
            }
        }

        $map[$i][$j] = $map[$new_i][$new_j];
        $map[$new_i][$new_j] = "@";
        return [$new_i, $new_j];
    }

    $map[$i][$j] = ".";
    $map[$new_i][$new_j] = "@";
    return [$new_i, $new_j];
}

$expanded_map = readMap("15.txt");
$commands = readCommands("15.txt");

list($robot_i, $robot_j) = findStartingPos($expanded_map);
foreach (str_split($commands) as $command) {
    list($robot_i, $robot_j) = run($expanded_map, $robot_i, $robot_j, $command);
}

$total_score = 0;
foreach (findBoxes($expanded_map) as $box) {
    list($box_i, $box_j) = $box;
    $total_score += 100 * $box_i + $box_j;
}

echo $total_score . "\n";

?>