// Trait with associated types
trait AssociatedType {
    type Item;
    fn get(&self) -> &Self::Item;
}

// Trait with default methods
trait WithDefaultMethods {
    fn greet(&self) {
        println!("Hello!");
    }
}

// Trait with generic methods
trait GenericTrait<T> {
    fn add(&self, other: T) -> T;
}

// Trait with lifetime bounds
trait LifetimeBounded<'a> {
    fn read(&self) -> &'a str;
}

// Trait with multiple trait bounds
trait TraitWithMultipleBounds<T>: Clone + Greet {
    fn subtract(&self, other: T) -> T;
}

// Trait with bounded associated type
trait ComplexTrait {
    type Item: Clone + Debug;
    fn get(&self) -> &Self::Item;
}

// Trait with default methods and multiple generics
trait MultiGenericDefault<T, U> {
    fn greet(&self, value1: T, value2: U) {
        println!("Hello with values {:?} and {:?}", value1, value2);
    }
}

// Trait with generic methods, lifetime bounds, and where clause
trait GenericWithLifetime<'a, T>
where
    T: 'a,
{
    fn add(&self, other: &'a T) -> T;
}

// Trait with multiple trait items
trait FullTrait<T, U>: Clone + Copy {
    type Item: Debug;

    fn multiply(&self, value1: T, value2: U) -> Self::Item;
    fn subtract(&self, value1: T, value2: U) -> Self::Item;
}

// Trait combining all features
trait MegaTrait<T : Bar, U : Baz>: Clone + Copy + Math<U> + Reader<'static>
where
    T: Debug,
    U: Add<Output = U>,
{
    type Item: Debug;

    fn get(&self) -> &Self::Item;
    fn multiply(&self, value1: T, value2: U) -> Self::Item;
    fn subtract(&self, other: &'static str) -> &'static str;
}
