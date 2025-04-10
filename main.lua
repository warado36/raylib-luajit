-- LuaJit 

-- NOTE: imports
local fii = require("ffi")

local rl = require("ffibindings")

-- declarations
local OPT_WIDTH = 220
local MARGIN_SIZE = 8
local COLOR_SIZE = 16

function DrawTextureTiled(texture, source, dest, origin, rotation, scale, tint)
    if ((texture[1] <= 0) or (scale <= 0.0)) then return end
    if ((source[3] == 0) or (source[4] == 0)) then return end
    
    local tileWidth, tileHeight = source[3]*scale, source[4]*scale
    if ((dest[3] < tileWidth) and (dest.height < tileHeight)) then
        rl.DrawTexturePro(
            texture, 
            {
                source[1],
                source[2],
                (dest[3]/tileWidth)*source[3],
                (dest[4]/tileHeight)*source[4]
            },
            {
                dest[1],
                dest[2],
                dest[3],
                dest[4]
            },
            orgin,
            rotation,
            tint
        )
    elseif (dest[3] <= tileWidth) then
        local dy = 0
        while dy + tileHeight < dest.height do
            DrawTexturePro(
                texture, 
                {
                    source[1], 
                    source[2], 
                    (dest[3]/tileWidth) * source[3], 
                    source[4]
                },
                {   
                    dest[1], 
                    dest[2] + dy, 
                    dest[3], 
                    tileHeight
                },
                origin, 
                rotation, 
                tint
            )
            dy = dy + tileHeight
        end

        if dy < dest.height then
            DrawTexturePro(
                texture, 
                {
                    source[1],
                    source[2], 
                    (dest[3]/tileWidth) * source[3], 
                    ((dest[4] - dy)/tileHeight) * source[4]
                },
                {
                    dest[1], 
                    dest[1] + dy, 
                    dest[3], dest[4] - dy
                },
                origin, 
                rotation, 
                tint
            )
        end
    elseif (dest[4] <= tileHeight) then
        dx = 0
        fo
    end
end
--
do -- main
    local screenWidth = 800
    local screenHeight = 450

    rl.SetConfigFlags(rl.ConfigFlags.FLAG_WINDOW_RESIZABLE)
    rl.InitWindow(screenWidth, screenHeight, "raylib [textures] example - Draw part of a texture tiled")
    
    local texPattern = rl.LoadTexture("resources/patterns.png")
    rl.SetTextureFilter(texPattern, rl.TextureFilter.TEXTURE_FILTER_TRILINEAR)

    local rePattern = {
        {  3.0,   3.0,  66.0,  66.0 },
        { 75.0,   3.0, 100.0, 100.0 },
        {  3.0,  75.0,  66.0,  66.0 },
        {  7.0, 156.0,  50.0,  50.0 },
        { 85.0, 106.0,  90.0,  45.0 },
        { 75.0, 154.0, 100.0,  60.0 },
    }

    local colors = {
        rl.Color.BLACK   , 
        rl.Color.MAROON  , 
        rl.Color.ORANGE  , 
        rl.Color.BLUE    , 
        rl.Color.PURPLE  , 
        rl.Color.BEIGE   , 
        rl.Color.LIME    , 
        rl.Color.RED     , 
        rl.Color.DARKGRAY, 
        rl.Color.SKYBLUE
    }
    local MAX_COLORS = #colors
    local colorRec = {}
    for i=1, MAX_COLORS do
        colorRec[i] = {0.0, 0.0, 0.0, 0.0}
    end
    
    local x, y = 0, 0
    for i=1, MAX_COLORS do
        colorRec[i] = {
            2.0 + MARGIN_SIZE + x,
            22.0 + 256 + MARGIN_SIZE + y,
            COLOR_SIZE * 2.0,
            COLOR_SIZE
        }

        if i == (MAX_COLORS/2 -1) then
            x = 0
            y = y + COLOR_SIZE + MARGIN_SIZE
        else 
            x = x + (COLOR_SIZE*2 + MARGIN_SIZE)
        end
    end

    local activePattern, activeCol = 0, 0
    local scale, rotation = 1.0, 0.0

    rl.SetTargetFPS(60)
    
    while not rl.WindowShouldClose() do
        if rl.IsMouseButtonPressed(MOUSE_BUTTON_LEFT) then
            local mouse = rl.GetMousePosition()

            for i=1, #recPattern do
                if rl.CheckCollisionPointRec(mouse, {
                     2 + MARGIN_SIZE + recPattern[i][1],
                    40 + MARGIN_SIZE + rePattern[i][2],
                    recPattern[i][3],
                    recPattern[i][4]
                }) then

                    activePattern = i
                    break
                
                end
            end
            
            for i=1, #MAX_COLORS do
                if rl.CheckCollisionPointRec(mouse, colorRec[i]) then
                    activeCol = i
                    break
                end
            end
        end

        if rl.IsKeyPressed(KEY_UP) then scale = scale + 0.25 end
        if rl.IsKeyPressed(KEY_DOWN) then scale = scale - 0.25
        elseif scale <= 0.0 then scale = 0.25 end

        if rl.IsKeyPressed(KEY_LEFT) then scale = scale - 0.25 end
        if rl.IsKeyPressed(KEY_RIGHT) then scale = scale + 0.25 end

        if rl.IsKeyPressed(KEY_SPACE) then rotation, scale = 0.0, 1.0 end

        rl.BeginDrawning() 
        do
            rl.ClearBackground(rl.Color.RAYWHITE)
            
            rl.DrawTextureTiled(texPattern, recPattern[activePattern], {
                OPT_WIDTH + MARGIN_SIZE,
                MARGIN_SIZE,
                rl.GetScreenWidth() - OPT_WIDTH - 2.0*MARGIN_SIZE,
                rl.GetScreenHeight() - 2.0*MARGIN_SIZE
            }, {0.0, 0.0}, rotation, scale, colors[activeCol])
            
            rl.DrawRectangle(
                MARGIN_SIZE, 
                MARGIN_SIZE, 
                OPT_WIDTH - MARGIN_SIZE, 
                rl.GetScreenHeight() - 2*MARGIN_SIZE, 
                ColorAlpha(rl.Color.LIGHTGRAY, 0.5)
            )

            rl.DrawText(
                "Select Pattern", 
                2 + MARGIN_SIZE, 
                30 + MARGIN_SIZE, 
                10, 
                rl.Color.BLACK
            )
            rl.DrawTexture(
                texPattern,
                2 + MARGIN_SIZE, 
                40 + MARGIN_SIZE, 
                rl.Color.BLACK
            )
            rl.DrawRectangle(
                2 + MARGIN_SIZE + recPattern[activePattern][1], 
                40 + MARGIN_SIZE + recPattern[activePattern][2],
                recPattern[activePattern][3],
                recPattern[activePattern][4],
                rl.ColorAlpha(rl.Color.DARKBLUE, 0.3)
            )

            rl.DrawText(
                "Select Color",
                2+MARGIN_SIZE,
                10+256+MARGIN_SIZE,
                10,
                rl.Color.BLACK
            )
            for i=1, MAX_COLORS do
                rl.DrawRectangleRec(colorRec[i], colors[i])
                if activeCol == i then
                    rl.DrawRectangleLinesEx(
                        colorRec[i],
                        3,
                        rl.ColorAlpha(
                            rl.Color.WHITE, 
                            0.5
                        )
                    )
                end
            end
            
            rl.DrawText(
                "Scale (UP/DOWN to change)", 
                2 + MARGIN_SIZE, 
                80 + 256 + MARGIN_SIZE, 
                10, 
                rl.Color.BLACK
            )
            rl.DrawText(
                rl.TextFormat("%.2fx", scale), 
                2 + MARGIN_SIZE, 
                92 + 256 + MARGIN_SIZE, 
                20, 
                rl.Color.BLACK
            )

            rl.DrawText(
                "Rotation (LEFT/RIGHT to change)", 
                2 + MARGIN_SIZE, 
                122 + 256 + MARGIN_SIZE, 
                10, 
                rl.Color.BLACK
            )
            rl.DrawText(
                TextFormat("%.0f degrees", rotation), 
                2 + MARGIN_SIZE, 
                134 + 256 + MARGIN_SIZE, 
                20, 
                rl.Color.BLACK
            )

            rl.DrawText(
                "Press [SPACE] to reset", 
                2 + MARGIN_SIZE, 
                164 + 256 + MARGIN_SIZE, 
                10, 
                rl.Color.DARKBLUE
            )

            rl.DrawText(
                TextFormat("%i FPS", GetFPS()), 
                2 + MARGIN_SIZE, 
                2 + MARGIN_SIZE, 
                20, 
                rl.Color.BLACK
            )
        end
        rl.EndDrawing()
    
    end

    rl.UnloadTexture(texPattern)

    rl.CloseWindow()

end

