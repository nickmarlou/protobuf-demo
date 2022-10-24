from enum import IntEnum

from pydantic import BaseModel, EmailStr


class GroupEnum(IntEnum):
    FAMILY = 0
    FRIENDS = 1
    COWORKERS = 2


class Person(BaseModel):
    name: str
    email: EmailStr
    phone: str
    group: GroupEnum = GroupEnum.FRIENDS
