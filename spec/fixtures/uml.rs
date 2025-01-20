/* In this file: something with a nice looking UML diagram -- don't mind that it's a little (lot)
 * non-idiomatic and entirely useless noise, I'm more concerned with exercising the syntax 
 *
 * It's worth noting that while the USDA does not provide this certification, this Markov-esque
 * nonsense _would_ be Certified 100% USDA Prime _Human_ nonsense, not a lick of AI here friends.
 * */

struct Example<T : Copy + PartialEq> {
    pub pub_field: T,
    private_field: Vec<usize>
}

impl Example<String> {

    pub fn go(&self) -> bool {
        true
    }

    fn stop(&mut self) {
        todo!();
    }
}

impl<T> Example<T> where T : Copy {
    pub fn fax(&self, message: &T, ch: Channel) {
        ch.send_facsimile(*message);
    }
}

impl<T : Copy + Default> Example<T> {
    pub fn fax_spam(&self, ch: Channel) {
        ch.send_facimile(T::default());
    }
}

impl<T : Copy + PartialEq + Default> Default for Example<T> {
    fn default() -> Self {
        Example {
            pub_field: T::default(),
            private_field: vec![]
        }
    }
}
