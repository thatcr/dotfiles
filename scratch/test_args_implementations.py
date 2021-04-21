"""Compare ways to represent function arguments."""

import inspect
from collections import namedtuple
from dataclasses import dataclass
from typing import Optional

import pytest


def func(a, b, c=1, d=None):
    return a + b + c + d


func.__sig__ = inspect.signature(func)

FuncArgsNamedTuple = namedtuple("FuncArgsNamedTuple", ["a", "b", "c", "d"])


@dataclass(unsafe_hash=True, frozen=True)
class FuncArgsDataClass:
    a: int
    b: int
    c: int = 1
    d: Optional[int] = None


class FuncArgsSlots:
    __slots__ = ["a", "b", "c", "d"]

    def __init__(self, a, b, c, d):
        self.a = a
        self.b = b
        self.c = c
        self.d = d


class FuncArgsDerivedNamedTuple(FuncArgsNamedTuple):
    pass


def plain_tuple(*args):
    return (func,) + args


def direct_tuple(a, b, c, d):
    return (a, b, c, d)


class DerivedTuple(tuple):
    def __new__(cls, *args):
        return tuple.__new__(cls, (func,) + args)

    def __repr__(self):
        func = self[0]
        bound = func.__sig__.bind(*self[1:])
        bound.apply_defaults()

        return (
            f"{func.__module__}.{func.__qualname__}("
            + ", ".join(f"{k}={v!r}" for k, v in bound.arguments.items())
            + ")"
        )


impls = [
    FuncArgsNamedTuple,
    FuncArgsDataClass,
    FuncArgsDerivedNamedTuple,
    plain_tuple,
    direct_tuple,
    DerivedTuple,
    FuncArgsSlots,
]


def test_namedtuple():
    # this is bad - distinct named tuple types have the same hash value
    assert FuncArgsNamedTuple(1, 2, 3, 4) == (1, 2, 3, 4)
    assert hash(FuncArgsNamedTuple(1, 2, 3, 4)) == hash((1, 2, 3, 4))

    # assert FuncArgsNamedTuple(1, 2, d=4) == (1, 2, 3, 4)

    d = {FuncArgsNamedTuple(1, 2, 3, 4): 123}

    assert FuncArgsNamedTuple(1, 2, 3, 4) in d


def test_dataclass():
    assert FuncArgsDataClass(1, 2, 3, 4) != (1, 2, 3, 4)
    assert FuncArgsDataClass(1, 2, 3, 4) == FuncArgsDataClass(1, 2, 3, 4)
    assert hash(FuncArgsDataClass(1, 2, 3, 4)) == hash(FuncArgsDataClass(1, 2, 3, 4))

    d = {FuncArgsDataClass(1, 2, 3, 4): 123}
    assert FuncArgsDataClass(1, 2, 3, 4) in d


@pytest.mark.parametrize("impl", impls)
def test_construction(benchmark, impl):
    benchmark(impl, 1, 2, 3, 4)


@pytest.mark.parametrize("impl", impls)
def test_hash(benchmark, impl):
    inst = impl(1, 2, 3, 4)
    benchmark(hash, inst)


@pytest.mark.parametrize("impl", impls)
def test_repr(benchmark, impl):
    inst = impl(1, 2, 3, 4)
    benchmark(repr, inst)
