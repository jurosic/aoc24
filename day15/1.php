<?php
function readMap($filename) {
    $file = fopen($filename, 'r');
    $map = [];
    while ($line = fgets($file)) {
        if ($line === "\n") {
            break;
        }
        $map[] = str_split(trim($line));
    }
    fclose($file);
    return $map;
}

function readCommands($filename) {
    $file = fopen($filename, 'r');
    $commands = [];
    $comln = false;
    while ($line = fgets($file)) {
        if ($line === "\n") {
            $comln = true;
            continue;
        }
        if ($comln) {
            for ($i = 0; $i < strlen($line); $i++) {
                if ($line[$i] !== "\n") {
                    $commands[] = $line[$i];
                }
            }
        }
    }
    fclose($file);
    return $commands;
}

function findStartPosition($map) {
    for ($i = 0; $i < count($map); $i++) {
        for ($j = 0; $j < count($map[$i]); $j++) {
            if ($map[$i][$j] === '@') {
                return [$i, $j];
            }
        }
    }
    return null;
}

function recurseCheckAhead(&$map, $pos, $dir) {
    $i = $pos[0];
    $j = $pos[1];
    if ($dir === '<') {
        if ($map[$i][$j - 1] === '#') {
            return false;
        }
        if ($map[$i][$j - 1] === '.') {
            $map[$i][$j] = '.';
            $map[$i][$j - 1] = 'O';
            return [$i, $j - 1];
        }
        $ret = recurseCheckAhead($map, [$i, $j - 1], $dir);
        if ($ret) {
            $map[$i][$j] = '.';
            $map[$i][$j - 1] = 'O';
            return [$i, $j - 1];
        }
        return false;
    }
    if ($dir === '^') {
        if ($map[$i - 1][$j] === '#') {
            return false;
        }
        if ($map[$i - 1][$j] === '.') {
            $map[$i][$j] = '.';
            $map[$i - 1][$j] = 'O';
            return [$i - 1, $j];
        }
        $ret = recurseCheckAhead($map, [$i - 1, $j], $dir);
        if ($ret) {
            $map[$i][$j] = '.';
            $map[$i - 1][$j] = 'O';
            return [$i - 1, $j];
        }
        return false;
    }
    if ($dir === '>') {
        if ($map[$i][$j + 1] === '#') {
            return false;
        }
        if ($map[$i][$j + 1] === '.') {
            $map[$i][$j] = '.';
            $map[$i][$j + 1] = 'O';
            return [$i, $j + 1];
        }
        $ret = recurseCheckAhead($map, [$i, $j + 1], $dir);
        if ($ret) {
            $map[$i][$j] = '.';
            $map[$i][$j + 1] = 'O';
            return [$i, $j + 1];
        }
        return false;
    }
    if ($dir === 'v') {
        if ($map[$i + 1][$j] === '#') {
            return false;
        }
        if ($map[$i + 1][$j] === '.') {
            $map[$i][$j] = '.';
            $map[$i + 1][$j] = 'O';
            return [$i + 1, $j];
        }
        $ret = recurseCheckAhead($map, [$i + 1, $j], $dir);
        if ($ret) {
            $map[$i][$j] = '.';
            $map[$i + 1][$j] = 'O';
            return [$i + 1, $j];
        }
        return false;
    }
    return false;
}

// Example usage
$filename = '15.txt';
$map = readMap($filename);
$commands = readCommands($filename);
$startPos = findStartPosition($map);

print_r($commands);

foreach ($commands as $command) {
    $newPos = recurseCheckAhead($map, $startPos, $command);
    if ($newPos !== false) {
        $startPos = $newPos;
    }
}

$map[$startPos[0]][$startPos[1]] = '@';

// Print the modified map
foreach ($map as $line) {
    echo implode('', $line) . "\n";
}

//find every O
$sum = 0;
for ($i = 0; $i < count($map); $i++) {
    for ($j = 0; $j < count($map[$i]); $j++) {
        if ($map[$i][$j] === 'O') {
            $sum += ($i*100) + $j;
        }
    }
}

echo $sum;
?>