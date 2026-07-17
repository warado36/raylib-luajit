local rl = require("ffibindings")

-- Defines and Macros
local GRAVITY         = 0.0
local MAX_SPEED       = 20.0
local CROUCH_SPEED     = 5.0
local JUMP_FORCE      = 12.0
local MAX_ACCEL      = 150.0
local FRICTION         = 0.86
local AIR_DRAG         = 0.98
local CONTROL         = 15.0
local CROUCH_HEIGHT    = 0.0
local STAND_HEIGHT     = 1.0
local BOTTOM_HEIGHT    = 0.5
local NORMALIZE_INPUT  = 0

-- Global Variables
local sensitivity = { 0.001, 0.001 }
local player = {
    position = { x = 0, y = 0, z = 0 },
    velocity = { x = 0, y = 0, z = 0 },
    dir = { x = 0, y = 0, z = 0 },
    isGrounded = false
}
local lookRotation = { 0, 0 }
local headTimer = 0.0
local walkLerp = 0.0
local headLerp = STAND_HEIGHT
local lean = { 0, 0 }

-- Module Functions Definition
function UpdateBody(body, rot, side, forward, jumpPressed, crouchHold)
    local input = { x = side, y = -forward }
    
    if NORMALIZE_INPUT ~= 0 then
        if (side ~= 0) and (forward ~= 0) then
            local len = math.sqrt(input.x^2 + input.y^2)
            if len > 0 then
                input.x = input.x / len
                input.y = input.y / len
            end
        end
    end
    
    local delta = rl.GetFrameTime()
    
    if not body.isGrounded then
        body.velocity.y = body.velocity.y - GRAVITY * delta
    end
    
    if body.isGrounded and jumpPressed then
        body.velocity.y = JUMP_FORCE
        body.isGrounded = false
    end
    
    local front = { x = math.sin(rot), y = 0, z = math.cos(rot) }
    local right = { x = math.cos(-rot), y = 0, z = math.sin(-rot) }
    local desiredDir = {
        x = input.x * right.x + input.y * front.x,
        y = 0.0,
        z = input.x * right.z + input.y * front.z
    }
    
    body.dir = rl.Vector3Lerp(body.dir, desiredDir, CONTROL * delta)
    
    local decel = (body.isGrounded and FRICTION or AIR_DRAG)
    local hvel = {
        x = body.velocity.x * decel,
        y = 0.0,
        z = body.velocity.z * decel
    }
    
    local hvelLength = math.sqrt(hvel.x^2 + hvel.z^2)
    if hvelLength < (MAX_SPEED * 0.01) then
        hvel = { x = 0, y = 0, z = 0 }
    end
    
    local speed = hvel.x * body.dir.x + hvel.z * body.dir.z
    
    local maxSpeed = (crouchHold and CROUCH_SPEED or MAX_SPEED)
    local accel = math.max(0, math.min(maxSpeed - speed, MAX_ACCEL * delta))
    
    hvel.x = hvel.x + body.dir.x * accel
    hvel.z = hvel.z + body.dir.z * accel
    
    body.velocity.x = hvel.x
    body.velocity.z = hvel.z
    
    body.position.x = body.position.x + body.velocity.x * delta
    body.position.y = body.position.y + body.velocity.y * delta
    body.position.z = body.position.z + body.velocity.z * delta
    
    if body.position.y <= 0.0 then
        body.position.y = 0.0
        body.velocity.y = 0.0
        body.isGrounded = true
    end
end

function UpdateCameraFPS(camera)
    local up = { x = 0.0, y = 1.0, z = 0.0 }
    local targetOffset = { x = 0.0, y = 0.0, z = -1.0 }
    
    local yaw = rl.Vector3RotateByAxisAngle(targetOffset, up, lookRotation[1])
    
    local maxAngleUp = rl.Vector3Angle(up, yaw)
    maxAngleUp = maxAngleUp - 0.001
    if -(lookRotation[2]) > maxAngleUp then
        lookRotation[2] = -maxAngleUp
    end
    
    local maxAngleDown = rl.Vector3Angle({ x = -up.x, y = -up.y, z = -up.z }, yaw)
    maxAngleDown = maxAngleDown * -1.0
    maxAngleDown = maxAngleDown + 0.001
    if -(lookRotation[2]) < maxAngleDown then
        lookRotation[2] = -maxAngleDown
    end
    
    local right = rl.Vector3Normalize(rl.Vector3CrossProduct(yaw, up))
    
    local pitchAngle = -lookRotation[2] - lean[2]
    pitchAngle = math.max(-math.pi/2 + 0.0001, math.min(math.pi/2 - 0.0001, pitchAngle))
    
    local pitch = rl.Vector3RotateByAxisAngle(yaw, right, pitchAngle)
    
    local headSin = math.sin(headTimer * math.pi)
    local headCos = math.cos(headTimer * math.pi)
    local stepRotation = 0.01
    
    camera.up = rl.Vector3RotateByAxisAngle(up, pitch, headSin * stepRotation + lean[1])
    
    local bobSide = 0.1
    local bobUp = 0.15
    local bobbing = rl.Vector3Scale(right, headSin * bobSide)
    bobbing.y = math.abs(headCos * bobUp)
    
    camera.position = rl.Vector3Add(camera.position, rl.Vector3Scale(bobbing, walkLerp))
    camera.target = rl.Vector3Add(camera.position, pitch)
end

function DrawLevel()
    local floorExtent = 25
    local tileSize = 5.0
    local tileColor1 = { r = 150, g = 200, b = 200, a = 255 }
    
    for y = -floorExtent, floorExtent - 1 do
        for x = -floorExtent, floorExtent - 1 do
            if (y % 2 ~= 0) and (x % 2 ~= 0) then
                rl.DrawPlane({ x = x * tileSize, y = 0.0, z = y * tileSize }, { x = tileSize, y = tileSize }, tileColor1)
            elseif (y % 2 == 0) and (x % 2 == 0) then
                rl.DrawPlane({ x = x * tileSize, y = 0.0, z = y * tileSize }, { x = tileSize, y = tileSize }, rl.Color.LIGHTGRAY)
            end
        end
    end
    
    local towerSize = { x = 16.0, y = 32.0, z = 16.0 }
    local towerColor = { r = 150, g = 200, b = 200, a = 255 }
    local towerPos = { x = 16.0, y = 16.0, z = 16.0 }
    
    rl.DrawCubeV(towerPos, towerSize, towerColor)
    rl.DrawCubeWiresV(towerPos, towerSize, rl.Color.DARKBLUE)
    
    towerPos.x = towerPos.x * -1
    rl.DrawCubeV(towerPos, towerSize, towerColor)
    rl.DrawCubeWiresV(towerPos, towerSize, rl.Color.DARKBLUE)
    
    towerPos.z = towerPos.z * -1
    rl.DrawCubeV(towerPos, towerSize, towerColor)
    rl.DrawCubeWiresV(towerPos, towerSize, rl.Color.DARKBLUE)
    
    towerPos.x = towerPos.x * -1
    rl.DrawCubeV(towerPos, towerSize, towerColor)
    rl.DrawCubeWiresV(towerPos, towerSize, rl.Color.DARKBLUE)
    
    rl.DrawSphere({ x = 300.0, y = 300.0, z = 0.0 }, 100.0, { r = 255, g = 0, b = 0, a = 255 })
end

-- Program main entry point
do
    local screenWidth = 800
    local screenHeight = 450
    
    rl.InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera fps")
    
    -- Initialize camera variables
    local camera = {
        fovy = 60.0,
        projection = rl.CameraProjection.CAMERA_PERSPECTIVE,
        position = {
            x = player.position.x,
            y = player.position.y + (BOTTOM_HEIGHT + headLerp),
            z = player.position.z
        },
        target = { x = 0, y = 0, z = 0 },
        up = { x = 0, y = 1, z = 0 }
    }
    
    UpdateCameraFPS(camera)
    rl.DisableCursor()
    rl.SetTargetFPS(60)
    
    while not rl.WindowShouldClose() do
        -- Update
        local mouseDelta = rl.GetMouseDelta()
        lookRotation[1] = lookRotation[1] - mouseDelta.x * sensitivity[1]
        lookRotation[2] = lookRotation[2] + mouseDelta.y * sensitivity[2]
        
        local sideway = (rl.IsKeyDown(rl.KeyboardKey.KEY_D) and 1 or 0) - (rl.IsKeyDown(rl.KeyboardKey.KEY_A) and 1 or 0)
        local forward = (rl.IsKeyDown(rl.KeyboardKey.KEY_W) and 1 or 0) - (rl.IsKeyDown(rl.KeyboardKey.KEY_S) and 1 or 0)
        local crouching = rl.IsKeyDown(rl.KeyboardKey.KEY_LEFT_CONTROL)
        
        UpdateBody(player, lookRotation[1], sideway, forward, rl.IsKeyPressed(rl.KeyboardKey.KEY_SPACE), crouching)
        
        local delta = rl.GetFrameTime()
        headLerp = rl.Lerp(headLerp, (crouching and CROUCH_HEIGHT or STAND_HEIGHT), 20.0 * delta)
        
        camera.position = {
            x = player.position.x,
            y = player.position.y + (BOTTOM_HEIGHT + headLerp),
            z = player.position.z
        }
        
        if player.isGrounded and ((forward ~= 0) or (sideway ~= 0)) then
            headTimer = headTimer + delta * 3.0
            walkLerp = rl.Lerp(walkLerp, 1.0, 10.0 * delta)
            camera.fovy = rl.Lerp(camera.fovy, 55.0, 5.0 * delta)
        else
            walkLerp = rl.Lerp(walkLerp, 0.0, 10.0 * delta)
            camera.fovy = rl.Lerp(camera.fovy, 60.0, 5.0 * delta)
        end
        
        lean[1] = rl.Lerp(lean[1], sideway * 0.02, 10.0 * delta)
        lean[2] = rl.Lerp(lean[2], forward * 0.015, 10.0 * delta)
        
        UpdateCameraFPS(camera)
        
        -- Draw
        rl.BeginDrawing()
        rl.ClearBackground(rl.Color.RAYWHITE)
        
        rl.BeginMode3D(camera)
        DrawLevel()
        rl.EndMode3D()
        
        -- Draw info box
        rl.DrawRectangle(5, 5, 330, 75, rl.ColorAlpha(rl.Color.SKYBLUE, 0.5))
        rl.DrawRectangleLines(5, 5, 330, 75, rl.Color.BLUE)
        rl.DrawText("Camera controls:", 15, 15, 10, rl.Color.BLACK)
        rl.DrawText("- Move keys: W, A, S, D, Space, Left-Ctrl", 15, 30, 10, rl.Color.BLACK)
        rl.DrawText("- Look around: arrow keys or mouse", 15, 45, 10, rl.Color.BLACK)
        rl.DrawText(string.format("- Velocity Len: (%06.3f)", math.sqrt(player.velocity.x^2 + player.velocity.z^2)), 15, 60, 10, rl.Color.BLACK)
        
        rl.EndDrawing()
    end
    
    rl.CloseWindow()
end


