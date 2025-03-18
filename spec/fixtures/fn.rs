pub fn fib(n : u64) -> u64 {
    if n <= 1 {
        1
    } else {
        fib(n - 1) + fib(n - 2)
    }
}

pub async fn async_fib(n : u64) -> u64 {
    if n <= 1 {
        1
    } else {
        fib(n - 1).await + fib(n - 2).await
    }
}

fn priv_fib(n: u64) -> u64 {
    fib(n)
}

async fn async_priv_fib(n: u64) -> u64 {
    async_fib(n)
}

fn generic_fib<T>(n : T) -> T {
    todo!()
}

fn generic_constrained_fib<T : Clone>(n : T) -> T {
    todo!()
}

fn generic_where_constrained_fib<T>(n : T) -> T where T : Clone {
    todo!()
}

fn lifetime_fib<'a>(n: &'a u64) -> u64 {
    todo!()
}
