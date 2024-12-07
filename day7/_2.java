import java.nio.file.Files;
import java.nio.file.Paths;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.ArrayList;

public class _2 {
    public static void main(String[] args) {
        HashMap<Long, Long[]> lineMap = new HashMap<>();

        try {
            List<String> lines = Files.readAllLines(Paths.get("7.txt"));
            for (int i = 0; i < lines.size(); i++) {
                String[] parts = lines.get(i).split(":");
                String[] parts2 = parts[1].split(" ");

                parts[0] = parts[0].strip();
                parts[1] = parts[1].strip();

                //convert parts2 to list of longs
                ArrayList<Long> parts2LongList = new ArrayList<>();
                for (String part : parts2) {
                    part = part.strip();
                    if (!part.equals("")) {
                        parts2LongList.add(Long.parseLong(part));
                    }
                }

                Long[] parts2Long = parts2LongList.toArray(new Long[0]);
                lineMap.put(Long.parseLong(parts[0]), parts2Long);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        Long output = 0L;

        for (long key : lineMap.keySet()) {
            Long[] values = lineMap.get(key);
            Set<Long> results = new HashSet<>();
            generateCombinations(values, 0, values[0], results);

            if (results.contains(key)) {
                output += key;
            }
        }

        System.out.println(output);
    }

    //rececursive function to generate all combinations of sums, products, and concats
    private static void generateCombinations(Long[] values, int index, long currentResult, Set<Long> results) {
        if (index == values.length - 1) {
            results.add(currentResult);
            return;
        }

        //bruteforce all combos
        //sum
        generateCombinations(values, index + 1, currentResult + values[index + 1], results);

        //product
        generateCombinations(values, index + 1, currentResult * values[index + 1], results);

        //concat
        long concatenatedValue = Long.parseLong(currentResult + "" + values[index + 1]);
        generateCombinations(values, index + 1, concatenatedValue, results);
    }
}