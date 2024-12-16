<?php
function scaleWarehouse($originalMap) {
    $scaledMap = [];
    foreach ($originalMap as $line) {
        $scaledLine = '';
        for ($i = 0; $i < strlen($line); $i++) {
            $tile = $line[$i];
            switch ($tile) {
                case '#':
                    $scaledLine .= '##';
                    break;
                case 'O':
                    $scaledLine .= '[]';
                    break;
                case '.':
                    $scaledLine .= '..';
                    break;
                case '@':
                    $scaledLine .= '@.';
                    break;
            }
        }
        // Repeat rows to match scaling vertically
        $scaledMap[] = $scaledLine;
        $scaledMap[] = $scaledLine;
    }
    return $scaledMap;
}

function moveRobot(&$map, $moves) {
    $robotPos = findRobot($map);

    foreach (str_split($moves) as $move) {
        $newPos = $robotPos;
        switch ($move) {
            case '<':
                $newPos = [$robotPos[0], $robotPos[1] - 2];
                break;
            case '>':
                $newPos = [$robotPos[0], $robotPos[1] + 2];
                break;
            case '^':
                $newPos = [$robotPos[0] - 2, $robotPos[1]];
                break;
            case 'v':
                $newPos = [$robotPos[0] + 2, $robotPos[1]];
                break;
        }

        if (isValidMove($map, $robotPos, $newPos)) {
            performMove($map, $robotPos, $newPos);
            $robotPos = $newPos;
        }
        // Log map state after each move
        echo "After move '$move':\n";
        foreach ($map as $line) {
            echo $line . "\n";
        }
    }
}

function findRobot($map) {
    foreach ($map as $row => $line) {
        $col = strpos($line, '@');
        if ($col !== false) {
            return [$row, $col];
        }
    }
    return null;
}

function isValidMove($map, $currentPos, $newPos) {
    $rows = count($map);
    $cols = strlen($map[0]);
    list($newRow, $newCol) = $newPos;

    if ($newRow < 0 || $newRow >= $rows || $newCol < 0 || $newCol >= $cols) {
        return false; // Out of bounds
    }

    $targetTile = substr($map[$newRow], $newCol, 2);

    if ($targetTile === '..') {
        return true; // Open space
    } elseif ($targetTile === '[]') {
        // Check if the box can be pushed
        $pushRow = $newRow + ($newRow - $currentPos[0]);
        $pushCol = $newCol + ($newCol - $currentPos[1]);

        if ($pushRow >= 0 && $pushRow < $rows && $pushCol >= 0 && $pushCol < $cols) {
            $pushTile = substr($map[$pushRow], $pushCol, 2);
            return $pushTile === '..'; // Box can be pushed to an open space
        }
    }

    return false;
}

function performMove(&$map, $currentPos, $newPos) {
    list($curRow, $curCol) = $currentPos;
    list($newRow, $newCol) = $newPos;

    $targetTile = substr($map[$newRow], $newCol, 2);

    if ($targetTile === '[]') {
        // Push the box
        $pushRow = $newRow + ($newRow - $curRow);
        $pushCol = $newCol + ($newCol - $curCol);
        $map[$pushRow] = substr_replace($map[$pushRow], '[]', $pushCol, 2);
    }

    // Move the robot
    $map[$curRow] = substr_replace($map[$curRow], '..', $curCol, 2);
    $map[$newRow] = substr_replace($map[$newRow], '@.', $newCol, 2);
}

function calculateGPS($map) {
    $gpsSum = 0;
    foreach ($map as $row => $line) {
        for ($col = 0; $col < strlen($line); $col += 2) {
            if (substr($line, $col, 2) === '[]') {
                $distanceFromTop = ($row / 2) + 1; // Account for scaling
                $distanceFromLeft = ($col / 2) + 1;
                $gpsSum += 100 * $distanceFromTop + $distanceFromLeft;
            }
        }
    }
    return $gpsSum;
}

// Read input from file
$input = file("15.txt", FILE_IGNORE_NEW_LINES);

// Separate map and moves
$originalMap = [];
$moves = "";
$readingMap = true;

foreach ($input as $line) {
    if (trim($line) === "") {
        $readingMap = false;
        continue;
    }

    if ($readingMap) {
        $originalMap[] = $line;
    } else {
        $moves .= $line; // Append moves if multiple lines
    }
}

// Scale the map
$scaledMap = scaleWarehouse($originalMap);

// Move the robot
moveRobot($scaledMap, $moves);

// Calculate GPS sum
$gpsSum = calculateGPS($scaledMap);

// Output result
echo "Sum of GPS coordinates: $gpsSum\n";
