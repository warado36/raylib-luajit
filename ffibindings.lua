-- NOTE: imports
ffi = require("ffi")

ffi.cdef[[
    typedef struct Vector2 {
        float x;  
        float y;  
    } Vector2;

    typedef struct Rectangle {
        float x;     
        float y;     
        float width; 
        float height;
    } Rectangle;

    typedef struct Texture { 
        unsigned int id;
        int width;      
        int height;     
        int mipmaps;    
        int format;     
    } Texture;
    typedef Texture Texture2D;

    typedef struct Color {
        unsigned char r;
        unsigned char g;
        unsigned char b;
        unsigned char a;
    } Color;

    void DrawText(const char *text, int posX, int posY, int fontSize, Color color);     
    void InitWindow(int width, int height, const char *title);
    bool WindowShouldClose(void);
    void BeginDrawing(void);
    void ClearBackground(Color color);
    void EndDrawing(void); 
    void SetConfigFlags(unsigned int flags);
    Texture2D LoadTexture(const char *fileName);
    void SetTextureFilter(Texture2D texture, int filter);
    void SetTargetFPS(int fps); 
    Vector2 GetMousePosition(void);
    bool IsMouseButtonPressed(int button);
]]
local raylib = ffi.load("./libraylib.so")
--

-- a table for all
local binds = {}
--

-- functions
function binds.DrawText(text, posX, posY, fontSize, color)
    raylib.DrawText(ffi.cast("const char*", text), posX, posY, fontSize, ffi.cast("Color", color))
end

function binds.InitWindow(width, height, title)
    raylib.InitWindow(width, height, ffi.cast("const char*", title))
end

function binds.WindowShouldClose() 
    return raylib.WindowShouldClose() 
end

function binds.BeginDrawing()
    raylib.BeginDrawing()
end

function binds.ClearBackground(color)
    raylib.ClearBackground( ffi.cast("Color", color) )
end

function binds.EndDrawing()
    raylib.EndDrawing()
end

function binds.SetConfigFlags(flags)
    raylib.SetConfigFlags(flags)
end

function binds.LoadTexture(fileName)
    return raylib.LoadTexture(ffi.cast("const char*" ,fileName))
end

function binds.SetTextureFilter(texture, filter) 
    raylib.SetTextureFilter(texture, filter)
end

function binds.SetTargetFPS(fps)
    raylib.SetTargetFPS(fps)
end

function binds.GetMousePosition()
    return raylib.GetMousePosition()
end

function binds.IsMouseButtonPressed(button)
    return raylib.IsMouseButtonPressed(button)
end


-- colors consts
binds.Color = {
    LIGHTGRAY = { 200, 200, 200, 255 } ,  
    GRAY      = { 130, 130, 130, 255 } ,  
    DARKGRAY  = { 80, 80, 80, 255 }    ,  
    YELLOW    = { 253, 249, 0, 255 }   ,  
    GOLD      = { 255, 203, 0, 255 }   ,  
    ORANGE    = { 255, 161, 0, 255 }   ,  
    PINK      = { 255, 109, 194, 255 } ,  
    RED       = { 230, 41, 55, 255 }   ,  
    MAROON    = { 190, 33, 55, 255 }   ,  
    GREEN     = { 0, 228, 48, 255 }    ,  
    LIME      = { 0, 158, 47, 255 }    ,  
    DARKGREEN = { 0, 117, 44, 255 }    ,  
    SKYBLUE   = { 102, 191, 255, 255 } ,  
    BLUE      = { 0, 121, 241, 255 }   ,  
    DARKBLUE  = { 0, 82, 172, 255 }    ,  
    PURPLE    = { 200, 122, 255, 255 } ,  
    VIOLET    = { 135, 60, 190, 255 }  ,  
    DARKPURPLE= { 112, 31, 126, 255 }  ,  
    BEIGE     = { 211, 176, 131, 255 } ,  
    BROWN     = { 127, 106, 79, 255 }  ,  
    DARKBROWN = { 76, 63, 47, 255 }    ,  
    
    WHITE     = { 255, 255, 255, 255 } ,  
    BLACK     = { 0, 0, 0, 255 }       ,  
    BLANK     = { 0, 0, 0, 0 }         ,  
    MAGENTA   = { 255, 0, 255, 255 }   ,  
    RAYWHITE  = { 245, 245, 245, 255 } 
}
-- system/window config flags
binds.ConfigFlags = {
    FLAG_VSYNC_HINT         = 0x00000040,
    FLAG_FULLSCREEN_MODE    = 0x00000002,
    FLAG_WINDOW_RESIZABLE   = 0x00000004,
    FLAG_WINDOW_UNDECORATED = 0x00000008,
    FLAG_WINDOW_HIDDEN      = 0x00000080,
    FLAG_WINDOW_MINIMIZED   = 0x00000200,
    FLAG_WINDOW_MAXIMIZED   = 0x00000400,
    FLAG_WINDOW_UNFOCUSED   = 0x00000800,
    FLAG_WINDOW_TOPMOST     = 0x00001000,
    FLAG_WINDOW_ALWAYS_RUN  = 0x00000100,
    FLAG_WINDOW_TRANSPARENT = 0x00000010,
    FLAG_WINDOW_HIGHDPI     = 0x00002000,
    FLAG_WINDOW_MOUSE_PASSTHROUGH = 0x00004000,
    FLAG_BORDERLESS_WINDOWED_MODE = 0x00008000,
    FLAG_MSAA_4X_HINT       = 0x00000020,
    FLAG_INTERLACED_HINT    = 0x00010000 
}

-- texture filters 
binds.TextureFilter = {
    TEXTURE_FILTER_POINT           = 0,
    TEXTURE_FILTER_BILINEAR        = 1,
    TEXTURE_FILTER_TRILINEAR       = 2,
    TEXTURE_FILTER_ANISOTROPIC_4X  = 3,
    TEXTURE_FILTER_ANISOTROPIC_8X  = 4,
    TEXTURE_FILTER_ANISOTROPIC_16X = 5
}

-- return the table
return binds
