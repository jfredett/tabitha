# Tabitha

![Tabitha](assets/tabitha.png)


!!! WARNING
    This is a _prototype_, if you use it and complain, you're very silly and I _will_ tease you about it.

Tabitha is a prototype tree-sitter query tool for Rust code. It may eventually extend to other languages. It's primary
purpose is to facilitate the drawing of `PlantUML` diagrams and also to more generally be a framework for querying 
across a codebase.

## Goals

- Completeness
    - Should cover as much of the core rust language as possible, in an ergonomic way.
- Flexibility
    - Should be able to answer any question an LSP can answer, except worse, more limited, and slower.
- Extensibility
    - Should allow for relatively easy expansion to create other kinds of diagrams or other data.

## Non-goals

- Speed
    - This is not going to be a quick thing, it's single-threaded by force due to ruby, and it's never likely to be
    quick. That's okay, it's a prototype for the eventual rewrite in rust.
- Completeness
    - _Do I contradict myself? Very well, then I contradict myself, I am large, I contain multitudes._ Rust is a big
    language, and by nature treesitter is a kind of approximate parser, so there will likely be unsupported features,
    I'm not going to sweat them.
- Broad Support
    - I don't care about any language other than Rust at the moment. I _may_ extend the model to Ruby someday, and maybe
      to Nix. I doubt it'll go much further than whatever my daily drivers are.
    - I also don't need it to support every possible crate structure, code organization schema, or other thing. If your
      projects don't look like mine, you're probably SOL.

## Usage

```shell
tabitha /path/to/source/directory
```

will drop you in a repl where you can whatever you like. You probably should just run this from the root of your crate,
a la:

```shell
tabitha .
```

You can also provide a script to run, like so:

```shell
tabitha . --with my_script.rb
```

This will bypass the repl and run your script in the `Tabitha` context. Tabitha will index your code, and you can use

## Contributing

I suppose you can if you like. Try to write code you think is good, make sure it's tested, and try to make it read like
the code around it.

## License

See [LICENSE](LICENSE.md)
