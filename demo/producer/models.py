from pydantic import BaseModel, EmailStr


class Person(BaseModel):
    name: str
    email: EmailStr
