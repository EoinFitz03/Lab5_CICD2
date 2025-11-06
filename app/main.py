from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import engine
from app.models import Base

# Replacing @app.on_event("startup")
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Create database tables on startup
    Base.metadata.create_all(bind=engine)
    yield


# Initialize FastAPI with lifespan context
app = FastAPI(lifespan=lifespan)

# CORS configuration (dev-friendly; tighten for production)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   # Allow all origins for development
    allow_methods=["*"],
    allow_headers=["*"],
)
