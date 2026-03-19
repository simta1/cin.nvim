# cin.nvim
A Neovim utility to reduce typing time when solving Competitive Programming problems. It scans your C++ variable declarations and automatically generates `cin >> ...;` statements.

https://github.com/user-attachments/assets/899d800b-1694-4f19-a09c-c0caa39e6731
## Requirements
- [Neovim](https://neovim.io/) 0.7+   

## Installation ([lazy.nvim](https://github.com/folke/lazy.nvim))
```lua
return {
    "simta1/cin.nvim",
    ft = "cpp",
    opts = {
        mapping = "<leader>in",
        types = {
            "int", "float", "double", "char", "bool", "string", "std::string",
            "long long", "long double",
            "ll", "ld", "ull"
        }
    },
}
```

### Configuration (`opts`)
| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `mapping` | `string`\|`boolean` | `false` | The keymap used to trigger the plugin in Normal or Visual mode. Set to a key string (e.g., `"<leader>in"`) or `false` to disable. Only active in `cpp` files. |
| `types` | `table` | `{"int", "float",...}` | A list of exact prefix strings used to identify variable declarations. Since it relies on matching the exact starting word, if you use namespaces like `std::xxx`, it must be explicitly included. You can add your custom types or macros here (e.g., `"ll"`, `"ui"`). |

## Usage
If you have configured a keymap (e.g., `mapping = "<leader>in"`), press it in **Normal mode** (for the current line) or **Visual mode** (for selected lines).
It will scan those lines for variable declarations and automatically append a `cin >> ...;` statement right after. Alternatively, you can run the `:InsertCin` command manually.

### Example

**Before:**
```cpp
int n, m;
string st;
```
Select the lines above and run `:InsertCin` (or press your map).

**After:**
```cpp
int n, m;
string st;
cin >> n >> m >> st;
```