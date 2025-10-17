import { useState } from "react";
import FlashCard from "./FlashCard";

export default function DeckReview({ flashcards }) {
  const [index, setIndex] = useState(0);
  const card = flashcards[index];

  const next = () => {
    if (index < flashcards.length - 1) setIndex(index + 1);
  };

  const prev = () => {
    if (index > 0) setIndex(index - 1);
  };

  if (!flashcards.length)
    return (
      <p className="text-center text-gray-300">No flashcards available.</p>
    );

  return (
    <div className="flex flex-col items-center gap-4">
      {/* FlashCard display */}
      <FlashCard question={card.question} answer={card.answer} />

      {/* Navigation */}
      <div className="flex items-center gap-4 mt-4">
        <button
          onClick={prev}
          disabled={index === 0}
          className="px-4 py-2 bg-gray-600 rounded disabled:opacity-50"
        >
          Previous
        </button>
        <span className="text-gray-300">
          {index + 1} / {flashcards.length}
        </span>
        <button
          onClick={next}
          disabled={index === flashcards.length - 1}
          className="px-4 py-2 bg-gray-600 rounded disabled:opacity-50"
        >
          Next
        </button>
      </div>
    </div>
  );
}
