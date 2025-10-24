import { useState } from "react";
import { motion } from "framer-motion";

export default function FlashCard({ question, answer }) {
  const [flipped, setFlipped] = useState(false);

  return (
    <div className="w-full aspect-[3/2] perspective cursor-pointer">
      <motion.div
        className="w-full h-full relative rounded-xl shadow-lg"
        onClick={() => setFlipped(!flipped)}
        animate={{ rotateY: flipped ? 180 : 0 }}
        transition={{ duration: 0.7, ease: "easeInOut" }}
        style={{ transformStyle: "preserve-3d" }}
      >
        <div className="absolute w-full h-full backface-hidden bg-white text-gray-900 flex items-center justify-center rounded-xl p-4 text-center">
          {question}
        </div>

        <div className="absolute w-full h-full backface-hidden bg-blue-600 text-white flex items-center justify-center rounded-xl p-4 text-center rotate-y-180">
          {answer}
        </div>
      </motion.div>
    </div>
  );
}
