"use client";

import { useState } from "react";

export default function Home() {
  const [inputValue, setInputValue] = useState("");
  const [result, setResult] = useState("");

  const handleSubmit = (event: React.FormEvent) => {
    event.preventDefault();

    // Define the regex pattern to match 'mul(num,num)' with the global flag
    const regex = /mul\((\d+),(\d+)\)/g;
    const matches = inputValue.matchAll(regex);

    const results = [];
    for (const match of matches) {
      
      const num1 = parseInt(match[1], 10);
      const num2 = parseInt(match[2], 10);
      results.push(num1 * num2);
    }

    //condense the results array into a string, adding them together
    
    setResult(results.reduce((a, b) => a + b, 0).toString());
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