from enum import Enum


class Domain(str, Enum):
    ADDRESS_BOOK = "address_book"


class Event(str, Enum):
    ADD_PERSON = "add_person"


class AddressBookTopic(str, Enum):
    ADD_PERSON = f"{Domain.ADDRESS_BOOK}__{Event.ADD_PERSON}"
