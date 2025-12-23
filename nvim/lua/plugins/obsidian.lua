return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = {
    event = {
      "BufReadPre ~/Library/Mobile Documents/iCloud~md~obsidian/Documents/PKM/*.md",
      "BufNewFile ~/Library/Mobile Documents/iCloud~md~obsidian/Documents/PKM/*.md",
      "BuffReadPre /Users/nrd/vaults/PKM/*.md",
      "BuffNewFile /Users/nrd/vaults/PKM/*.md",
      "BuffReadPre /Users/nrd/vaults/Notebook/*.md",
      "BuffNewFile /Users/nrd/vaults/Notebook/*.md",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      name = "personal",
      path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/PKM",
    },
  },
}
