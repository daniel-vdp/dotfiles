-- Load nvm if node is not on PATH
if vim.fn.executable("node") == 0 then
  local nvm_dir = os.getenv("NVM_DIR") or (os.getenv("HOME") .. "/.nvm")
  local nvm_sh = nvm_dir .. "/nvm.sh"
  if vim.fn.filereadable(nvm_sh) == 1 then
    local path = vim.fn.system(string.format(
      'bash -c \'. "%s" && nvm use default --silent >/dev/null 2>&1 && echo "$PATH"\'',
      nvm_sh
    ))
    path = path:gsub("\n", "")
    if path ~= "" then
      vim.env.PATH = path
    end
  end
end

require("daniel.settings")
require("daniel.keymap")
require("daniel.autocmd")
require("daniel.lazy")
