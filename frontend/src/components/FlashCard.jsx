import { useState } from "react";
import { motion } from "framer-motion";
import "./FlashCard.css";

export default function FlashCard({ question, answer }) {
  const [flipped, setFlipped] = useState(false);

  return (
    <div className="flashcard-container">
      <motion.div
        className="flashcard"
        onClick={() => setFlipped(!flipped)}
        animate={{ rotateY: flipped ? 180 : 0 }}
        transition={{ duration: 0.7, ease: "easeInOut" }}
        style={{ transformStyle: "preserve-3d", perspective: 1000 }}
      >
        <div className="front">{question}</div>
        <div className="back">{answer}</div>
      </motion.div>
    </div>
  );
}
