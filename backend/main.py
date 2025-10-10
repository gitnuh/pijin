from fastapi import FastAPI, Depends, HTTPException, Path
from sqlalchemy import Column, Integer, String, Text, ForeignKey, DateTime, create_engine, func
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship, Session
from pydantic import BaseModel
import uvicorn

DATABASE_URL = "sqlite:///./flashcards.db"

engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)
Base = declarative_base()

# ---------------------
# Database Models
# ---------------------
class Deck(Base):
    __tablename__ = "decks"
    deck_id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(Text)
    flashcards = relationship("Flashcard", back_populates="deck", cascade="all, delete")


class Flashcard(Base):
    __tablename__ = "flashcards"
    card_id = Column(Integer, primary_key=True, index=True)
    deck_id = Column(Integer, ForeignKey("decks.deck_id", ondelete="CASCADE"), nullable=False)
    question = Column(Text, nullable=False)
    answer = Column(Text, nullable=False)
    mnemonic = Column(Text)
    is_ai_generated = Column(Integer, default=0)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    deck = relationship("Deck", back_populates="flashcards")


# ---------------------
# Pydantic Schemas
# ---------------------
class FlashcardBase(BaseModel):
    question: str
    answer: str
    mnemonic: str | None = None
    is_ai_generated: int | None = 0


class FlashcardCreate(FlashcardBase):
    pass


class FlashcardRead(FlashcardBase):
    card_id: int
    deck_id: int
    created_at: str
    updated_at: str

    class Config:
        orm_mode = True


# ---------------------
# FastAPI setup
# ---------------------
app = FastAPI(title="Smart Study Flashcards API")

Base.metadata.create_all(bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# ---------------------
# CRUD Endpoints
# ---------------------

@app.post("/decks/{deck_id}/flashcards/", response_model=FlashcardRead)
def create_flashcard(deck_id: int, flashcard: FlashcardCreate, db: Session = Depends(get_db)):
    deck = db.query(Deck).filter(Deck.deck_id == deck_id).first()
    if not deck:
        raise HTTPException(status_code=404, detail="Deck not found")

    new_card = Flashcard(deck_id=deck_id, **flashcard.dict())
    db.add(new_card)
    db.commit()
    db.refresh(new_card)
    return new_card


@app.get("/decks/{deck_id}/flashcards/", response_model=list[FlashcardRead])
def get_flashcards(deck_id: int, db: Session = Depends(get_db)):
    cards = db.query(Flashcard).filter(Flashcard.deck_id == deck_id).all()
    return cards


@app.get("/flashcards/{card_id}", response_model=FlashcardRead)
def get_flashcard(card_id: int = Path(...), db: Session = Depends(get_db)):
    card = db.query(Flashcard).filter(Flashcard.card_id == card_id).first()
    if not card:
        raise HTTPException(status_code=404, detail="Flashcard not found")
    return card


@app.put("/flashcards/{card_id}", response_model=FlashcardRead)
def update_flashcard(card_id: int, flashcard: FlashcardBase, db: Session = Depends(get_db)):
    card = db.query(Flashcard).filter(Flashcard.card_id == card_id).first()
    if not card:
        raise HTTPException(status_code=404, detail="Flashcard not found")

    for key, value in flashcard.dict(exclude_unset=True).items():
        setattr(card, key, value)
    db.commit()
    db.refresh(card)
    return card


@app.delete("/flashcards/{card_id}")
def delete_flashcard(card_id: int, db: Session = Depends(get_db)):
    card = db.query(Flashcard).filter(Flashcard.card_id == card_id).first()
    if not card:
        raise HTTPException(status_code=404, detail="Flashcard not found")
    db.delete(card)
    db.commit()
    return {"detail": "Flashcard deleted successfully"}

if __name__ == "__main__":
    uvicorn.run(app)
