# vim-encloser

A plugin for using `Enter` to close unbalaned brackets in cursorline

![](https://raw.githubusercontent.com/mapkts/vim-encloser/master/screenshot.gif)

## Features

- Can close three types of brackets: `{` `(` `[`
- Brackets inside quoted string like `"{(["` `'{([` are escaped by default
- Brackets inside comments like `// {` `/* { */` are escaped by default

## Examples


```js
sort_by('hello', function (x) {|
```

will expand to the following after pressing enter ( | stands for cursor position)

```js
sort_by('hello', function (x) {
  |
})
```

Brackets inside quoted string are automatically escaped

```rust
println!("brackets: {{([ {} {}"|
```

will only expand to

```rust
println!("brackets: {{([ {} {}"
    |
)
```

Brackets inside quoted comments will not be expanded

```rust
// {([|
```

```rust
// {([
// |
```

```rust
/*
 * {([|
```

```rust
/*
 * {([
 * |
```

## Installation

Install this plugin using [vim-plug], add this to your `~/.vimrc`:

[vim-plug]: https://github.com/junegunn/vim-plug

```vim
Plug 'mapkts/vim-encloser'
```

## Customization

- Encloser will only close brackets for supported languages ([see-here]), but you can enable it
  global by putting `let g:encloser_enable_global = 1` in your vimrc.

[see-here]: https://github.com/mapkts/vim-encloser/blob/master/plugin/encloser.vim

- Some language allow you define arbitrary syntax (like Rust's macros), you can temporarily disable
this plugin by calling `:EncloserToggle` in current buffer. And yes, calling `:EncloserToggle` will
enable it again. If you toggle Encloser on and off a lot, create a mapping for this command is
recommended.

```vim
nnoremap <leader>te :EncloserToggle<CR>
```

#### License

<sup>
Licensed under either of <a href="LICENSE-APACHE">Apache License, Version
2.0</a> or <a href="LICENSE-MIT">MIT license</a> at your option.
</sup>

<br>

<sub>
Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in this crate by you, as defined in the Apache-2.0 license, shall
be dual licensed as above, without any additional terms or conditions.
</sub>
