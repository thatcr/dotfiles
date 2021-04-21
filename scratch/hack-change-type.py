"""Hack the object header to forcefully change the type.

We want this so we can upcast a tuple to something richer.
This only works in cpython, and we rely on id() returning the object pointer, and
no trace headers added to the python build.
"""
# %%
import inspect
from ctypes import Structure, c_ulong, c_voidp, cast, POINTER


# %%
class MegaTuple(tuple):
    def __new__(cls, func, *args):
        return tuple.__new__(cls, (func,) + args)

    def __repr__(self):
        sig = inspect.signature(self[0])
        bound = sig.bind(*self[1:])
        bound.apply_defaults()

        return (
            f"{func.__module__}.{func.__qualname__}("
            + ", ".join(f"{k}={v!r}" for k, v in bound.arguments.items())
            + ")"
        )


def f(a, b, c=1, d=3):
    return a + b + c + d


t = (f, 1, 2, 3, 4)
t2 = MegaTuple(f, 1, 2, 3, 4)

# Hack the python header - unless HEAD_EXTRA is used...
# typedef struct _object {
#     _PyObject_HEAD_EXTRA
#     Py_ssize_t ob_refcnt;
#     PyTypeObject *ob_type;
# } PyObject;


class PyObject(Structure):
    _fields_ = [("ob_refcnt", c_ulong), ("ob_type", c_voidp)]


# get the header from the tuple
pt = cast(c_voidp(id(t)), POINTER(PyObject))

# reassignt he ob
pt[0].ob_type = cast(id(MegaTuple), c_voidp)

assert repr(t) == repr(t2)

print(repr(t), repr(t2))

print(type(t), type(t2))


# %%
