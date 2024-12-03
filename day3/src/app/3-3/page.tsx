"use client";

import { useState } from "react";

export default function Home() {
  const [inputValue, setInputValue] = useState("");
  const [result, setResult] = useState("");

  const handleSubmit = (event: React.FormEvent) => {
    event.preventDefault();

    // Define the regex pattern to match 'mul(num,num)', 'do()', and 'dont()' with the global flag
    const regex = /mul\((\d+),(\d+)\)|do\(\)|don't\(\)/g;
    const matches = inputValue.matchAll(regex);

    const results = [];

    var enabled = true;

    for (const match of matches) {
      if (match[0].startsWith("mul") && enabled) {
        const num1 = parseInt(match[1], 10);
        const num2 = parseInt(match[2], 10);
        results.push(num1 * num2);
      }
      if (match[0] === "do()") {
        enabled = true;
      }
      else if  (match[0] === "don't()") {
        enabled = false;
      }
    }

    // Condense the results array into a string, adding them together if they are numbers
    const numericResults = results.filter((item) => typeof item === "number");
    const sum = numericResults.reduce((a, b) => a + b, 0);
    const stringResults = results.filter((item) => typeof item === "string");

    setResult(`Sum: ${sum}`);
  };

  return (
    <div>
      <title>Day 3 Pt. 1</title>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={inputValue}
          onChange={(e) => setInputValue(e.target.value)}
          placeholder="Enter your input"
        />
        <button type="submit">Submit</button>
      </form>
      {result && <p>{result}</p>}
    </div>
  );
}