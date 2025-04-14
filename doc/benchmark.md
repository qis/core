# Benchmark

Prepare environments.

```sh
# Create private and benchmark directories.
mkdir -p ~/.local/private ~/.local/benchmark/drive_c
cp ~/downloads/Unigine_Heaven-4.0.run ~/.local/private/
cp ~/downloads/Unigine_Superposition-1.1.run ~/.local/private/
cp ~/downloads/Unigine_Heaven-4.0.exe ~/.local/benchmark/drive_c/
cp ~/downloads/Unigine_Superposition-1.1.exe ~/.local/benchmark/drive_c/

# Configure wine settings.
# * Set Graphics > Screen resolution to 216 DPI.
export WINEPREFIX="${HOME}/.local/benchmark"
export WINE_LARGE_ADDRESS_AWARE=1
winecfg

# Install vulkan-based d3d9/10/11 support.
setup_dxvk.sh install --symlink

# Install vulkan-based d3d12 support.
setup_vkd3d_proton.sh install --symlink
```

Install benchmarks.

```sh
# Install linux heaven.
firejail --private=~/.local/private sh ~/Unigine_Heaven-4.0.run

# Install linux superposition.
firejail --private=~/.local/private sh ~/Unigine_Superposition-1.1.run

# Install windows superposition to C:\Superposition.
env --chdir="${WINEPREFIX}/drive_c" wine64 Unigine_Superposition-1.1.exe
```

Run heaven benchmarks.

```sh
# Preset: Custom
# Quality: Low
# Tesselation: Moderate
# Stereo 3D: Disabled
# Multi-monitor: Disabled
# Anti-aliasing: Off
# Full Screen: [x]
# Resolution: 1280x800
# RUN
# F9

# Hyprland (Wayland Window): 2654 (105.4 FPS)
firejail --private=~/.local/private env --chdir=Unigine_Heaven-4.0 ./heaven

# Gamescope (Wayland Linear): 2232 (88.6 FPS)
gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F linear --rt --backend wayland -- \
firejail --private=~/.local/private env --chdir=Unigine_Heaven-4.0 ./heaven

# Gamescope (Wayland FSR): 1948 (77.3 FPS)
gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F fsr --rt --backend wayland -- \
firejail --private=~/.local/private env --chdir=Unigine_Heaven-4.0 ./heaven

# Gamescope (DRM Linear): 2723 (108.1 FPS)
gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F linear --rt --backend drm -- \
firejail --private=~/.local/private env --chdir=Unigine_Heaven-4.0 ./heaven

# Gamescope (DRM FSR): 2148 (85.3 FPS)
gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F fsr --rt --backend drm -- \
firejail --private=~/.local/private env --chdir=Unigine_Heaven-4.0 ./heaven

# Windows (OpenGL): 3362 (133.5 FPS)
# Windows (DirectX 11): 3092 (122.8 FPS)
```

Run superposition benchmarks.

```sh
# Preset: Custom
# Fullscreen: Enabled
# Resolution: 1280x800
# Shaders Quality: Medium
# Textures Quality: Medium
# Depth of Field: OFF
# Motion Blur: OFF
# RUN
# SUPER+F11
# F9

# Hyprland (Wayland Native): 6788 (50.7 FPS)
firejail --private=~/.local/private env --chdir=Unigine_Superposition-1.1 QT_QPA_PLATFORM=xcb ./Superposition

# Gamescope (Wayland Native): 6843 (51.1 FPS)
gamescope -b -f --rt --backend wayland -- \
firejail --private=~/.local/private env --chdir=Unigine_Superposition-1.1 QT_QPA_PLATFORM=xcb ./Superposition

# Gamescope (Wayland Linear): 6660 (49.8 FPS)
gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F linear --rt --backend wayland -- \
firejail --private=~/.local/private env --chdir=Unigine_Superposition-1.1 QT_QPA_PLATFORM=xcb ./Superposition

# Gamescope (Wayland FSR): 6107 (45.6 FPS)
gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F fsr --rt --backend wayland -- \
firejail --private=~/.local/private env --chdir=Unigine_Superposition-1.1 QT_QPA_PLATFORM=xcb ./Superposition

# Gamescope (DRM Native): 6479 (48.4 FPS)
gamescope -b -f --rt --backend drm -- \
firejail --private=~/.local/private env --chdir=Unigine_Superposition-1.1 QT_QPA_PLATFORM=xcb ./Superposition

# Gamescope (DRM Linear): 6476 (48.4 FPS)
gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F linear --rt --backend drm -- \
firejail --private=~/.local/private env --chdir=Unigine_Superposition-1.1 QT_QPA_PLATFORM=xcb ./Superposition

# Gamescope (DRM FSR): 5935 (44.3 FPS)
gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F fsr --rt --backend drm -- \
firejail --private=~/.local/private env --chdir=Unigine_Superposition-1.1 QT_QPA_PLATFORM=xcb ./Superposition

# Wine Hyprland (OpenGL Native): 6729 (50.3 FPS)
env --chdir="${WINEPREFIX}/drive_c/Superposition" wine64 C:/Superposition/Superposition.exe

# Wine Hyprland (DirectX Native): 6492 (48.5 FPS)
env --chdir="${WINEPREFIX}/drive_c/Superposition" wine64 C:/Superposition/Superposition.exe

# Wine Gamescope (DRM OpenGL Native):  ( FPS)
gamescope -b -f --rt --backend wayland -- \
env --chdir="${WINEPREFIX}/drive_c/Superposition" wine64 C:/Superposition/Superposition.exe

# Wine Gamescope (DRM DirectX Native):  ( FPS)
gamescope -b -f --rt --backend wayland -- \
env --chdir="${WINEPREFIX}/drive_c/Superposition" wine64 C:/Superposition/Superposition.exe

# Wine Gamescope (DRM OpenGL Linear):  ( FPS)
gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F linear --rt --backend drm -- \
env --chdir="${WINEPREFIX}/drive_c/Superposition" wine64 C:/Superposition/Superposition.exe

# Wine Gamescope (DRM DirectX Linear):  ( FPS)
gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F linear --rt --backend drm -- \
env --chdir="${WINEPREFIX}/drive_c/Superposition" wine64 C:/Superposition/Superposition.exe

# Wine Gamescope (DRM OpenGL FSR):  ( FPS)
gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F fsr --rt --backend drm -- \
env --chdir="${WINEPREFIX}/drive_c/Superposition" wine64 C:/Superposition/Superposition.exe

# Wine Gamescope (DRM DirectX FSR):  ( FPS)
gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F fsr --rt --backend drm -- \
env --chdir="${WINEPREFIX}/drive_c/Superposition" wine64 C:/Superposition/Superposition.exe

# Windows (OpenGL): 5977 (44.7 FPS)
# Windows (DirectX): 6655 (49.7 FPS)
```
