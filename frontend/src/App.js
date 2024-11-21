import React, { useState } from "react";
import { ethers } from "ethers";

function App() {
  const [balance, setBalance] = useState("");
  const [threshold, setThreshold] = useState("");
  const [proof, setProof] = useState(null);

  const generateProof = async () => {
    try {
      // Генерация доказательства
      const input = { balance, threshold };
      const response = await fetch("http://localhost:8000/generate-proof", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(input),
      });
      const data = await response.json();
      setProof(data);
    } catch (error) {
      console.error("Ошибка генерации доказательства", error);
    }
  };

  const verifyProof = async () => {
    try {
      const response = await fetch("http://localhost:8000/verify", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(proof),
      });
      const result = await response.json();
      alert(result.valid ? "Доказательство верно" : "Доказательство неверно");
    } catch (error) {
      console.error("Ошибка проверки доказательства", error);
    }
  };

  return (
    <div>
      <h1>ZKHold</h1>
      <div>
        <label>Баланс:</label>
        <input value={balance} onChange={(e) => setBalance(e.target.value)} />
      </div>
      <div>
        <label>Минимум (Threshold):</label>
        <input
          value={threshold}
          onChange={(e) => setThreshold(e.target.value)}
        />
      </div>
      <button onClick={generateProof}>Сгенерировать доказательство</button>
      <button onClick={verifyProof}>Проверить доказательство</button>
    </div>
  );
}

export default App;
