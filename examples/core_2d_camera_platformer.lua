-- raylib [core] example - 2d camera platformer
-- Example complexity rating: [★★★☆] 3/4
-- Example originally created with raylib 2.5, last time updated with raylib 3.0
-- Example contributed by arvyy (@arvyy) and reviewed by Ramon Santamaria (@raysan5)
-- Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
-- BSD-like license that allows static linking with closed source software
-- Copyright (c) 2019-2025 arvyy (@arvyy)

local rl = require("ffibindings")

local G = 400
local PLAYER_JUMP_SPD = 350.0
local PLAYER_HOR_SPD = 200.0

----------------------------------------------------------------------------------
-- Module Functions Declaration
----------------------------------------------------------------------------------

local function UpdatePlayer(player, envItems, envItemsLength, delta)
    if rl.IsKeyDown(rl.KeyboardKey.KEY_LEFT) then
        player.position.x = player.position.x - PLAYER_HOR_SPD * delta
    end
    if rl.IsKeyDown(rl.KeyboardKey.KEY_RIGHT) then
        player.position.x = player.position.x + PLAYER_HOR_SPD * delta
    end
    if rl.IsKeyDown(rl.KeyboardKey.KEY_SPACE) and player.canJump then
        player.speed = -PLAYER_JUMP_SPD
        player.canJump = false
    end

    local hitObstacle = false

    for i = 0, envItemsLength - 1 do
        local ei = envItems[i + 1]
        local p = player.position
        if ei.blocking == 1 and
           ei.rect.x <= p.x and
           ei.rect.x + ei.rect.width >= p.x and
           ei.rect.y >= p.y and
           ei.rect.y <= p.y + player.speed * delta then
            hitObstacle = true
            player.speed = 0.0
            p.y = ei.rect.y
            break
        end
    end

    if not hitObstacle then
        player.position.y = player.position.y + player.speed * delta
        player.speed = player.speed + G * delta
        player.canJump = false
    else
        player.canJump = true
    end
end

local function UpdateCameraCenter(camera, player, envItems, envItemsLength, delta, width, height)
    camera.offset = { x = width / 2.0, y = height / 2.0 }
    camera.target = player.position
end

local function UpdateCameraCenterInsideMap(camera, player, envItems, envItemsLength, delta, width, height)
    camera.target = player.position
    camera.offset = { x = width / 2.0, y = height / 2.0 }
    local minX = 1000
    local minY = 1000
    local maxX = -1000
    local maxY = -1000

    for i = 0, envItemsLength - 1 do
        local ei = envItems[i + 1]
        minX = math.min(ei.rect.x, minX)
        maxX = math.max(ei.rect.x + ei.rect.width, maxX)
        minY = math.min(ei.rect.y, minY)
        maxY = math.max(ei.rect.y + ei.rect.height, maxY)
    end

    local max = rl.GetWorldToScreen2D({ x = maxX, y = maxY }, camera)
    local min = rl.GetWorldToScreen2D({ x = minX, y = minY }, camera)

    if max.x < width then
        camera.offset.x = width - (max.x - width / 2.0)
    end
    if max.y < height then
        camera.offset.y = height - (max.y - height / 2.0)
    end
    if min.x > 0 then
        camera.offset.x = width / 2.0 - min.x
    end
    if min.y > 0 then
        camera.offset.y = height / 2.0 - min.y
    end
end

local function UpdateCameraCenterSmoothFollow(camera, player, envItems, envItemsLength, delta, width, height)
    local minSpeed = 30
    local minEffectLength = 10
    local fractionSpeed = 0.8

    camera.offset = { x = width / 2.0, y = height / 2.0 }
    local diff = rl.Vector2Subtract(player.position, camera.target)
    local length = rl.Vector2Length(diff)

    if length > minEffectLength then
        local speed = math.max(fractionSpeed * length, minSpeed)
        camera.target = rl.Vector2Add(camera.target, rl.Vector2Scale(diff, speed * delta / length))
    end
end

local function UpdateCameraEvenOutOnLanding(camera, player, envItems, envItemsLength, delta, width, height)
    local evenOutSpeed = 700
    local eveningOut = false
    local evenOutTarget

    camera.offset = { x = width / 2.0, y = height / 2.0 }
    camera.target.x = player.position.x

    if eveningOut then
        if evenOutTarget > camera.target.y then
            camera.target.y = camera.target.y + evenOutSpeed * delta
            if camera.target.y > evenOutTarget then
                camera.target.y = evenOutTarget
                eveningOut = false
            end
        else
            camera.target.y = camera.target.y - evenOutSpeed * delta
            if camera.target.y < evenOutTarget then
                camera.target.y = evenOutTarget
                eveningOut = false
            end
        end
    else
        if player.canJump and (player.speed == 0) and (player.position.y ~= camera.target.y) then
            eveningOut = true
            evenOutTarget = player.position.y
        end
    end
end

local function UpdateCameraPlayerBoundsPush(camera, player, envItems, envItemsLength, delta, width, height)
    local bbox = { x = 0.2, y = 0.2 }
    local bboxWorldMin = rl.GetScreenToWorld2D({ x = (1 - bbox.x) * 0.5 * width, y = (1 - bbox.y) * 0.5 * height }, camera)
    local bboxWorldMax = rl.GetScreenToWorld2D({ x = (1 + bbox.x) * 0.5 * width, y = (1 + bbox.y) * 0.5 * height }, camera)

    camera.offset = { x = (1 - bbox.x) * 0.5 * width, y = (1 - bbox.y) * 0.5 * height }

    if player.position.x < bboxWorldMin.x then
        camera.target.x = player.position.x
    end
    if player.position.y < bboxWorldMin.y then
        camera.target.y = player.position.y
    end
    if player.position.x > bboxWorldMax.x then
        camera.target.x = bboxWorldMin.x + (player.position.x - bboxWorldMax.x)
    end
    if player.position.y > bboxWorldMax.y then
        camera.target.y = bboxWorldMin.y + (player.position.y - bboxWorldMax.y)
    end
end

------------------------------------------------------------------------------------
-- Program main entry point
------------------------------------------------------------------------------------

local screenWidth = 800
local screenHeight = 450

rl.InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera platformer")

local player = {
    position = { x = 400, y = 280 },
    speed = 0,
    canJump = false
}

local envItems = {
    { rect = { x = 0, y = 0, width = 1000, height = 400 }, blocking = 0, color = rl.LIGHTGRAY },
    { rect = { x = 0, y = 400, width = 1000, height = 200 }, blocking = 1, color = rl.GRAY },
    { rect = { x = 300, y = 200, width = 400, height = 10 }, blocking = 1, color = rl.GRAY },
    { rect = { x = 250, y = 300, width = 100, height = 10 }, blocking = 1, color = rl.GRAY },
    { rect = { x = 650, y = 300, width = 100, height = 10 }, blocking = 1, color = rl.GRAY }
}
local envItemsLength = #envItems

local camera = {
    target = player.position,
    offset = { x = screenWidth / 2.0, y = screenHeight / 2.0 },
    rotation = 0.0,
    zoom = 1.0
}

-- Store pointers to the multiple update camera functions
local cameraUpdaters = {
    UpdateCameraCenter,
    UpdateCameraCenterInsideMap,
    UpdateCameraCenterSmoothFollow,
    UpdateCameraEvenOutOnLanding,
    UpdateCameraPlayerBoundsPush
}
local cameraOption = 0
local cameraUpdatersLength = #cameraUpdaters

local cameraDescriptions = {
    "Follow player center",
    "Follow player center, but clamp to map edges",
    "Follow player center; smoothed",
    "Follow player center horizontally; update player center vertically after landing",
    "Player push camera on getting too close to screen edge"
}

rl.SetTargetFPS(60)

--------------------------------------------------------------------------------------
-- Main game loop
while not rl.WindowShouldClose() do
    -- Update
    ----------------------------------------------------------------------------------
    local deltaTime = rl.GetFrameTime()
    UpdatePlayer(player, envItems, envItemsLength, deltaTime)

    camera.zoom = camera.zoom + (rl.GetMouseWheelMove() * 0.05)
    if camera.zoom > 3.0 then
        camera.zoom = 3.0
    elseif camera.zoom < 0.25 then
        camera.zoom = 0.25
    end

    if rl.IsKeyPressed(rl.KeyboardKey.KEY_R) then
        camera.zoom = 1.0
        player.position = { x = 400, y = 280 }
    end

    if rl.IsKeyPressed(rl.KeyboardKey.KEY_C) then
        cameraOption = (cameraOption + 1) % cameraUpdatersLength
    end

    -- Call update camera function by its pointer
    cameraUpdaters[cameraOption + 1](camera, player, envItems, envItemsLength, deltaTime, screenWidth, screenHeight)

    ----------------------------------------------------------------------------------
    -- Draw
    ----------------------------------------------------------------------------------
    rl.BeginDrawing()
        rl.ClearBackground(rl.Color.LIGHTGRAY)
        rl.BeginMode2D(camera)
            for i = 1, envItemsLength do
                rl.DrawRectangleRec(envItems[i].rect, envItems[i].color)
            end
            local playerRect = { x = player.position.x - 20, y = player.position.y - 40, width = 40.0, height = 40.0 }
            rl.DrawRectangleRec(playerRect, rl.Color.RED)
            rl.DrawCircleV(player.position, 5.0, rl.Color.GOLD)
        rl.EndMode2D()
        rl.DrawText("Controls:", 20, 20, 10, rl.Color.BLACK)
        rl.DrawText("- Right/Left to move", 40, 40, 10, rl.Color.DARKGRAY)
        rl.DrawText("- Space to jump", 40, 60, 10, rl.Color.DARKGRAY)
        rl.DrawText("- Mouse Wheel to Zoom in-out", 40, 80, 10, rl.Color.DARKGRAY)
        rl.DrawText("- R to reset position + zoom", 40, 100, 10, rl.Color.DARKGRAY)
        rl.DrawText("- C to change camera mode", 40, 120, 10, rl.Color.DARKGRAY)
        rl.DrawText("Current camera mode:", 20, 140, 10, rl.Color.BLACK)
        rl.DrawText(cameraDescriptions[cameraOption + 1], 40, 160, 10, rl.Color.DARKGRAY)
    rl.EndDrawing()
    ----------------------------------------------------------------------------------
end


rl.CloseWindow()        -- Close window and OpenGL context
