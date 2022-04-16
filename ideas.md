* commas and newlines are analogous everywhere, even inside array literals. This actually solves the issue of trailing commas by not needing commas at all

* .. in Haskell list is very nice as well

* 48-bit integers and pointers. Large enough to index into the full address space in most 64-bit CPUs, yet small enough to fit inside IEEE-754 double NaN space. Small overhead, just ((value << 16) >> 16) to normalize them in a 64-bit register. Most 64-bit operations are unchanged after normalizing.


===

1) Sum types which have named fields. I.e. if in Haskell you have

data SumType = A Int Double | B String
then in my language it's going to be

data SumType = A {x: Int y: Double } | B {name: String}
so then when pattern matching, you don't have to make up the names in every pattern:

match v {
    A => print v.x
    B => print v.name
}
Since a sum type is defined at most once, and matched on at least once, I feel that this is going to be a net win.

2) Pattern matches with multiple tags get access to an intersection of fields. I stole this one from Rust because it's so brilliant. So if you have a sum type like

 data SumType = A {name: String, otherField: Int } | B {name: String, somethingElse: Array[Double] }
then in a pattern match you can match on A | B and get access to name: String because it's present in both variants:

match v {
    A | B => print v.name 
}
3) Subtyping for sum types. You can declare that a sum type has a subset of another one's tags:

data SuperType = A {x: Int } | B {y: Double} | C

data SubType = subtypeOf SuperType { A B }
Then every function accepting SuperType will also accept SubType, but some functions may only accept SubType. This is good for code reuse as you can write a function that requires a SubType (representing a validated value that doesn't contain an error variant) that is free to call functions taking SuperType even though some of the checks in those functions will be redundant.

===

* %% n means % n == 0


===

Named implementations. Ex.

struct complex:
    a: f32
    b: f32

impl naive of complex:
    fn __add__(l, r):
        ...
impl smart of complex:
    fn __add__(l, r):
        ...
This might be a minor feature, but it has fairly big consequences. One is in managing contexts:

using naive:
    do something with naive implementation of any type
using complex::smart:
    do something with smart implementation of complex only
You could have implementations named cpu and nvidia and then do something like.

using cpu:
    do stuff on cpu
using nvidia:
    do stuff on an nvidia GPU
I find it a nice way to avoid making your functions full of branching, since currently the using keyword can be resolved on compile-time and can functionally acts as an IFmacro

===
