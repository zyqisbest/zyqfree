# zyqfree

dont use this idk what it is anymore

Roblox script hub UI powered by the [Kavo UI Library](https://github.com/xHeptc/Kavo-UI-Library).

## Project structure

| File | Description |
|------|-------------|
| `free` | Main Roblox executor script (Lua) |
| `config.lua` | Testable module – constants, URLs, toggle logic |
| `test_config.lua` | Unit tests (luaunit) |
| `luaunit.lua` | Test framework (vendored) |

## Running tests

```bash
# Requires Lua 5.3+
lua5.3 test_config.lua -v
```
