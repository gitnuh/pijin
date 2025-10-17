import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import DeckList from "./components/DeckList";
import DeckDetail from "./components/DeckDetail";
import DeckReview from "./components/DeckReview";

export default function App() {
  return (
    <Router>
      <div className="min-h-screen bg-gray-900 text-white p-8">
        <header className="mb-8">
          <Link to="/" className="text-3xl font-bold">
            Smart Study
          </Link>
        </header>
        <Routes>
          <Route path="/" element={<DeckList />} />
          <Route path="/decks/:deckId" element={<DeckDetail />} />
          <Route path="/decks/:deckId/review" element={<DeckReview />} />
        </Routes>
      </div>
    </Router>
  );
}
