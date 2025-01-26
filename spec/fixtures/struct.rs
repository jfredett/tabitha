struct NestedWhereBound<T, U> where T: Foo<U>, U : Bar {
    field1: T,
}

struct NestedBound<T : Foo<U>, U> {
    field1: T,
}

struct MultipleBoundedWhereGeneric<T, U> where
    T: Copy,
    U: Clone
{
    field1: T,
    field2: U,
}

pub struct Standard {
    pub field1: u32,
    field2: i32,
}

pub struct WeirdEmpty {
}

struct GenericStruct<T> {
    pub field1: T,
    field2: i32,
}

pub struct MultipleGeneric<T, U> {
    pub field1: T,
    field2: U,
}

struct BoundedWhereGeneric<T> where T: Copy {
    field1: T,
}

pub struct BoundedGeneric<T : Copy> {
    field1: T,
}

struct MultipleBoundedGeneric<T : Copy, U : Clone> {
    field1: T,
    field2: U,
}

pub struct MultiplyBoundedSingleGeneric<T> where T: Copy + Clone {
    field1: T,
}

struct ZST;
struct Inner;

struct StructWithStruct {
    pub field1: Inner,
}
