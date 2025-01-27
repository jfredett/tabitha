impl Standard {
    const FOO: i32 = -1234;

    pub fn method1(&self) -> Vec<usize> {
    }

    pub fn generic_method<T>(&self, t: T) -> T {
        t
    }
}

impl MultipleBoundedGeneric<T, U> where T : Copy, U : Clone {
    const TCONST: Option<T> = None;

    fn method1(&self, t: T, u: U) -> (T, U) {
        (t, u)
    }

    pub fn method2(&self) {

    }
}

impl<T : Copy, U : Clone> for MultipleBoundedGeneric<T, U> {
    const ANOTHER_CONST: () = ();
}

impl Default for Standard {
    fn default() -> Self {
    }
}

impl<T> Foo<T> for Standard {
    fn bar(&self) -> Self {
    }
}

impl<T : Copy, U : Clone> Foo<T> for MultipleBoundedGeneric<T, U> {

    fn generic() {

    }
}
