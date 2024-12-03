"use client";

import Image from "next/image";
import styles from "./page.module.css";

export default function Home() {
  return (
    //create link to /3
    <div className={styles.container}>
      <title>Home</title>
      <h1>Day 3 Pt. 1</h1>
      <button onClick={() => window.location.href = "/3"}>Go to Page 3</button>
      <h1>Day 3 Pt. 2</h1>
      <button onClick={() => window.location.href = "/3-3"}>Go to Page 3-3</button>
    </div>
      

  );
}
