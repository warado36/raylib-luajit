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
// const char *GetMonitorName(int monitor);
// const char *GetGamepadName(int gamepad);
// const char *GetKeyName(int key);
unsigned int *ComputeMD5(unsigned char *data, int dataSize);
unsigned int *ComputeSHA1(unsigned char *data, int dataSize);
unsigned int *ComputeSHA256(unsigned char *data, int dataSize);
unsigned char *CompressData(const unsigned char *data, int dataSize, int *compDataSize);
unsigned char *DecompressData(const unsigned char *compData, int compDataSize, int *dataSize);
char *EncodeDataBase64(const unsigned char *data, int dataSize, int *outputSize);
unsigned char *DecodeDataBase64(const char *text, int *outputSize);
// const char *GetFileExtension(const char *fileName);
// const char *GetFileName(const char *filePath);
// const char *GetFileNameWithoutExt(const char *filePath);
// const char *GetDirectoryPath(const char *filePath);
// const char *GetPrevDirectoryPath(const char *dirPath);
// char *LoadFileText(const char *fileName);
unsigned char *LoadFileData(const char *fileName, int *dataSize);
void *MemAlloc(unsigned int size);
void *MemRealloc(void *ptr, unsigned int size);
int *LoadRandomSequence(unsigned int count, int min, int max);



//
//

void UpdateCamera(Camera *camera, int mode);
void UpdateCameraPro(Camera *camera, Vector3 movement, Vector3 rotation, float zoom);
void SetWindowIcon(Image image);
void SetWindowIcons(Image *images, int count);
void ClearBackground(Color color);
void BeginMode2D(Camera2D camera);
void BeginMode3D(Camera3D camera);
void BeginTextureMode(RenderTexture2D target);
void BeginShaderMode(Shader shader);
void BeginVrStereoMode(VrStereoConfig config);
void UnloadVrStereoConfig(VrStereoConfig config);
bool IsShaderValid(Shader shader);
int GetShaderLocation(Shader shader, const char *uniformName);
int GetShaderLocationAttrib(Shader shader, const char *attribName);
void SetShaderValue(Shader shader, int locIndex, const void *value, int uniformType);
void SetShaderValueV(Shader shader, int locIndex, const void *value, int uniformType, int count);
void SetShaderValueMatrix(Shader shader, int locIndex, Matrix mat);
void SetShaderValueTexture(Shader shader, int locIndex, Texture2D texture);
void UnloadShader(Shader shader);
void SetTraceLogCallback(TraceLogCallback callback);
void SetLoadFileDataCallback(LoadFileDataCallback callback);
void SetSaveFileDataCallback(SaveFileDataCallback callback);
void SetLoadFileTextCallback(LoadFileTextCallback callback);
void SetSaveFileTextCallback(SaveFileTextCallback callback);
void UnloadDirectoryFiles(FilePathList files);
void UnloadDroppedFiles(FilePathList files);
void UnloadAutomationEventList(AutomationEventList list);
bool ExportAutomationEventList(AutomationEventList list, const char *fileName);
void SetAutomationEventList(AutomationEventList *list);
void PlayAutomationEvent(AutomationEvent event);



AutomationEventList LoadAutomationEventList(const char *fileName);
FilePathList LoadDirectoryFiles(const char *dirPath);
FilePathList LoadDirectoryFilesEx(const char *basePath, const char *filter, bool scanSubdirs);
Shader LoadShader(const char *vsFileName, const char *fsFileName);
Shader LoadShaderFromMemory(const char *vsCode, const char *fsCode);
Vector2 GetMonitorPosition(int monitor);
Vector2 GetTouchPosition(int index);



Ray GetScreenToWorldRay(Vector2 position, Camera camera);
Ray GetScreenToWorldRayEx(Vector2 position, Camera camera, int width, int height);
Vector2 GetWorldToScreen(Vector3 position, Camera camera);
Vector2 GetWorldToScreenEx(Vector3 position, Camera camera, int width, int height);
Vector2 GetWorldToScreen2D(Vector2 position, Camera2D camera);
Vector2 GetScreenToWorld2D(Vector2 position, Camera2D camera);
Matrix GetCameraMatrix(Camera camera);
Matrix GetCameraMatrix2D(Camera2D camera);
VrStereoConfig LoadVrStereoConfig(VrDeviceInfo device);
