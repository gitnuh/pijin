# The pijins

AI flashcard + productivity app for students


# Setup

Clone the repository with 
```
git clone https://github.com/gitnuh/pijin.git
cd pijin
```

Install Python 3.10+, Node.js 18+, and Ollama. After installing Ollama, pull the model. Ensure Ollama is running on port 11434 in the background.

```
    ollama pull llama3.2
    ollama serve
```
To start the backend, enter the backend directory, create a virtual environment, install the requirements, and run the server:
```
    cd backend
    python3 -m venv venv
    source venv/bin/activate
    pip install -r ../requirements.txt
    python3 main.py
```

To start the frontend, move into its directory, install the dependencies, and launch the development server:
```
    cd frontend
    npm install
    npm run dev
```
The frontend runs on port 5173 and communicates with the backend on port 8000.

The backend uses a local SQLite database (`flashcards.db`) following the schema in `Schema.sql`.
