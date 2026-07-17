-- NOTE: imports
ffi = require("ffi")

ffi.cdef[[
    typedef void (*TraceLogCallback)(int logLevel, const char *text, va_list args);
    typedef unsigned char *(*LoadFileDataCallback)(const char *fileName, int *dataSize);
    typedef bool (*SaveFileDataCallback)(const char *fileName, void *data, int dataSize);
    typedef char *(*LoadFileTextCallback)(const char *fileName);
    typedef bool (*SaveFileTextCallback)(const char *fileName, const char *text);

    typedef struct Vector2 {
        float x;
        float y;
    } Vector2;

    typedef struct Vector3 {
        float x;
        float y;
        float z;
    } Vector3;

    typedef struct Vector4 {
        float x;
        float y;
        float z;
        float w;
    } Vector4;

    typedef Vector4 Quaternion;

    typedef struct Matrix {
        float m0, m4, m8, m12;
        float m1, m5, m9, m13;
        float m2, m6, m10, m14;
        float m3, m7, m11, m15;
    } Matrix;

    typedef struct Color {
        unsigned char r;
        unsigned char g;
        unsigned char b;
        unsigned char a;
    } Color;

    typedef struct Rectangle {
        float x;
        float y;
        float width;
        float height;
    } Rectangle;

    typedef struct Image {
        void *data;
        int width;
        int height;
        int mipmaps;
        int format;
    } Image;

    typedef struct Texture {
        unsigned int id;
        int width;
        int height;
        int mipmaps;
        int format;
    } Texture;

    typedef Texture Texture2D;

    typedef Texture TextureCubemap;

    typedef struct RenderTexture {
        unsigned int id;
        Texture texture;
        Texture depth;
    } RenderTexture;

    typedef RenderTexture RenderTexture2D;

    typedef struct NPatchInfo {
        Rectangle source;
        int left;
        int top;
        int right;
        int bottom;
        int layout;
    } NPatchInfo;

    typedef struct GlyphInfo {
        int value;
        int offsetX;
        int offsetY;
        int advanceX;
        Image image;
    } GlyphInfo;

    typedef struct Font {
        int baseSize;
        int glyphCount;
        int glyphPadding;
        Texture2D texture;
        Rectangle *recs;
        GlyphInfo *glyphs;
    } Font;

    typedef struct Camera3D {
        Vector3 position;
        Vector3 target;
        Vector3 up;
        float fovy;
        int projection;
    } Camera3D;

    typedef Camera3D Camera;

    typedef struct Camera2D {
        Vector2 offset;
        Vector2 target;
        float rotation;
        float zoom;
    } Camera2D;

    typedef struct Mesh {
        int vertexCount;
        int triangleCount;


        float *vertices;
        float *texcoords;
        float *texcoords2;
        float *normals;
        float *tangents;
        unsigned char *colors;
        unsigned short *indices;


        int boneCount;
        unsigned char *boneIndices;
        float *boneWeights;



        float *animVertices;
        float *animNormals;


        unsigned int vaoId;
        unsigned int *vboId;
    } Mesh;

    typedef struct Shader {
        unsigned int id;
        int *locs;
    } Shader;

    typedef struct MaterialMap {
        Texture2D texture;
        Color color;
        float value;
    } MaterialMap;

    typedef struct Material {
        Shader shader;
        MaterialMap *maps;
        float params[4];
    } Material;

    typedef struct Transform {
        Vector3 translation;
        Quaternion rotation;
        Vector3 scale;
    } Transform;

    typedef Transform *ModelAnimPose;

    typedef struct BoneInfo {
        char name[32];
        int parent;
    } BoneInfo;

    typedef struct ModelSkeleton {
        int boneCount;
        BoneInfo *bones;
        ModelAnimPose bindPose;
    } ModelSkeleton;

    typedef struct Model {
        Matrix transform;

        int meshCount;
        int materialCount;
        Mesh *meshes;
        Material *materials;
        int *meshMaterial;


        ModelSkeleton skeleton;


        ModelAnimPose currentPose;
        Matrix *boneMatrices;
    } Model;

    typedef struct ModelAnimation {
        char name[32];

        int boneCount;
        int keyframeCount;
        ModelAnimPose *keyframePoses;
    } ModelAnimation;

    typedef struct Ray {
        Vector3 position;
        Vector3 direction;
    } Ray;

    typedef struct RayCollision {
        bool hit;
        float distance;
        Vector3 point;
        Vector3 normal;
    } RayCollision;

    typedef struct BoundingBox {
        Vector3 min;
        Vector3 max;
    } BoundingBox;

    typedef struct Wave {
        unsigned int frameCount;
        unsigned int sampleRate;
        unsigned int sampleSize;
        unsigned int channels;
        void *data;
    } Wave;

    typedef struct rAudioBuffer rAudioBuffer;
    typedef struct rAudioProcessor rAudioProcessor;

    typedef struct AudioStream {
        rAudioBuffer *buffer;
        rAudioProcessor *processor;

        unsigned int sampleRate;
        unsigned int sampleSize;
        unsigned int channels;
    } AudioStream;

    typedef struct Sound {
        AudioStream stream;
        unsigned int frameCount;
    } Sound;

    typedef struct Music {
        AudioStream stream;
        unsigned int frameCount;
        bool looping;

        int ctxType;
        void *ctxData;
    } Music;

    typedef struct VrDeviceInfo {
        int hResolution;
        int vResolution;
        float hScreenSize;
        float vScreenSize;
        float eyeToScreenDistance;
        float lensSeparationDistance;
        float interpupillaryDistance;
        float lensDistortionValues[4];
        float chromaAbCorrection[4];
    } VrDeviceInfo;

    typedef struct VrStereoConfig {
        Matrix projection[2];
        Matrix viewOffset[2];
        float leftLensCenter[2];
        float rightLensCenter[2];
        float leftScreenCenter[2];
        float rightScreenCenter[2];
        float scale[2];
        float scaleIn[2];
    } VrStereoConfig;

    typedef struct FilePathList {
        unsigned int count;
        char **paths;
    } FilePathList;

    typedef struct AutomationEvent {
        unsigned int frame;
        unsigned int type;
        int params[4];
    } AutomationEvent;

    typedef struct AutomationEventList {
        unsigned int capacity;
        unsigned int count;
        AutomationEvent *events;
    } AutomationEventList;


    void InitWindow(int width, int height, const char *title);
    void CloseWindow(void);
    bool WindowShouldClose(void);
    bool IsWindowReady(void);
    bool IsWindowFullscreen(void);
    bool IsWindowHidden(void);
    bool IsWindowMinimized(void);
    bool IsWindowMaximized(void);
    bool IsWindowFocused(void);
    bool IsWindowResized(void);
    bool IsWindowState(unsigned int flag);
    void SetWindowState(unsigned int flags);
    void ClearWindowState(unsigned int flags);
    void ToggleFullscreen(void);
    void ToggleBorderlessWindowed(void);
    void MaximizeWindow(void);
    void MinimizeWindow(void);
    void RestoreWindow(void);
    void SetWindowIcon(Image image);
    void SetWindowIcons(Image *images, int count);
    void SetWindowTitle(const char *title);
    void SetWindowPosition(int x, int y);
    void SetWindowMonitor(int monitor);
    void SetWindowMinSize(int width, int height);
    void SetWindowMaxSize(int width, int height);
    void SetWindowSize(int width, int height);
    void SetWindowOpacity(float opacity);
    void SetWindowFocused(void);
    void *GetWindowHandle(void);
    int GetScreenWidth(void);
    int GetScreenHeight(void);
    int GetRenderWidth(void);
    int GetRenderHeight(void);
    int GetMonitorCount(void);
    int GetCurrentMonitor(void);
    Vector2 GetMonitorPosition(int monitor);
    int GetMonitorWidth(int monitor);
    int GetMonitorHeight(int monitor);
    int GetMonitorPhysicalWidth(int monitor);
    int GetMonitorPhysicalHeight(int monitor);
    int GetMonitorRefreshRate(int monitor);
    Vector2 GetWindowPosition(void);
    Vector2 GetWindowScaleDPI(void);
    const char *GetMonitorName(int monitor);
    void SetClipboardText(const char *text);
    const char *GetClipboardText(void);
    Image GetClipboardImage(void);
    void EnableEventWaiting(void);
    void DisableEventWaiting(void);


    void ShowCursor(void);
    void HideCursor(void);
    bool IsCursorHidden(void);
    void EnableCursor(void);
    void DisableCursor(void);
    bool IsCursorOnScreen(void);


    void ClearBackground(Color color);
    void BeginDrawing(void);
    void EndDrawing(void);
    void BeginMode2D(Camera2D camera);
    void EndMode2D(void);
    void BeginMode3D(Camera3D camera);
    void EndMode3D(void);
    void BeginTextureMode(RenderTexture2D target);
    void EndTextureMode(void);
    void BeginShaderMode(Shader shader);
    void EndShaderMode(void);
    void BeginBlendMode(int mode);
    void EndBlendMode(void);
    void BeginScissorMode(int x, int y, int width, int height);
    void EndScissorMode(void);
    void BeginVrStereoMode(VrStereoConfig config);
    void EndVrStereoMode(void);


    VrStereoConfig LoadVrStereoConfig(VrDeviceInfo device);
    void UnloadVrStereoConfig(VrStereoConfig config);



    Shader LoadShader(const char *vsFileName, const char *fsFileName);
    Shader LoadShaderFromMemory(const char *vsCode, const char *fsCode);
    bool IsShaderValid(Shader shader);
    int GetShaderLocation(Shader shader, const char *uniformName);
    int GetShaderLocationAttrib(Shader shader, const char *attribName);
    void SetShaderValue(Shader shader, int locIndex, const void *value, int uniformType);
    void SetShaderValueV(Shader shader, int locIndex, const void *value, int uniformType, int count);
    void SetShaderValueMatrix(Shader shader, int locIndex, Matrix mat);
    void SetShaderValueTexture(Shader shader, int locIndex, Texture2D texture);
    void UnloadShader(Shader shader);


    Ray GetScreenToWorldRay(Vector2 position, Camera camera);
    Ray GetScreenToWorldRayEx(Vector2 position, Camera camera, int width, int height);
    Vector2 GetWorldToScreen(Vector3 position, Camera camera);
    Vector2 GetWorldToScreenEx(Vector3 position, Camera camera, int width, int height);
    Vector2 GetWorldToScreen2D(Vector2 position, Camera2D camera);
    Vector2 GetScreenToWorld2D(Vector2 position, Camera2D camera);
    Matrix GetCameraMatrix(Camera camera);
    Matrix GetCameraMatrix2D(Camera2D camera);


    void SetTargetFPS(int fps);
    float GetFrameTime(void);
    double GetTime(void);
    int GetFPS(void);



    void SwapScreenBuffer(void);
    void PollInputEvents(void);
    void WaitTime(double seconds);


    void SetRandomSeed(unsigned int seed);
    int GetRandomValue(int min, int max);
    int *LoadRandomSequence(unsigned int count, int min, int max);
    void UnloadRandomSequence(int *sequence);


    void TakeScreenshot(const char *fileName);
    void SetConfigFlags(unsigned int flags);
    void OpenURL(const char *url);


    void SetTraceLogLevel(int logLevel);
    void TraceLog(int logLevel, const char *text, ...);
    void SetTraceLogCallback(TraceLogCallback callback);


    void *MemAlloc(unsigned int size);
    void *MemRealloc(void *ptr, unsigned int size);
    void MemFree(void *ptr);


    unsigned char *LoadFileData(const char *fileName, int *dataSize);
    void UnloadFileData(unsigned char *data);
    bool SaveFileData(const char *fileName, void *data, int dataSize);
    bool ExportDataAsCode(const unsigned char *data, int dataSize, const char *fileName);
    char *LoadFileText(const char *fileName);
    void UnloadFileText(char *text);
    bool SaveFileText(const char *fileName, const char *text);



    void SetLoadFileDataCallback(LoadFileDataCallback callback);
    void SetSaveFileDataCallback(SaveFileDataCallback callback);
    void SetLoadFileTextCallback(LoadFileTextCallback callback);
    void SetSaveFileTextCallback(SaveFileTextCallback callback);

    int FileRename(const char *fileName, const char *fileRename);
    int FileRemove(const char *fileName);
    int FileCopy(const char *srcPath, const char *dstPath);
    int FileMove(const char *srcPath, const char *dstPath);
    int FileTextReplace(const char *fileName, const char *search, const char *replacement);
    int FileTextFindIndex(const char *fileName, const char *search);
    bool FileExists(const char *fileName);
    bool DirectoryExists(const char *dirPath);
    bool IsFileExtension(const char *fileName, const char *ext);
    int GetFileLength(const char *fileName);
    long GetFileModTime(const char *fileName);
    const char *GetFileExtension(const char *fileName);
    const char *GetFileName(const char *filePath);
    const char *GetFileNameWithoutExt(const char *filePath);
    const char *GetDirectoryPath(const char *filePath);
    const char *GetPrevDirectoryPath(const char *dirPath);
    const char *GetWorkingDirectory(void);
    const char *GetApplicationDirectory(void);
    int MakeDirectory(const char *dirPath);
    bool ChangeDirectory(const char *dirPath);
    bool IsPathFile(const char *path);
    bool IsFileNameValid(const char *fileName);
    FilePathList LoadDirectoryFiles(const char *dirPath);
    FilePathList LoadDirectoryFilesEx(const char *basePath, const char *filter, bool scanSubdirs);
    void UnloadDirectoryFiles(FilePathList files);
    bool IsFileDropped(void);
    FilePathList LoadDroppedFiles(void);
    void UnloadDroppedFiles(FilePathList files);
    unsigned int GetDirectoryFileCount(const char *dirPath);
    unsigned int GetDirectoryFileCountEx(const char *basePath, const char *filter, bool scanSubdirs);


    unsigned char *CompressData(const unsigned char *data, int dataSize, int *compDataSize);
    unsigned char *DecompressData(const unsigned char *compData, int compDataSize, int *dataSize);
    char *EncodeDataBase64(const unsigned char *data, int dataSize, int *outputSize);
    unsigned char *DecodeDataBase64(const char *text, int *outputSize);
    unsigned int ComputeCRC32(unsigned char *data, int dataSize);
    unsigned int *ComputeMD5(unsigned char *data, int dataSize);
    unsigned int *ComputeSHA1(unsigned char *data, int dataSize);
    unsigned int *ComputeSHA256(unsigned char *data, int dataSize);


    AutomationEventList LoadAutomationEventList(const char *fileName);
    void UnloadAutomationEventList(AutomationEventList list);
    bool ExportAutomationEventList(AutomationEventList list, const char *fileName);
    void SetAutomationEventList(AutomationEventList *list);
    void SetAutomationEventBaseFrame(int frame);
    void StartAutomationEventRecording(void);
    void StopAutomationEventRecording(void);
    void PlayAutomationEvent(AutomationEvent event);



    bool IsKeyPressed(int key);
    bool IsKeyPressedRepeat(int key);
    bool IsKeyDown(int key);
    bool IsKeyReleased(int key);
    bool IsKeyUp(int key);
    int GetKeyPressed(void);
    int GetCharPressed(void);
    const char *GetKeyName(int key);
    void SetExitKey(int key);


    bool IsGamepadAvailable(int gamepad);
    const char *GetGamepadName(int gamepad);
    bool IsGamepadButtonPressed(int gamepad, int button);
    bool IsGamepadButtonDown(int gamepad, int button);
    bool IsGamepadButtonReleased(int gamepad, int button);
    bool IsGamepadButtonUp(int gamepad, int button);
    int GetGamepadButtonPressed(void);
    int GetGamepadAxisCount(int gamepad);
    float GetGamepadAxisMovement(int gamepad, int axis);
    int SetGamepadMappings(const char *mappings);
    void SetGamepadVibration(int gamepad, float leftMotor, float rightMotor, float duration);


    bool IsMouseButtonPressed(int button);
    bool IsMouseButtonDown(int button);
    bool IsMouseButtonReleased(int button);
    bool IsMouseButtonUp(int button);
    int GetMouseX(void);
    int GetMouseY(void);
    Vector2 GetMousePosition(void);
    Vector2 GetMouseDelta(void);
    void SetMousePosition(int x, int y);
    void SetMouseOffset(int offsetX, int offsetY);
    void SetMouseScale(float scaleX, float scaleY);
    float GetMouseWheelMove(void);
    Vector2 GetMouseWheelMoveV(void);
    void SetMouseCursor(int cursor);


    int GetTouchX(void);
    int GetTouchY(void);
    Vector2 GetTouchPosition(int index);
    int GetTouchPointId(int index);
    int GetTouchPointCount(void);


    void SetGesturesEnabled(unsigned int flags);
    bool IsGestureDetected(unsigned int gesture);
    int GetGestureDetected(void);
    float GetGestureHoldDuration(void);
    Vector2 GetGestureDragVector(void);
    float GetGestureDragAngle(void);
    Vector2 GetGesturePinchVector(void);
    float GetGesturePinchAngle(void);


    void UpdateCamera(Camera *camera, int mode);
    void UpdateCameraPro(Camera *camera, Vector3 movement, Vector3 rotation, float zoom);


    // raymath
    Vector3 Vector3RotateByAxisAngle(Vector3 v, Vector3 axis, float angle);
    float Vector3Angle(Vector3 v1, Vector3 v2);
    Vector3 Vector3CrossProduct(Vector3 v1, Vector3 v2);
    Vector3 Vector3Normalize(Vector3 v);
    Vector3 Vector3Scale(Vector3 v, float scalar);

    // rmodels 
    void DrawPlane(Vector3 centerPos, Vector2 size, Color color);
    void DrawCubeV(Vector3 position, Vector3 size, Color color);
    void DrawCubeWiresV(Vector3 position, Vector3 size, Color color);
    void DrawSphere(Vector3 centerPos, float radius, Color color); 
    Color ColorAlpha(Color color, float alpha);
    void DrawRectangle(int posX, int posY, int width, int height, Color color);      
    void DrawRectangleLines(int posX, int posY, int width, int height, Color color); 
    void DrawText(const char *text, int posX, int posY, int fontSize, Color color);
]]
local raylib = ffi.load("./lib/libraylib.so")
--



-- Helper functions for struct conversion

-- --- 1. Basic Math Types ---

local function vec2_to_c(v)
    if ffi.istype("Vector2", v) then return v end
    return ffi.new("Vector2", v.x or v[1] or 0, v.y or v[2] or 0)
end

local function vec2_from_c(v)
    return { x = tonumber(v.x), y = tonumber(v.y) }
end

local function vec3_to_c(v)
    if ffi.istype("Vector3", v) then return v end
    return ffi.new("Vector3", v.x or v[1] or 0, v.y or v[2] or 0, v.z or v[3] or 0)
end

local function vec3_from_c(v)
    return { x = tonumber(v.x), y = tonumber(v.y), z = tonumber(v.z) }
end

local function vec4_to_c(v)
    if ffi.istype("Vector4", v) then return v end
    return ffi.new("Vector4", v.x or v[1] or 0, v.y or v[2] or 0, v.z or v[3] or 0, v.w or v[4] or 0)
end

local function vec4_from_c(v)
    return { x = tonumber(v.x), y = tonumber(v.y), z = tonumber(v.z), w = tonumber(v.w) }
end

-- Quaternion is typedef Vector4
local quat_to_c = vec4_to_c
local quat_from_c = vec4_from_c

local function matrix_to_c(m)
    if ffi.istype("Matrix", m) then return m end
    local c_m = ffi.new("Matrix")
    -- Поддержка как именованных полей, так и плоского массива m0..m15
    c_m.m0 = m.m0 or m[0]; c_m.m4 = m.m4 or m[4]; c_m.m8 = m.m8 or m[8]; c_m.m12 = m.m12 or m[12]
    c_m.m1 = m.m1 or m[1]; c_m.m5 = m.m5 or m[5]; c_m.m9 = m.m9 or m[9]; c_m.m13 = m.m13 or m[13]
    c_m.m2 = m.m2 or m[2]; c_m.m6 = m.m6 or m[6]; c_m.m10 = m.m10 or m[10]; c_m.m14 = m.m14 or m[14]
    c_m.m3 = m.m3 or m[3]; c_m.m7 = m.m7 or m[7]; c_m.m11 = m.m11 or m[11]; c_m.m15 = m.m15 or m[15]
    return c_m
end

local function matrix_from_c(m)
    return {
        m0=tonumber(m.m0), m4=tonumber(m.m4), m8=tonumber(m.m8), m12=tonumber(m.m12),
        m1=tonumber(m.m1), m5=tonumber(m.m5), m9=tonumber(m.m9), m13=tonumber(m.m13),
        m2=tonumber(m.m2), m6=tonumber(m.m6), m10=tonumber(m.m10), m14=tonumber(m.m14),
        m3=tonumber(m.m3), m7=tonumber(m.m7), m11=tonumber(m.m11), m15=tonumber(m.m15)
    }
end

local function color_to_c(c)
    if ffi.istype("Color", c) then return c end
    -- Поддержка {r,g,b,a} и {r=...,g=...}
    return ffi.new("Color", c.r or c[1] or 0, c.g or c[2] or 0, c.b or c[3] or 0, c.a or c[4] or 255)
end

local function color_from_c(c)
    return { r = tonumber(c.r), g = tonumber(c.g), b = tonumber(c.b), a = tonumber(c.a) }
end

local function rect_to_c(r)
    if ffi.istype("Rectangle", r) then return r end
    return ffi.new("Rectangle", r.x or 0, r.y or 0, r.width or 0, r.height or 0)
end

local function rect_from_c(r)
    return { x = tonumber(r.x), y = tonumber(r.y), width = tonumber(r.width), height = tonumber(r.height) }
end

-- --- 2. Complex Structures ---

local function image_to_c(img)
    if ffi.istype("Image", img) then return img end
    local c_img = ffi.new("Image")
    c_img.data = img.data -- Ожидается cdata указатель
    c_img.width = img.width
    c_img.height = img.height
    c_img.mipmaps = img.mipmaps or 1
    c_img.format = img.format
    return c_img
end

local function image_from_c(img)
    return {
        data = img.data,
        width = tonumber(img.width),
        height = tonumber(img.height),
        mipmaps = tonumber(img.mipmaps),
        format = tonumber(img.format)
    }
end

local function npatch_to_c(np)
    if ffi.istype("NPatchInfo", np) then return np end
    local c_np = ffi.new("NPatchInfo")
    c_np.source = rect_to_c(np.source)
    c_np.left = np.left
    c_np.top = np.top
    c_np.right = np.right
    c_np.bottom = np.bottom
    c_np.layout = np.layout
    return c_np
end

local function glyph_to_c(g)
    if ffi.istype("GlyphInfo", g) then return g end
    local c_g = ffi.new("GlyphInfo")
    c_g.value = g.value
    c_g.offsetX = g.offsetX
    c_g.offsetY = g.offsetY
    c_g.advanceX = g.advanceX
    c_g.image = image_to_c(g.image)
    return c_g
end

local function camera2d_to_c(cam)
    if ffi.istype("Camera2D", cam) then return cam end
    local c_cam = ffi.new("Camera2D")
    c_cam.offset = vec2_to_c(cam.offset)
    c_cam.target = vec2_to_c(cam.target)
    c_cam.rotation = cam.rotation or 0
    c_cam.zoom = cam.zoom or 1
    return c_cam
end

local function camera2d_from_c(c_cam)
    return {
        offset = vec2_from_c(c_cam.offset),
        target = vec2_from_c(c_cam.target),
        rotation = tonumber(c_cam.rotation),
        zoom = tonumber(c_cam.zoom)
    }
end

local function camera3d_to_c(cam)
    if ffi.istype("Camera3D", cam) then return cam end
    local c_cam = ffi.new("Camera3D")
    c_cam.position = vec3_to_c(cam.position)
    c_cam.target = vec3_to_c(cam.target)
    c_cam.up = vec3_to_c(cam.up)
    c_cam.fovy = cam.fovy
    c_cam.projection = cam.projection
    return c_cam
end

local function camera3d_from_c(c_cam)
    return {
        position = vec3_from_c(c_cam.position),
        target = vec3_from_c(c_cam.target),
        up = vec3_from_c(c_cam.up),
        fovy = tonumber(c_cam.fovy),
        projection = tonumber(c_cam.projection)
    }
end

local function ray_to_c(r)
    if ffi.istype("Ray", r) then return r end
    local c_r = ffi.new("Ray")
    c_r.position = vec3_to_c(r.position)
    c_r.direction = vec3_to_c(r.direction)
    return c_r
end

local function ray_from_c(r)
    return {
        position = vec3_from_c(r.position),
        direction = vec3_from_c(r.direction)
    }
end

local function ray_collision_from_c(rc)
    return {
        hit = rc.hit,
        distance = tonumber(rc.distance),
        point = vec3_from_c(rc.point),
        normal = vec3_from_c(rc.normal)
    }
end

local function bbox_to_c(b)
    if ffi.istype("BoundingBox", b) then return b end
    local c_b = ffi.new("BoundingBox")
    c_b.min = vec3_to_c(b.min)
    c_b.max = vec3_to_c(b.max)
    return c_b
end

local function transform_to_c(t)
    if ffi.istype("Transform", t) then return t end
    local c_t = ffi.new("Transform")
    c_t.translation = vec3_to_c(t.translation)
    c_t.rotation = quat_to_c(t.rotation)
    c_t.scale = vec3_to_c(t.scale)
    return c_t
end

local function vr_device_info_to_c(d)
    if ffi.istype("VrDeviceInfo", d) then return d end
    local c_d = ffi.new("VrDeviceInfo")
    c_d.hResolution = d.hResolution
    c_d.vResolution = d.vResolution
    c_d.hScreenSize = d.hScreenSize
    c_d.vScreenSize = d.vScreenSize
    c_d.eyeToScreenDistance = d.eyeToScreenDistance
    c_d.lensSeparationDistance = d.lensSeparationDistance
    c_d.interpupillaryDistance = d.interpupillaryDistance
    -- Arrays need manual copy if passed as tables
    if d.lensDistortionValues then
        for i=0,3 do c_d.lensDistortionValues[i] = d.lensDistortionValues[i+1] or d.lensDistortionValues[i] or 0 end
    end
    if d.chromaAbCorrection then
        for i=0,3 do c_d.chromaAbCorrection[i] = d.chromaAbCorrection[i+1] or d.chromaAbCorrection[i] or 0 end
    end
    return c_d
end

-- --- 3. Resources (Usually kept as cdata, but helpers for creation) ---

-- Texture, Shader, RenderTexture, Font, Mesh, Model, Sound, Music are typically 
-- managed by Raylib and returned as cdata. We usually don't convert them TO c from Lua tables
-- unless we are creating them manually (which is rare and complex).
-- However, for consistency, here is how you would access their fields if needed.

local function texture_from_c(t)
    return {
        id = tonumber(t.id),
        width = tonumber(t.width),
        height = tonumber(t.height),
        mipmaps = tonumber(t.mipmaps),
        format = tonumber(t.format)
    }
end

local function shader_from_c(s)
    return {
        id = tonumber(s.id),
        locs = s.locs -- pointer to int array
    }
end



-- a table for all
local binds = {}
--

-- Lua wrappers
function binds.GetWindowHandle()
    return tonumber(ffi.cast("uintptr_t", raylib.GetWindowHandle()))
end

function binds.GetClipboardText()
    return ffi.string(raylib.GetClipboardText())
end

function binds.GetWorkingDirectory()
    return ffi.string(raylib.GetWorkingDirectory())
end

function binds.GetApplicationDirectory()
    return ffi.string(raylib.GetApplicationDirectory())
end



function binds.GetMonitorName(monitor)
    return ffi.string(raylib.GetMonitorName(monitor))
end

function binds.GetGamepadName(gamepad)
    return ffi.string(raylib.GetGamepadName(gamepad))
end

function binds.GetKeyName(key)
    return ffi.string(raylib.GetKeyName(key))
end

function binds.ComputeMD5(data, dataSize)
    local ptr = raylib.ComputeMD5(data, dataSize)
    return ffi.string(ffi.cast("char *", ptr), 16)
end

function binds.ComputeSHA1(data, dataSize)
    local ptr = raylib.ComputeSHA1(data, dataSize)
    return ffi.string(ffi.cast("char *", ptr), 20)
end

function binds.ComputeSHA256(data, dataSize)
    local ptr = raylib.ComputeSHA256(data, dataSize)
    return ffi.string(ffi.cast("char *", ptr), 32)
end

function binds.CompressData(data, dataSize)
    local compDataSize = ffi.typeof("int[1]")
    local ptr = raylib.CompressData(
        ffi.cast("const unsigned char*", data),
        dataSize,
        compDataSize
    )

    if ptr == nil then return nil end

    local size = tonumber(compDataSize[0])
    local result = ffi.string(ptr, size)

    return result, size
end

function binds.DecompressData(compData, compDataSize)
    local dataSize = ffi.typeof("int[1]")
    local ptr = raylib.DecompressData(
        ffi.cast("const unsigned char*", compData),
        compDataSize,
        dataSize
    )

    if ptr == nil then return nil end

    local size = tonumber(dataSize[0])
    local result = ffi.string(ptr, size)

    return result, size
end

function binds.EncodeDataBase64(data, dataSize)
    local outputSize = ffi.typeof("int[1]")
    local ptr = raylib.EncodeDataBase64(
        ffi.cast("const unsigned char*", data),
        dataSize,
        outputSize
    )

    if ptr == nil then return nil end

    local size = tonumber(outputSize[0])
    local result = ffi.string(ptr, size)

    return result, size
end

function binds.DecodeDataBase64(text)
    local outputSize = ffi.typeof("int[1]")
    local ptr = raylib.DecodeDataBase64(text, outputSize)

    if ptr == nil then return nil end

    local size = tonumber(outputSize[0])

    local result = ffi.string(ptr, size)

    return result, size
end

function binds.GetFileExtension(fileName)
    return ffi.string(raylib.GetFileExtension(fileName))
end

function binds.GetFileName(filePath)
    return ffi.string(raylib.GetFileName(filePath))
end

function binds.GetFileNameWithoutExt(filePath)
    return ffi.string(raylib.GetFileNameWithoutExt(filePath))
end

function binds.GetDirectoryPath(filePath)
    return ffi.string(raylib.GetDirectoryPath(filePath))
end

function binds.GetPrevDirectoryPath(dirPath)
    return ffi.string(raylib.GetPrevDirectoryPath(dirPath))
end

function binds.LoadFileText(fileName)
    return ffi.string(raylib.LoadFileText(fileName))
end

function binds.LoadFileData(fileName)
    local dataSize = ffi.typeof("int[1]")
    local ptr = raylib.LoadFileData(fileName, dataSize)

    if ptr == nil then return nil end

    local size = tonumber(dataSize[0])
    local result = ffi.string(ptr, size)

    return result, size
end

function binds.MemAlloc(size)
    return tonumber(ffi.cast("uintptr_t", raylib.MemAlloc(size)))
end

function binds.MemRealloc(ptr, size)
    return tonumber(ffi.cast("uintptr_t", raylib.MemRealloc(ptr, size)))
end

function binds.LoadRandomSequence(count, min, max)
    local ptr = raylib.LoadRandomSequence(count, min, max)

    if ptr == nil then return nil end

    local result = {}
    for i = 0, count - 1 do
        result[i + 1] = tonumber(ptr[i])
    end

    return result
end

function binds.GetMonitorPosition(monitor)
    local v = raylib.GetMonitorPosition(monitor)
    return vec2_from_c(v)
end

function binds.GetTouchPosition(index)
    local v = raylib.GetTouchPosition(index)
    return vec2_from_c(v)
end

function binds.LoadDirectoryFiles(dirPath)
    local list = raylib.LoadDirectoryFiles(dirPath)
    local paths = {}

    for i = 0, list.count - 1 do
        table.insert(paths, ffi.string(list.paths[i]))
    end

    return paths
end

function binds.LoadDirectoryFilesEx(basePath, filter, scanSubdirs)
    local list = raylib.LoadDirectoryFilesEx(basePath, filter, scanSubdirs)
    local paths = {}
    for i = 0, list.count - 1 do
        table.insert(paths, ffi.string(list.paths[i]))
    end

    return paths
end

function binds.LoadAutomationEventList(fileName)
    local list = raylib.LoadAutomationEventList(fileName)
    local events = {}

    for i = 0, list.count - 1 do
        local e = list.events[i]
        table.insert(events, {
            frame = tonumber(e.frame),
            type = tonumber(e.type),
            params = { 
                tonumber(e.params[0]),
                tonumber(e.params[1]),
                tonumber(e.params[2]),
                tonumber(e.params[3])
            }
        })
    end

    return events
end

function binds.LoadShader(vsFileName, fsFileName)
    return raylib.LoadShader(vsFileName, fsFileName)
end

function binds.LoadShaderFromMemory(vsCode, fsCode)
    return raylib.LoadShaderFromMemory(vsCode, fsCode)
end

function binds.GetGestureDragVector()
    return vec2_from_c(raylib.GetGestureDragVector())
end

function binds.GetGesturePinchVector()
    return vec2_from_c(raylib.GetGesturePinchVector())
end

function binds.GetMouseWheelMoveV()
    return vec2_from_c(raylib.GetMouseWheelMoveV())
end

function binds.GetMousePosition()
    return vec2_from_c(raylib.GetMousePosition())
end

function binds.GetMouseDelta()
    return vec2_from_c(raylib.GetMouseDelta())
end

function binds.GetWindowPosition()
    return vec2_from_c(raylib.GetWindowPosition())
end

function binds.GetWindowScaleDPI()
    return vec2_from_c(raylib.GetWindowScaleDPI())
end

function binds.LoadDroppedFiles()
    local list = raylib.LoadDroppedFiles()
    local paths = {}

    for i = 0, list.count - 1 do
        table.insert(paths, ffi.string(list.paths[i]))
    end

    return paths
end

function binds.GetClipboardImage()
    local img = raylib.GetClipboardImage()
    return image_from_c(img)
end

function binds.UpdateCamera(camera, mode)
    local c_cam = camera3d_to_c(camera)
    raylib.UpdateCamera(ffi.cast("Camera*", c_cam), mode)
    camera3d_from_c(c_cam)
end

function binds.UpdateCameraPro(camera, movement, rotation, zoom)
    local c_cam = camera3d_to_c(camera)
    raylib.UpdateCameraPro(
        ffi.cast("Camera*", c_cam), 
        vec3_to_c(movement), 
        vec3_to_c(rotation), 
        zoom
    )
    camera3d_from_c(c_cam)
end

function binds.SetWindowIcon(image)
    raylib.SetWindowIcon(image_to_c(image))
end

function binds.SetWindowIcons(images, count)
    local c_images = ffi.new("Image[?]", count)
    
    for i = 0, count - 1 do
        c_images[i] = image_to_c(images[i + 1])
    end
    
    raylib.SetWindowIcons(c_images, count)
end

function binds.ClearBackground(color)
    raylib.ClearBackground(color_to_c(color))
end

function binds.BeginMode2D(camera)
    raylib.BeginMode2D(camera2d_to_c(camera))
end

function binds.BeginMode3D(camera)
    raylib.BeginMode3D(camera3d_to_c(camera))
end

function binds.BeginTextureMode(target)
    raylib.BeginTextureMode(target)
end

function binds.BeginShaderMode(shader)
    raylib.BeginShaderMode(shader)
end

function binds.BeginVrStereoMode(config)
    raylib.BeginVrStereoMode(config)
end

function binds.UnloadVrStereoConfig(config)
    raylib.UnloadVrStereoConfig(config)
end

function binds.IsShaderValid(shader)
    return raylib.IsShaderValid(shader)
end



-- raymath
function binds.Vector3RotateByAxisAngle(v, axis, angle)
    local c_v = vec3_to_c(v)
    local c_axis = vec3_to_c(axis)
    
    local result = raylib.Vector3RotateByAxisAngle(c_v, c_axis, angle)
    return vec3_from_c(result)
end

function binds.Vector3Angle(v1, v2)
    local c_v1 = vec3_to_c(v1)
    local c_v2 = vec3_to_c(v2)

    local angle = raylib.Vector3Angle(c_v1, c_v2)

    return tonumber(angle)
end

function binds.Vector3CrossProduct(v1, v2)
    local c_v1 = vec3_to_c(v1)
    local c_v2 = vec3_to_c(v2)
    
    local result = raylib.Vector3CrossProduct(c_v1, c_v2)
    return vec3_from_c(result)
end

function binds.Vector3Normalize(v)
    local c_v = vec3_to_c(v)
    local result = raylib.Vector3Normalize(c_v)
    return vec3_from_c(result)
end

function binds.Vector3Scale(v, scalar)
    local c_v = vec3_to_c(v)
    local result = raylib.Vector3Scale(c_v, scalar)
    return vec3_from_c(result)
end

function binds.Vector3Add(v1, v2)
    return {
        x = (v1.x or v1[1] or 0) + (v2.x or v2[1] or 0),
        y = (v1.y or v1[2] or 0) + (v2.y or v2[2] or 0),
        z = (v1.z or v1[3] or 0) + (v2.z or v2[3] or 0)
    }
end

function binds.Vector3Lerp(v1, v2, amount)
    local x1 = v1.x or v1[1] or 0
    local y1 = v1.y or v1[2] or 0
    local z1 = v1.z or v1[3] or 0
    
    local x2 = v2.x or v2[1] or 0
    local y2 = v2.y or v2[2] or 0
    local z2 = v2.z or v2[3] or 0

    return {
        x = x1 + amount * (x2 - x1),
        y = y1 + amount * (y2 - y1),
        z = z1 + amount * (z2 - z1)
    }
end

function binds.Lerp(start, end_val, amount)
    return start + amount * (end_val - start)
end

function binds.DrawPlane(centerPos, size, color)
    raylib.DrawPlane(vec3_to_c(centerPos), vec2_to_c(size), color_to_c(color))
end

function binds.DrawCubeV(position, size, color)
    raylib.DrawCubeV(vec3_to_c(position), vec3_to_c(size), color_to_c(color))
end

function binds.DrawCubeWiresV(position, size, color)
    raylib.DrawCubeWiresV(vec3_to_c(position), vec3_to_c(size), color_to_c(color))
end

function binds.DrawSphere(centerPos, radius, color)
    raylib.DrawSphere(vec3_to_c(centerPos), radius, color_to_c(color))
end

function binds.ColorAlpha(color, alpha)
    local c_color = color_to_c(color)
    local result = raylib.ColorAlpha(c_color, alpha)
    return color_from_c(result)
end

function binds.DrawRectangle(posX, posY, width, height, color)
    raylib.DrawRectangle(posX, posY, width, height, color_to_c(color))
end

function binds.DrawRectangleLines(posX, posY, width, height, color)
    raylib.DrawRectangleLines(posX, posY, width, height, color_to_c(color))
end

function binds.DrawText(text, posX, posY, fontSize, color)
    raylib.DrawText(text, posX, posY, fontSize, color_to_c(color))
end

-- enums
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

binds.TraceLogLevel = {
    LOG_ALL = 0,
    LOG_TRACE = 1,
    LOG_DEBUG = 2,
    LOG_INFO = 3,
    LOG_WARNING = 4,
    LOG_ERROR = 5,
    LOG_FATAL = 6,
    LOG_NONE = 7
}

binds.KeyboardKey = {
    KEY_NULL            = 0,

    KEY_APOSTROPHE      = 39,
    KEY_COMMA           = 44,
    KEY_MINUS           = 45,
    KEY_PERIOD          = 46,
    KEY_SLASH           = 47,
    KEY_ZERO            = 48,
    KEY_ONE             = 49,
    KEY_TWO             = 50,
    KEY_THREE           = 51,
    KEY_FOUR            = 52,
    KEY_FIVE            = 53,
    KEY_SIX             = 54,
    KEY_SEVEN           = 55,
    KEY_EIGHT           = 56,
    KEY_NINE            = 57,
    KEY_SEMICOLON       = 59,
    KEY_EQUAL           = 61,
    KEY_A               = 65,
    KEY_B               = 66,
    KEY_C               = 67,
    KEY_D               = 68,
    KEY_E               = 69,
    KEY_F               = 70,
    KEY_G               = 71,
    KEY_H               = 72,
    KEY_I               = 73,
    KEY_J               = 74,
    KEY_K               = 75,
    KEY_L               = 76,
    KEY_M               = 77,
    KEY_N               = 78,
    KEY_O               = 79,
    KEY_P               = 80,
    KEY_Q               = 81,
    KEY_R               = 82,
    KEY_S               = 83,
    KEY_T               = 84,
    KEY_U               = 85,
    KEY_V               = 86,
    KEY_W               = 87,
    KEY_X               = 88,
    KEY_Y               = 89,
    KEY_Z               = 90,
    KEY_LEFT_BRACKET    = 91,
    KEY_BACKSLASH       = 92,
    KEY_RIGHT_BRACKET   = 93,
    KEY_GRAVE           = 96,

    KEY_SPACE           = 32,
    KEY_ESCAPE          = 256,
    KEY_ENTER           = 257,
    KEY_TAB             = 258,
    KEY_BACKSPACE       = 259,
    KEY_INSERT          = 260,
    KEY_DELETE          = 261,
    KEY_RIGHT           = 262,
    KEY_LEFT            = 263,
    KEY_DOWN            = 264,
    KEY_UP              = 265,
    KEY_PAGE_UP         = 266,
    KEY_PAGE_DOWN       = 267,
    KEY_HOME            = 268,
    KEY_END             = 269,
    KEY_CAPS_LOCK       = 280,
    KEY_SCROLL_LOCK     = 281,
    KEY_NUM_LOCK        = 282,
    KEY_PRINT_SCREEN    = 283,
    KEY_PAUSE           = 284,
    KEY_F1              = 290,
    KEY_F2              = 291,
    KEY_F3              = 292,
    KEY_F4              = 293,
    KEY_F5              = 294,
    KEY_F6              = 295,
    KEY_F7              = 296,
    KEY_F8              = 297,
    KEY_F9              = 298,
    KEY_F10             = 299,
    KEY_F11             = 300,
    KEY_F12             = 301,
    KEY_LEFT_SHIFT      = 340,
    KEY_LEFT_CONTROL    = 341,
    KEY_LEFT_ALT        = 342,
    KEY_LEFT_SUPER      = 343,
    KEY_RIGHT_SHIFT     = 344,
    KEY_RIGHT_CONTROL   = 345,
    KEY_RIGHT_ALT       = 346,
    KEY_RIGHT_SUPER     = 347,
    KEY_KB_MENU         = 348,

    KEY_KP_0            = 320,
    KEY_KP_1            = 321,
    KEY_KP_2            = 322,
    KEY_KP_3            = 323,
    KEY_KP_4            = 324,
    KEY_KP_5            = 325,
    KEY_KP_6            = 326,
    KEY_KP_7            = 327,
    KEY_KP_8            = 328,
    KEY_KP_9            = 329,
    KEY_KP_DECIMAL      = 330,
    KEY_KP_DIVIDE       = 331,
    KEY_KP_MULTIPLY     = 332,
    KEY_KP_SUBTRACT     = 333,
    KEY_KP_ADD          = 334,
    KEY_KP_ENTER        = 335,
    KEY_KP_EQUAL        = 336,

    KEY_BACK            = 4,
    KEY_MENU            = 5,
    KEY_VOLUME_UP       = 24,
    KEY_VOLUME_DOWN     = 25
}

binds.MouseButton = {
    MOUSE_BUTTON_LEFT    = 0,
    MOUSE_BUTTON_RIGHT   = 1,
    MOUSE_BUTTON_MIDDLE  = 2,
    MOUSE_BUTTON_SIDE    = 3,
    MOUSE_BUTTON_EXTRA   = 4,
    MOUSE_BUTTON_FORWARD = 5,
    MOUSE_BUTTON_BACK    = 6,
    MOUSE_LEFT_BUTTON    = 0,
    MOUSE_RIGHT_BUTTON   = 1,
    MOUSE_MIDDLE_BUTTON  = 2
}

binds.MouseCursor = {
    MOUSE_CURSOR_DEFAULT       = 0,
    MOUSE_CURSOR_ARROW         = 1,
    MOUSE_CURSOR_IBEAM         = 2,
    MOUSE_CURSOR_CROSSHAIR     = 3,
    MOUSE_CURSOR_POINTING_HAND = 4,
    MOUSE_CURSOR_RESIZE_EW     = 5,
    MOUSE_CURSOR_RESIZE_NS     = 6,
    MOUSE_CURSOR_RESIZE_NWSE   = 7,
    MOUSE_CURSOR_RESIZE_NESW   = 8,
    MOUSE_CURSOR_RESIZE_ALL    = 9,
    MOUSE_CURSOR_NOT_ALLOWED   = 10
}

binds.GamepadButton = {
    GAMEPAD_BUTTON_UNKNOWN = 0,
    GAMEPAD_BUTTON_LEFT_FACE_UP = 1,
    GAMEPAD_BUTTON_LEFT_FACE_RIGHT = 2,
    GAMEPAD_BUTTON_LEFT_FACE_DOWN = 3,
    GAMEPAD_BUTTON_LEFT_FACE_LEFT = 4,
    GAMEPAD_BUTTON_RIGHT_FACE_UP = 5,
    GAMEPAD_BUTTON_RIGHT_FACE_RIGHT = 6,
    GAMEPAD_BUTTON_RIGHT_FACE_DOWN = 7,
    GAMEPAD_BUTTON_RIGHT_FACE_LEFT = 8,
    GAMEPAD_BUTTON_LEFT_TRIGGER_1 = 9,
    GAMEPAD_BUTTON_LEFT_TRIGGER_2 = 10,
    GAMEPAD_BUTTON_RIGHT_TRIGGER_1 = 11,
    GAMEPAD_BUTTON_RIGHT_TRIGGER_2 = 12,
    GAMEPAD_BUTTON_MIDDLE_LEFT = 13,
    GAMEPAD_BUTTON_MIDDLE = 14,
    GAMEPAD_BUTTON_MIDDLE_RIGHT = 15,
    GAMEPAD_BUTTON_LEFT_THUMB = 16,
    GAMEPAD_BUTTON_RIGHT_THUMB = 17
}

binds.GamepadAxis = {
    GAMEPAD_AXIS_LEFT_X        = 0,
    GAMEPAD_AXIS_LEFT_Y        = 1,
    GAMEPAD_AXIS_RIGHT_X       = 2,
    GAMEPAD_AXIS_RIGHT_Y       = 3,
    GAMEPAD_AXIS_LEFT_TRIGGER  = 4,
    GAMEPAD_AXIS_RIGHT_TRIGGER = 5
}

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


binds.TextureFilter = {
    TEXTURE_FILTER_POINT           = 0,
    TEXTURE_FILTER_BILINEAR        = 1,
    TEXTURE_FILTER_TRILINEAR       = 2,
    TEXTURE_FILTER_ANISOTROPIC_4X  = 3,
    TEXTURE_FILTER_ANISOTROPIC_8X  = 4,
    TEXTURE_FILTER_ANISOTROPIC_16X = 5
}

binds.CameraProjection = {
    CAMERA_PERSPECTIVE = 0,
    CAMERA_ORTHOGRAPHIC = 1
}

-- no Lua wrappers
local function append(dst, src)
    for k, v in pairs(src) do
        dst[k] = v
    end
end

append(binds, {
    CloseWindow = raylib.CloseWindow,
    WindowShouldClose = raylib.WindowShouldClose,
    IsWindowReady = raylib.IsWindowReady,
    IsWindowFullscreen = raylib.IsWindowFullscreen,
    IsWindowHidden = raylib.IsWindowHidden,
    IsWindowMinimized = raylib.IsWindowMinimized,
    IsWindowMaximized = raylib.IsWindowMaximized,
    IsWindowFocused = raylib.IsWindowFocused,
    IsWindowResized = raylib.IsWindowResized,
    ToggleFullscreen = raylib.ToggleFullscreen,
    ToggleBorderlessWindowed = raylib.ToggleBorderlessWindowed,
    MaximizeWindow = raylib.MaximizeWindow,
    MinimizeWindow = raylib.MinimizeWindow,
    RestoreWindow = raylib.RestoreWindow,
    SetWindowFocused = raylib.SetWindowFocused,
    GetScreenWidth = raylib.GetScreenWidth,
    GetScreenHeight = raylib.GetScreenHeight,
    GetRenderWidth = raylib.GetRenderWidth,
    GetRenderHeight = raylib.GetRenderHeight,
    GetMonitorCount = raylib.GetMonitorCount,
    GetCurrentMonitor = raylib.GetCurrentMonitor,
    EnableEventWaiting = raylib.EnableEventWaiting,
    DisableEventWaiting = raylib.DisableEventWaiting,
    ShowCursor = raylib.ShowCursor,
    HideCursor = raylib.HideCursor,
    IsCursorHidden = raylib.IsCursorHidden,
    EnableCursor = raylib.EnableCursor,
    DisableCursor = raylib.DisableCursor,
    IsCursorOnScreen = raylib.IsCursorOnScreen,
    BeginDrawing = raylib.BeginDrawing,
    EndDrawing = raylib.EndDrawing,
    EndMode2D = raylib.EndMode2D,
    EndMode3D = raylib.EndMode3D,
    EndTextureMode = raylib.EndTextureMode,
    EndShaderMode = raylib.EndShaderMode,
    EndBlendMode = raylib.EndBlendMode,
    EndScissorMode = raylib.EndScissorMode,
    EndVrStereoMode = raylib.EndVrStereoMode,
    GetFrameTime = raylib.GetFrameTime,
    GetTime = raylib.GetTime,
    GetFPS = raylib.GetFPS,
    SwapScreenBuffer = raylib.SwapScreenBuffer,
    PollInputEvents = raylib.PollInputEvents,
    IsFileDropped = raylib.IsFileDropped,
    StartAutomationEventRecording = raylib.StartAutomationEventRecording,
    StopAutomationEventRecording = raylib.StopAutomationEventRecording,
    GetKeyPressed = raylib.GetKeyPressed,
    GetCharPressed = raylib.GetCharPressed,
    GetGamepadButtonPressed = raylib.GetGamepadButtonPressed,
    GetMouseX = raylib.GetMouseX,
    GetMouseY = raylib.GetMouseY,
    GetMouseWheelMove = raylib.GetMouseWheelMove,
    GetTouchX = raylib.GetTouchX,
    GetTouchY = raylib.GetTouchY,
    GetTouchPointCount = raylib.GetTouchPointCount,
    GetGestureDetected = raylib.GetGestureDetected,
    GetGestureHoldDuration = raylib.GetGestureHoldDuration,
    GetGestureDragAngle = raylib.GetGestureDragAngle,
    GetGesturePinchAngle = raylib.GetGesturePinchAngle,
    InitWindow = raylib.InitWindow,
    IsWindowState = raylib.IsWindowState,
    SetWindowState = raylib.SetWindowState,
    ClearWindowState = raylib.ClearWindowState,
    SetWindowTitle = raylib.SetWindowTitle,
    SetWindowPosition = raylib.SetWindowPosition,
    SetWindowMonitor = raylib.SetWindowMonitor,
    SetWindowMinSize = raylib.SetWindowMinSize,
    SetWindowMaxSize = raylib.SetWindowMaxSize,
    SetWindowSize = raylib.SetWindowSize,
    SetWindowOpacity = raylib.SetWindowOpacity,
    GetMonitorWidth = raylib.GetMonitorWidth,
    GetMonitorHeight = raylib.GetMonitorHeight,
    GetMonitorPhysicalWidth = raylib.GetMonitorPhysicalWidth,
    GetMonitorPhysicalHeight = raylib.GetMonitorPhysicalHeight,
    GetMonitorRefreshRate = raylib.GetMonitorRefreshRate,
    SetClipboardText = raylib.SetClipboardText,
    BeginBlendMode = raylib.BeginBlendMode,
    BeginScissorMode = raylib.BeginScissorMode,
    SetTargetFPS = raylib.SetTargetFPS,
    WaitTime = raylib.WaitTime,
    SetRandomSeed = raylib.SetRandomSeed,
    GetRandomValue = raylib.GetRandomValue,
    UnloadRandomSequence = raylib.UnloadRandomSequence,
    TakeScreenshot = raylib.TakeScreenshot,
    SetConfigFlags = raylib.SetConfigFlags,
    OpenURL = raylib.OpenURL,
    SetTraceLogLevel = raylib.SetTraceLogLevel,
    TraceLog = raylib.TraceLog,
    MemFree = raylib.MemFree,
    UnloadFileData = raylib.UnloadFileData,
    SaveFileData = raylib.SaveFileData,
    ExportDataAsCode = raylib.ExportDataAsCode,
    UnloadFileText = raylib.UnloadFileText,
    SaveFileText = raylib.SaveFileText,
    FileRename = raylib.FileRename,
    FileRemove = raylib.FileRemove,
    FileCopy = raylib.FileCopy,
    FileMove = raylib.FileMove,
    FileTextReplace = raylib.FileTextReplace,
    FileTextFindIndex = raylib.FileTextFindIndex,
    FileExists = raylib.FileExists,
    DirectoryExists = raylib.DirectoryExists,
    IsFileExtension = raylib.IsFileExtension,
    GetFileLength = raylib.GetFileLength,
    GetFileModTime = raylib.GetFileModTime,
    MakeDirectory = raylib.MakeDirectory,
    ChangeDirectory = raylib.ChangeDirectory,
    IsPathFile = raylib.IsPathFile,
    IsFileNameValid = raylib.IsFileNameValid,
    GetDirectoryFileCount = raylib.GetDirectoryFileCount,
    GetDirectoryFileCountEx = raylib.GetDirectoryFileCountEx,
    ComputeCRC32 = raylib.ComputeCRC32,
    IsKeyPressed = raylib.IsKeyPressed,
    IsKeyPressedRepeat = raylib.IsKeyPressedRepeat,
    IsKeyDown = raylib.IsKeyDown,
    IsKeyReleased = raylib.IsKeyReleased,
    IsKeyUp = raylib.IsKeyUp,
    SetExitKey = raylib.SetExitKey,
    SetAutomationEventBaseFrame = raylib.SetAutomationEventBaseFrame,
    IsGamepadAvailable = raylib.IsGamepadAvailable,
    IsGamepadButtonPressed = raylib.IsGamepadButtonPressed,
    IsGamepadButtonDown = raylib.IsGamepadButtonDown,
    IsGamepadButtonReleased = raylib.IsGamepadButtonReleased,
    IsGamepadButtonUp = raylib.IsGamepadButtonUp,
    GetGamepadAxisCount = raylib.GetGamepadAxisCount,
    GetGamepadAxisMovement = raylib.GetGamepadAxisMovement,
    SetGamepadMappings = raylib.SetGamepadMappings,
    SetGamepadVibration = raylib.SetGamepadVibration,
    IsMouseButtonPressed = raylib.IsMouseButtonPressed,
    IsMouseButtonDown = raylib.IsMouseButtonDown,
    IsMouseButtonReleased = raylib.IsMouseButtonReleased,
    IsMouseButtonUp = raylib.IsMouseButtonUp,
    SetMousePosition = raylib.SetMousePosition,
    SetMouseOffset = raylib.SetMouseOffset,
    SetMouseScale = raylib.SetMouseScale,
    SetMouseCursor = raylib.SetMouseCursor,
    GetTouchPointId = raylib.GetTouchPointId,
    SetGesturesEnabled = raylib.SetGesturesEnabled,
    IsGestureDetected = raylib.IsGestureDetected,
})

-- return the table
return binds
