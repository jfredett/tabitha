impl Standard {
    pub const BAR: usize = 4321;


    pub fn method2(&self, arg: String) {
        todo!();
    }

    pub fn struct_method(arg: isize) -> isize {
        todo!();
    }

    fn generic_struct_method<X>(arg: X) -> X {
        arg
    }
}

impl MultipleBoundedGeneric<T, U> where T : Copy, U : Clone {
    fn method1(&self) {
        todo!();
    }
}
