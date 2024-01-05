# A Hobby

Mainly garbage.

## Prerequisites:

- Treesitter.
- Neovim on path (I'm using nightly).
- Some language runtimes on path, else some of the tooling probs ain't going to work.
- Lua & luarocks & stylua on path if faffing around is required.
- A font patched with powerline symbols set in yr terminal I guess.

Assumes Linux of some kind, probably works on other setups if it's put somewhere
Neovim expects it to be.

## Setup

1. Clone to the where the hobby expects its config to live:
    ```
    git clone https://github.com/sutorio/rabbit_hole.git ~/.config/nvim
    ```

2. Open it.
3. It will take a while to do the first setup.
4. Run `:Lazy` to update/sync plugins.
5. Run `:Mason` to add/update/sync LSP-related stuff.
