import FlashCard from "./components/FlashCard";
import './index.css'
export default function App() {
  return (
    <div className="flex items-center justify-center h-screen bg-gray-900">
      <FlashCard question="What is the capital of France?" answer="Paris 🇫🇷" />
    </div>
  );
}
