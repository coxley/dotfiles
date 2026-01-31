local path = vim.fn.expand("~/.local/share/last-search")

local function last_search()
  local file = io.open(path, "rb")
  if not file then 
      return nil 
  end

  local content = file:read("*a")  -- "*a" reads the entire file
  file:close()
  return content
end

local function update_search(term)
  local file, err = io.open(path, "wb")
  if not file then 
      vim.notify("failed to open last-search file: " .. err, vim.log.levels.WARN)
  else
    file:write(term)
    file:close()
  end
end

vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = { "/", "?" },
  callback = function()
    update_search(vim.fn.getreg("/"))
  end
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local last_term = last_search()
    if last_term then
        vim.opt.hlsearch = false
        vim.fn.setreg("/", last_term)
        vim.opt.hlsearch = true
    end
  end
})
