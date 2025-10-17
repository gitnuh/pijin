import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function DeckList() {
    const [decks, setDecks] = useState([]);
    const [title, setTitle] = useState("");
    const [description, setDescription] = useState("");
    const navigate = useNavigate();

    useEffect(() => {
        fetch("http://localhost:8000/decks/")
            .then((res) => res.json())
            .then(setDecks);
    }, []);

    const createDeck = async () => {
        const res = await fetch("http://localhost:8000/decks/", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ title, description }),
        });
        const data = await res.json();
        setDecks([...decks, data]);
        setTitle("");
        setDescription("");
    };

    return (
        <div>
            <h1 className="text-2xl mb-4">Your Decks</h1>
            <div className="flex gap-2 mb-6">
                <input
                    className="p-2 rounded bg-gray-800"
                    placeholder="Deck title"
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                />
                <input
                    className="p-2 rounded bg-gray-800"
                    placeholder="Description"
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                />
                <button onClick={createDeck} className="bg-blue-600 px-4 rounded">
                    Add
                </button>
            </div>

            <div className="grid gap-4">
                {decks.map((deck) => (
                    <div
                        key={deck.deck_id}
                        onClick={() => navigate(`/decks/${deck.deck_id}`)}
                        className="p-4 bg-gray-800 rounded cursor-pointer hover:bg-gray-700"
                    >
                        <h2 className="text-xl font-semibold">{deck.title}</h2>
                        <p className="text-gray-400">{deck.description}</p>
                    </div>
                ))}
            </div>
        </div>
    );
}
