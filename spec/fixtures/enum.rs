enum Simple {
    VariantA,
    VariantB
}

enum WithVariantArg {
    VariantArgA(isize),
    VariantArgB(usize, bool),
    VariantNoArg
}

pub enum WithNamedArgs {
    VariantArgA { field1: isize },
    VariantArgB { field1: usize, field2: bool }
}

// This is invalid, actually.
// pub enum EmptyEnum;

// This isn't, though.
pub enum WeirdEmptyEnum {

}

pub enum GenericEnum<T> {
    Variant(T)
}

pub enum GenericBoundedEnum<T : Copy> {
    Variant(T)
}

pub enum GenericWhereBoundedEnum<T> where T : Copy {
    Variant(T),
    None
}

pub enum GenericBoundedEnumWithNamedField<T : Copy> {
    Variant { field1: T },
    None
}

