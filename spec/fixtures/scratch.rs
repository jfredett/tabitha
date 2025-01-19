struct NestedConstraintWhere<T, U> where T: Foo<U>, U : Bar {
    field1: T,
}

struct NestedConstraint<T : Foo<U>, U> {
    field1: T,
}

struct MultipleConstrainedWhereGeneric<T, U> where
    T: Copy,
    U: Clone
{
    field1: T,
    field2: U,
}

struct Standard {
    pub field1: u32,
    field2: i32,
}

pub struct WeirdEmpty {
}

struct GenericStruct<T> {
    pub field1: T,
    field2: i32,
}

struct MultipleGeneric<T, U> {
    pub field1: T,
    field2: U,
}

struct ConstrainedWhereGeneric<T> where T: Copy {
    field1: T,
}

struct ConstrainedGeneric<T : Copy> {
    field1: T,
}

struct MultipleConstrainedGeneric<T : Copy, U : Clone> {
    field1: T,
    field2: U,
}

struct MultiplyConstrainedSingleGeneric<T> where T: Copy + Clone {
    field1: T,
}

struct ZST;
struct Inner;

struct StructWithStruct {
    pub field1: Inner,
}
