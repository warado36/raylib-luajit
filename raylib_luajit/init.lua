-- raylib-luajit: LuaJIT FFI bindings for raylib
--
-- Usage:
--   local rl = require("raylib_luajit")
--   rl.InitWindow(800, 600, "Hello")
--   rl.Vector2:new(10, 20)
--   rl.Color.RAYWHITE

-- Bootstrap: add this module's directory to package.path so that
-- require("raylib_luajit.ffibindings") and other submodules resolve correctly.
-- This also allows require("raylib_luajit") to work from any subdirectory
-- (e.g. examples/) when the user adds the parent dir to package.path.
local src = debug.getinfo(1, "S").source
if src:sub(1, 1) == "@" then
    local dir = src:sub(2):match("^(.*/)")
    if dir then
        local pattern = dir .. "?.lua"
        -- Avoid adding duplicates
        if not package.path:find(pattern, 1, true) then
            package.path = pattern .. ";" .. package.path
        end
    end
end


return require("ffibindings")