-- vim:fileencoding=utf-8:foldmethod=marker
-- =============================================================================
-- Helpers
-- =============================================================================
--- Helper functions
-- @module helpers

local M = {}

-- {{{ Keybinding/mapping helpers
-- =============================================================================
--- Leader mapping.
-- Accepts a table mapping the binding to a table of the command (rhs),
-- description, modes/s it applies to + any additional options. The table
-- is of the form:
--
-- {
--   ["binding"] = {
--     rhs = "mapping (string/function)",
--     desc = "some description (string)",
--     mode = "mode or modes (string/list of strings)",
--     opts = "any additional options (table, optional)"
--  }
-- }
--
-- All bindings will then be set using the nvim `keymap.set` function.
--
-- @param leader_mappings
-- @return void
M.lmap = function(leader_mappings)
  for lhs, config in pairs(leader_mappings) do
    -- All of these map to the <Leader>, so prefix every lhs
    local lmap = "<Leader>" .. lhs
    -- `desc` is part of the `opts` table passed to `keymap.set`
    local options = { noremap = true, desc = config.desc }

    if config.opts then
      options = vim.tbl_extend("force", options, config.opts)
    end

    vim.keymap.set(config.mode, lmap, config.rhs, options)
  end
end
-- }}}
-- =============================================================================
-- {{{ File path helpers
-- =============================================================================
-- NOTE: these are ripped out of the Neotree plugin. There may be something
-- better built-in now.

---The file system path separator for the current platform.
M.path_separator = "/"
M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1
if M.is_windows == true then
  M.path_separator = "\\"
end

---Split string into a table of strings using a separator.
---@param inputString string The string to split.
---@param sep string The separator to use.
---@return table table A table of strings.
M.path_split = function(inputString, sep)
  local fields = {}

  local pattern = string.format("([^%s]+)", sep)
  local _ = string.gsub(inputString, pattern, function(c)
    fields[#fields + 1] = c
  end)

  return fields
end

---Joins arbitrary number of paths together.
---@param ... string The paths to join.
---@return string
M.path_join = function(...)
  local args = {...}
  if #args == 0 then
    return ""
  end

  local all_parts = {}
  if type(args[1]) =="string" and args[1]:sub(1, 1) == M.path_separator then
    all_parts[1] = ""
  end

  for _, arg in ipairs(args) do
    local arg_parts = M.path_split(arg, M.path_separator)
    vim.list_extend(all_parts, arg_parts)
  end
  return table.concat(all_parts, M.path_separator)
end
-- }}}
-- =============================================================================

return M
