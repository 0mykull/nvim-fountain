# nvim-fountain

一个现代化的 Neovim 插件，用于 [Fountain](https://fountain.io/) 剧本标记语言，分叉自 Carson Fire 的 [vim-fountain](http://www.vim.org/scripts/script.php?script_id=3880)。

## 功能

- Fountain 剧本格式的语法高亮
- 场景标题之间的导航
- 常用剧本编写任务的键盘快捷键
- 剧本统计（场景数量、角色出现次数等）
- 导出为 PDF、HTML 和 Final Draft 格式
- 兼容 Neovim 和 LazyVim

## 关于 Fountain

Fountain 是一种用于剧本编写的纯文本标记语言。该格式可以转换为 Final Draft 文件 (FDX) 和 HTML，并可被 Final Draft 和 Movie Magic 导入。

官方 [Fountain 网站](https://fountain.io/) 包含有用的资料，包括示例剧本和应用程序。

以下是 Fountain 发起者之一、编剧 John August 的作品 《Big Fish》 的片段：

```
EDWARD
(whispering)
Turn off your flashlights!  She'll see 'em.

MOVING UP behind the kids, we find ourselves at the gates of...

EXT.  A CREEPY OLD HOUSE - NIGHT

ADULT EDWARD (V.O.)
Now, it's common knowledge that most towns of a certain size have a witch, if only to eat misbehaving children and the occasional puppy who wanders into her yard.  Witches use those bones to cast spells and curses that make the land infertile.
```

## 安装

### 使用 [LazyVim](https://github.com/LazyVim/LazyVim) / [lazy.nvim](https://github.com/folke/lazy.nvim)

添加到您的 LazyVim 配置（例如在 `lua/plugins/fountain.lua` 中）：

```lua
return {
  "0mykull/nvim-fountain",
  ft = "fountain",  -- 仅在 fountain 文件中延迟加载
  config = function()
    require("nvim-fountain").setup({
      -- 可选配置
      keymaps = {
        next_scene = "]]",
        prev_scene = "[[",
        uppercase_line = "<S-CR>",
      },
      -- 导出配置
      export = {
        pdf = { options = "--overwrite" },
      },
    })
  end,
}
```

### 使用 [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "0mykull/nvim-fountain",
  ft = "fountain",  -- 仅在 fountain 文件中延迟加载
  config = function()
    require("nvim-fountain").setup({
      -- 可选配置
    })
  end
}
```

### 使用 [vim-plug](https://github.com/junegunn/vim-plug)

```vim
" 在您的 init.vim 中
Plug '0mykull/nvim-fountain', {'for': 'fountain'}

" 在 plug#end() 之后添加：
augroup fountain_setup
  autocmd!
  autocmd FileType fountain lua require('nvim-fountain').setup()
augroup END
```

### 使用 Neovim 内置包管理器

```bash
# 克隆仓库
mkdir -p ~/.local/share/nvim/site/pack/plugins/start/
git clone https://github.com/0mykull/nvim-fountain.git ~/.local/share/nvim/site/pack/plugins/start/nvim-fountain
```

然后在您的 init.lua 中：

```lua
-- 初始化插件
require('nvim-fountain').setup()
```

## 配置

您可以通过向 setup 函数传递选项来定制插件。完整配置示例请参阅 [examples 目录](./examples/)。

```lua
require("nvim-fountain").setup({
  -- 键盘映射
  keymaps = {
    next_scene = "]]",
    prev_scene = "[[",
    uppercase_line = "<S-CR>",
  },

  -- 导出设置
  export = {
    -- 默认导出目录（nil 表示与源文件相同）
    output_dir = nil,

    -- PDF 导出选项
    pdf = {
      options = "--overwrite",
    },
  },

  -- 如果可用，启用 treesitter 集成
  use_treesitter = true,
})
```

## 命令

### 编辑与导航

- `:FountainStats` - 显示剧本统计信息（场景数、角色出现次数等）
- `:FountainFormat` - 格式化当前的 fountain 文档

### 导出

- `:FountainExportPDF [filename]` - 导出为 PDF（可选文件名）

## 默认快捷键

- `]]` - 跳转到下一个场景标题
- `[[` - 跳转到上一个场景标题
- `<S-CR>` - 将当前行转换为大写并跳转至下一行

## 剧本统计

`:FountainStats` 命令提供关于剧本的有用信息：

- 总场景数
- 角色列表及其出现次数
- 对话行和动作行数
- 总行数

这有助于跟踪剧本的结构和角色平衡。

## 导出

导出功能需要安装 [afterwriting](https://github.com/ifrost/afterwriting-labs/blob/master/docs/clients.md)：

```bash
npm install -g afterwriting
```

安装完成后，您可以使用导出命令将 Fountain 剧本转换为 PDF：

- PDF: `:FountainExportPDF [optional-filename.pdf]`

## 示例文件

本插件包含示例文件以帮助您上手：

- `examples/template.fountain`: 演示 Fountain 语法的示例剧本
- `examples/lazyvim_config.lua`: 针对 LazyVim 用户的配置示例
- `examples/standalone_config.lua`: 适用于任何 Neovim 设置的直接配置示例

使用模板：

```bash
cp examples/template.fountain ~/my-screenplay.fountain
nvim ~/my-screenplay.fountain
```

## 贡献

欢迎贡献！请参阅 [examples/COMMIT_MESSAGE.md](./examples/COMMIT_MESSAGE.md) 文件了解为现代化此插件而所做的更改摘要。
