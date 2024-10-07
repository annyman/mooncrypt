-- Stalker-X provided almost all inspiration for this camera lib, check it out
-- https://github.com/adnzzzzZ/STALKER-X

local module = {}

local function lerp(a, b, x) return a + (b - a)*x end

function module.newManager()
  local camera = {}

  -- Current and target coords
  camera.x, camera.y, camera.tx, camera.ty = 0, 0, 0, 0

  -- Always needs to be the size of the window
  camera.w = love.graphics.getWidth()
  camera.h = love.graphics.getHeight()

  camera.bounds = {}
  camera.bounds.active = false
  camera.bounds.x, camera.bounds.y = 0, 0
  camera.bounds.w, camera.bounds.h = 0, 0

  camera.deadzone = {}
  camera.deadzone.x, camera.deadzone.y = 0, 0
  camera.deadzone.w, camera.deadzone.h = 0, 0

  camera.scale = 1    -- How scaled is the camera
  camera.rotation = 0 -- How rotated is the camera

  -- How hard camera tracks the target (1 = stays right on top)
  camera.lerpX, camera.lerpY = 1, 1

  -- How much the camera gets offset from the target when moving
  camera.offsetX, camera.offsetY = 0, 0

  --                      --
  --------------------------
  -- CAMERA MANAGER CALLS --
  --------------------------
  --                      --
  function camera.attach()
    love.graphics.push()
    love.graphics.translate(camera.w/2, camera.h/2)
    love.graphics.scale(camera.scale)
    love.graphics.rotate(camera.rotation)
    love.graphics.translate(-camera.x, -camera.y)
  end

  function camera.detach()
    love.graphics.pop()
  end

  --                  --
  -- Set/Unset Values --
  --                  --
  function camera.setCoords(x, y)
    assert(type(x) == "number" or type(y) == "number", "Function 'setCoords': parameters must be a number.")
    camera.x = x
    camera.y = y
    camera.tx = x
    camera.ty = y
  end

  function camera.setTarget(x, y)
    assert(type(x) == "number" or type(y) == "number", "Function 'setTarget': parameters must be a number.")
    camera.tx = x
    camera.ty = y
  end

  function camera.setScale(s)
    assert(type(s) == "number", "Function 'setScale': parameter must be a number.")
    camera.scale = s
  end

  function camera.setRotation(r)
    assert(type(r) == "number", "Function 'setRotation': parameter must be a number.")
    camera.rotation = r
  end

  function camera.setLerp(lx, ly)
    assert(type(lx) == "number" or type(ly) == "number", "Function 'setLerp': parameters must be a number.")
    camera.lerpX = lx
    camera.lerpY = ly or lx
  end

  function camera.setOffset(lx, ly)
    assert(type(lx) == "number" or type(ly) == "number", "Function 'setOffset': parameters must be a number.")

    -- Values below 12 are basically useless, so I'm forcing higher values
    if lx > 0 then lx = lx + 11 end
    if ly and ly > 0 then ly = ly + 11 end

    camera.offsetX = lx
    camera.offsetY = ly or lx
  end

  function camera.setBounds(x, y, w, h)
    assert(type(x) == "number" or type(y) == "number", "Function 'setBounds': x and y must be a number.")
    assert(type(w) == "number" or type(h) == "number", "Function 'setBounds': w and h must be a number or nil.")

    camera.bounds.active = true

    camera.bounds.x = x
    camera.bounds.y = y

    -- force w and h, and make the minimum the camera w and h
    if w == nil or w < camera.w then w = camera.w end
    if h == nil or h < camera.h then h = camera.h end
    camera.bounds.w = w
    camera.bounds.h = h
  end

  -- A zone that doesn't push the camera
  function camera.setDeadzone(x, y, w, h)
    assert(type(x) == "number" or type(y) == "number", "Function 'setDeadZone': x and y must be a number.")
    assert(type(w) == "number" or type(h) == "number", "Function 'setDeadZone': w and h must be a number or nil.")

    camera.deadzone.x = x
    camera.deadzone.y = y

    -- Force deadzone w&h to be a max of camera w&h
    if w == nil or w > camera.w/2 then w = (camera.w/2)/camera.scale end
    if h == nil or h > camera.h/2 then h = (camera.h/2)/camera.scale end
    camera.deadzone.w = w
    camera.deadzone.h = h
  end

  function camera.unsetBounds()
    camera.bounds.active = false
  end

  function camera.unsetDeadzone()
    camera.deadzone.x = 0
    camera.deadzone.y = 0
    camera.deadzone.w = 0
    camera.deadzone.h = 0
  end

  --            --
  -- Get Values --
  --            --
  function camera.getCoords()
    return camera.x, camera.y
  end

  function camera.getSize()
    return camera.w, camera.h
  end

  function camera.getTarget()
    return camera.tx, camera.ty
  end

  function camera.getBounds()
    return camera.bounds.x, camera.bounds.y, camera.bounds.w, camera.bounds.h
  end

  function camera.getDeadzone()
    return camera.deadzone.x, camera.deadzone.y, camera.deadzone.w, camera.deadzone.h
  end

  function camera.getScale()
    return camera.scale
  end

  function camera.getRotation()
    return camera.rotation
  end

  function camera.getLerp()
    return camera.lerpX, camera.lerpY
  end

  function camera.getOffset()
    return camera.offsetX, camera.offsetY
  end

  --            --
  -- Convert To --
  --            --
  function camera.toWorldCoords(x, y)
    assert(type(x) == "number" or type(y) == "number", "Function 'toWorldCoords': parameters must be a number.")

    local cos, sin = math.cos(camera.rotation), math.sin(camera.rotation)
    x, y = (x - camera.w/2)/camera.scale, (y - camera.h/2)/camera.scale
    x, y = cos*x - sin*y, sin*x + cos*y
    return x + camera.x, y + camera.y
  end

  function camera.toCameraCoords(x, y)
    assert(type(x) == "number" or type(y) == "number", "Function 'toCameraCoords': parameters must be a number.")

    local cos, sin = math.cos(camera.rotation), math.sin(camera.rotation)
    x, y = x - camera.x, y - camera.y
    x, y = cos*x - sin*y, sin*x + cos*y
    return x*camera.scale + camera.w/2, y*camera.scale + camera.h/2
  end

  --             --
  -- Camera Loop --
  --             --
  function camera.update(dt)
    assert(type(dt) == "number", "Function 'update': parameter must be a number.")

    local scrollX, scrollY = 0, 0
    local x, y, tx, ty = camera.x, camera.y, camera.tx, camera.ty
    local dx, dy = camera.deadzone.x, camera.deadzone.y
    local dw, dh = camera.deadzone.w, camera.deadzone.h

    -- No real reason for this to be anything other than the window size.
    -- You can just use camera.scale to get the same effect as changing the size.
    camera.w = love.graphics.getWidth()
    camera.h = love.graphics.getHeight()

    -- Figure out how much the camera needs to scroll
    if tx < x + dx then scrollX = tx - ( x + dx ) end
    if tx > x + dw then scrollX = tx - ( x + dw ) end
    if ty < y + dy then scrollY = ty - ( y + dy ) end
    if ty > y + dh then scrollY = ty - ( y + dh ) end

    if not camera.otx and not camera.oty then camera.otx, camera.oty = camera.x, camera.y end
    scrollX = scrollX + (camera.tx - camera.otx)*camera.offsetX
    scrollY = scrollY + (camera.ty - camera.oty)*camera.offsetY
    camera.otx, camera.oty = camera.tx, camera.ty

    -- Move the camera smoothly
    camera.x = lerp(camera.x, camera.x + scrollX, camera.lerpX)
    camera.y = lerp(camera.y, camera.y + scrollY, camera.lerpY)

    -- Keep camera in bounds
    if camera.bounds.active then
      -- Camera is centered so offset by half camera w/h.
      camera.x = math.min(math.max(camera.x, camera.bounds.x + camera.w/2), camera.bounds.w - camera.w/2)
      camera.y = math.min(math.max(camera.y, camera.bounds.y + camera.h/2), camera.bounds.h - camera.h/2)
    end
  end

  -- Used to show debug info
  function camera.debug()
    local font = love.graphics.newFont(20)
    local x, y = camera.x*camera.scale, camera.y*camera.scale
    local dx, dy = camera.toCameraCoords(camera.deadzone.x, camera.deadzone.y)
    local dw, dh = camera.toCameraCoords(camera.deadzone.w, camera.deadzone.h)
    local tlx, tly = camera.offsetX, camera.offsetY

    if tlx > 0 then tlx = tlx - 11 end
    if tly > 0 then tly = tly - 11 end

    love.graphics.setColor(255,255,255,255)
    love.graphics.setFont(font)
    love.graphics.print("Scale: "..camera.scale, 0,0)
    love.graphics.print("OffsetX, OffsetY: "..tlx..", "..tly, 0,28)
    love.graphics.print("Rotation: "..camera.rotation, 0,56)
    love.graphics.print("LerpX, LerpY: "..camera.lerpX..", "..camera.lerpY, 0,84)
    love.graphics.setColor(255,255,255,255)
    love.graphics.setLineWidth(2)
    love.graphics.line(dx+x, dy+y, dw+x, dy+y)
    love.graphics.line(dw+x, dy+y, dw+x, dh+y)
    love.graphics.line(dw+x, dh+y, dx+x, dh+y)
    love.graphics.line(dx+x, dh+y, dx+x, dy+y)
  end

  return camera
end

return module
