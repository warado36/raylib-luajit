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