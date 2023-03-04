local reservedWords = { "break", "case", "catch", "class", "const", "continue", "debugger", "default", "delete", "do", "else", "export", "extends", "false", "finally", "for", "function", "if", "import", "in", "instanceof", "new", "null", "return", "super", "switch", "this", "throw", "true", "try", "typeof", "var", "void", "while", "with", "let", "static", "yield", "await" }

-- Format a Lua table as a JavaScript object literal
local function formatTable(table)
  local str = "{ "
  for k, v in pairs(table) do
    if k == v then
      str = str .. k .. ", "
    else
      str = str .. k .. ": " .. v .. ", "
    end
  end
  return str .. "}"
end

-- Format a string so that it is a valid JavaScript variable identifier.
local function formatVariableName(str)
  -- variable names cannot contain spaces (replace with underscores)
  local name = string.gsub(str, " ", "_")

  -- variable names cannot be reserved words
  for _, reservedWord in pairs(reservedWords) do
    if name == reservedWord then
      name = "_" .. name
      break
    end
  end

  local start = name:sub(1, 1)

  -- variable names cannot start with numbers (use a _ prefix)
  if start >= "0" and start <= "9" then
    name = "_" .. name
  end

  return name
end

-- Export the sprite as a PNG with the slices defined in an adjacent TypeScript file.
local function exportSpriteSheet(spr)
  local texturePath = string.gsub(spr.filename, ".aseprite$", ".png")
  local modulePath = string.gsub(spr.filename, ".aseprite$", ".ts")
  local importUrl = "./" .. texturePath:match("^.+/(.+)$")

  local lines = {
    "// Generated by 'Export TypeScript Sprites' Aseprite Extension",
    string.format('import url from "%s"', importUrl),
  }

  for _, slice in ipairs(spr.slices) do
    local props = {
      url="url",
      x=slice.bounds.x,
      y=slice.bounds.y,
      w=slice.bounds.width,
      h=slice.bounds.height,
    }

    if slice.center then
      props.center = formatTable{
        x=slice.center.x,
        y=slice.center.y,
        w=slice.center.width,
        h=slice.center.height,
      }
    end

    if slice.pivot then
      props.pivot = formatTable{
        x=slice.pivot.x,
        y=slice.pivot.y,
      }
    end

    if slice.data then
      props.data = '"' .. slice.data .. '"'
    end

    local line = string.format(
      'export const %s = %s;',
      formatVariableName(slice.name),
      formatTable(props)
    )

    table.insert(lines, line)
  end

  local src = table.concat(lines, "\n")
  local file = io.open(modulePath, "w")

  if file then
    file:write(src)
    file:close()
  end

  app.command.ExportSpriteSheet{
    ui=false,
    textureFilename=texturePath,
  }
end

function init(plugin)
  plugin:newCommand{
    id="ExportTypeScriptSprites",
    title="Export TypeScript",
    group="file_export",
    onclick=function()
      exportSpriteSheet(app.activeSprite)
    end
  }
end
