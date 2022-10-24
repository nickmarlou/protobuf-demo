from fastapi import APIRouter

from .endpoints import address_book

api_router = APIRouter()
api_router.include_router(
    address_book.router, prefix="/address-book", tags=["address-book"]
)
