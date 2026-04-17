return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    keys = {
      { "zR", function() require("ufo").openAllFolds() end,                              desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end,                             desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds({ "comment" }) end,         desc = "Open folds except comments" },
    },
    opts = {
      provider_selector = function(_, filetype, buftype)
        if buftype ~= "" then return "" end
        local ft_map = {
          python     = { "lsp", "indent" },
          go         = { "lsp", "indent" },
          lua        = { "lsp", "indent" },
          sh         = { "lsp", "indent" },
          markdown   = { "treesitter", "indent" },
          javascript = { "lsp", "indent" },
          typescript = { "lsp", "indent" },
        }
        return ft_map[filetype] or { "lsp", "indent" }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d lines"):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "UfoFoldedEllipsis" })
        return newVirtText
      end,
    },
  },
}
