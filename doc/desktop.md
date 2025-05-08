# Desktop

```sh
# Check fonts cache.
fc-list | grep "Font Awesome 6 Pro"

# Check desktop portal configuration.
/usr/libexec/xdg-desktop-portal -v 2>&1 | grep -iE '(hyprland|gtk)'

# Check hyprland desktop portal service status.
systemctl --user status xdg-desktop-portal-hyprland

# Monitor system resources.
# Press `p` to cycle through presets.
btop

# Lock screen.
lock

# Unlock screen in TTY 2-6.
unlock

# Take screenshot of the active screen.
screenshot screen

# Take screenshot of the active window.
screenshot window

# Take screenshot of a screen region.
screenshot region

# Show image in the terminal.
view documents/image/test.png

# Show image in a wayland window.
imv documents/image/test.png

# Play audio using SoX.
play documents/audio/test.flac
play documents/audio/test.mp3
play documents/audio/test.ogg

# Play audio using MPV.
mpv documents/audio/test.flac
mpv documents/audio/test.mp3
mpv documents/audio/test.ogg

# Play video using MPV.
mpv documents/video/test.mp4

# Record screen to a specific file.
record ~/test.mkv

# Record screen to a file in $(xdg-user-dir VIDEOS).
record
```

## Configuration

```sh
# Configure GTK applications.
gsettings set org.gnome.desktop.interface scaling-factor 1
gsettings set org.gnome.desktop.interface text-scaling-factor 0.8
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface cursor-size 24

# Configure Qt applications.
qt6ct

# Configure wofi.
mkdir ~/.config/wofi

tee ~/.config/wofi/config >/dev/null <<'EOF'
term=footclient
allow-images=true
allow-markup=true
matching=fuzzy
EOF

tee ~/.config/wofi/style.css >/dev/null <<'EOF'
* { border-radius: 0; }
EOF

# Configure pip.
rm -rf ~/.pip; mkdir ~/.pip
pip config set global.target ~/.pip

# Configure npm.
rm -rf ~/.npm; mkdir ~/.npm
npm config set prefix ~/.npm

# Install npm packages.
npm install -g npm
npm install -g \
  typescript typescript-language-server eslint prettier terser \
  rollup @rollup/plugin-typescript rollup-plugin-terser \
  rollup-plugin-serve rollup-plugin-livereload neovim
```

## Applications
Press SUPER + SPACE to open the applications menu and show desktop entries from all `${XDG_DATA_DIRS}`
except `/usr/share/applications`.

1. Copy `.desktop` file to `~/.local/share/applications/<name>.desktop`:
   * Add the `Hidden=true` property to `[Desktop Entry]` in the copied file.

2. Copy `.desktop` file to `~/.local/share/applications/core-<name>.desktop`:
   * Remove `Name` translations.
   * Remove `GenericName` properties.
   * Remove `Categories` properties.
   * Remove `Comment` properties.
   * Remove `Keywords` properties.
   * Remove `MimeType` properties.

Possible optimizations:
* Add `-style Adwaita-dark` to Qt applications "Exec" entries.
* Add `env KRITA_NO_STYLE_OVERRIDE=1 QT_SCALE_FACTOR=2 ...` to the Krita `Exec` entry.
* Add `env QT_SCALE_FACTOR=2 ...` for the Scribus `Exec` entry and remove the `TryExec` entry.

## Printing

```
Connect to http://localhost:631/admin and add printer.
[Find New Printers]
  Connection: socket://10.0.0.99
  Name: Note
  Description: Canon MF244dw
  Location: Local Printer
  Make: Generic
  Model: Generic PCL Laser Printer
```

## Flatpak

```sh
# Delete user directories.
# rm -rf ~/.cache/flatpak ~/.local/share/flatpak ~/.var

# Configure permissions.
flatpak override --user --reset
flatpak override --user --filesystem=${HOME}/.cache/fontconfig:ro
flatpak override --user --filesystem=${HOME}/.config/qt6ct:ro
flatpak override --user --filesystem=${HOME}/.config/user-dirs.dirs:ro
flatpak override --user --filesystem=${HOME}/.config/user-dirs.locale:ro
flatpak override --user --filesystem=${HOME}/.fonts:ro
flatpak override --user --show

# Add flathub repository.
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Adwaita Qt theme.
for i in $(flatpak remote-ls --columns=ref flathub | grep runtime/org.kde.KStyle.Adwaita/x86_64/); do
  flatpak install -y flathub $i
done

# Find application by name.
#flatpak search floorp

# Install browser.
flatpak install one.ablaze.floorp

# Install creation suite.
flatpak install org.blender.Blender
flatpak uninstall --delete-data org.blender.Blender
flatpak uninstall --unused

# Install a digital art studio.
# TODO: Document OpenColorIO for Krita and Blender.
flatpak install org.kde.krita

# Install procedural texture generator.
flatpak install io.github.RodZill4.Material-Maker

# Install development environment.
flatpak install com.vscodium.codium
flatpak uninstall --delete-data com.vscodium.codium
flatpak uninstall --unused

# Install chat client.
flatpak install org.telegram.desktop

# Install office suite.
flatpak install org.libreoffice.LibreOffice
flatpak install org.texstudio.TeXstudio
flatpak install br.eng.silas.qpdftools

# Install streaming software.
flatpak install com.obsproject.Studio

# Install audio recorder.
flatpak install org.tenacityaudio.Tenacity

# Install Zrythm digital audio workstation.
# Version 1.0.0 can't record audio.
# flatpak install org.zrythm.Zrythm
# flatpak override --user org.zrythm.Zrythm --filesystem="$(xdg-user-dir MUSIC)"
# flatpak run org.zrythm.Zrythm

# Uninstall Zrythm digital audio workstation.
# flatpak uninstall --delete-data org.zrythm.Zrythm
# flatpak uninstall --unused

# =============================================================================
# TODO: Not yet tested.
# =============================================================================

# Install Qtractor digital audio workstation.
# flatpak install org.rncbc.qtractor

# Install MuseE digital audio workstation.
# flatpak install io.github.muse_sequencer.Muse

# Install Bespoke modular digital audio workstation.
# flatpak install com.bespokesynth.BespokeSynth
```

## Armor Tools
<https://github.com/armory3d/armortools>

```sh
# Enter workspace.
cd ~/workspace

# Clone sources.
git clone --recurse https://github.com/armory3d/armortools

# Enter sources.
cd armortools

# Generate locale.
./armorcore/make --js base/tools/extract_locales.js en

# Compile and test Armor Paint.
env --chdir=armorpaint ../armorcore/make --graphics opengl --run
armorpaint/build/out/ArmorPaint

# Compile and test Armor Lab.
env --chdir=armorlab ../armorcore/make --graphics opengl --run
LD_LIBRARY_PATH=armorlab/build/out armorlab/build/out/ArmorLab

# Create icons directory.
mkdir -p ~/.local/share/icons/hicolor/256x256/apps

# Create icons theme.
tee ~/.local/share/icons/hicolor/index.theme >/dev/null <<'EOF'
[Icon Theme]
Name=Hicolor
Comment=Fallback icon theme
Hidden=true
Directories=256x256/apps,256x256@2/apps

[256x256/apps]
MinSize=64
Size=256
MaxSize=256
Context=Applications
Type=Scalable

[256x256@2/apps]
MinSize=64
Size=256
Scale=2
MaxSize=256
Context=Applications
Type=Scalable
EOF

# Install icons.
cp armorpaint/icon.png ~/.local/share/icons/hicolor/256x256/apps/armorpaint.png
cp armorlab/icon.png ~/.local/share/icons/hicolor/256x256/apps/armorlab.png

# Create desktop files.
tee ~/.local/share/applications/armorpaint.desktop >/dev/null <<'EOF'
[Desktop Entry]
Name=Armor Paint
Exec=/home/qis/workspace/armortools/armorpaint/build/out/ArmorPaint
Icon=armorpaint
Terminal=false
Type=Application
EOF

tee ~/.local/share/applications/armorlab.desktop >/dev/null <<'EOF'
[Desktop Entry]
Name=Armor Lab
Exec=env LD_LIBRARY_PATH=/home/qis/workspace/armortools/armorlab/build/out /home/qis/workspace/armortools/armorlab/build/out/ArmorLab
Icon=armorlab
Terminal=false
Type=Application
EOF

# Update icons cache.
gtk-update-icon-cache ~/.local/share/icons/hicolor

# Update applications menu.
xdg-desktop-menu forceupdate
```

## Path of Exile

```sh
# Create game directory.
export WINEPREFIX="${HOME}/.local/games/poe"
mkdir -p "${WINEPREFIX}/drive_c/PoE"

# Configure wine settings.
# * Set Graphics > Screen resolution to 216 DPI.
# * Set Applications > Default Settings > Windows Version to Windows 11.
# * Set Desktop Integration > WinRT theme to Dark.
winecfg

# Install vulkan-based d3d9/10/11 support.
setup_dxvk.sh install --symlink

# Install vulkan-based d3d12 support.
setup_vkd3d_proton.sh install --symlink

# Install game.
# * Set installation directory to "C:\PoE" in "Options".
env --chdir="${WINEPREFIX}/drive_c/PoE" wine64 ~/downloads/PathOfExileInstaller.exe
env --chdir="${WINEPREFIX}/drive_c/PoE" wine64 PathOfExile.exe

# Create game launcher.
tee ~/.local/bin/poe >/dev/null <<'EOF'
#!/bin/sh
set -e
export WINE_LARGE_ADDRESS_AWARE=1
export WINEPREFIX="${HOME}/.local/games/poe"
cd "${WINEPREFIX}/drive_c/PoE"

if [ -z "${1}" ]; then
  wine PathOfExile.exe
  exit $?
fi

if [ "${1}" != "drm" ] && [ "${1}" != "wayland" ]; then
  echo "usage: poe [drm|wayland]"
  exit 1
fi

gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F fsr -r 60 -o 30 -s 0.5 -g \
  --adaptive-sync --rt --backend "${1}" --force-windows-fullscreen -- wine PathOfExile.exe
EOF

chmod +x ~/.local/bin/poe

# Test game using protin wine.
# This will not accept mouse clicks.
poe

# Test game using gamescope on wayland.
# This will not accept mouse clicks.
poe wayland

# Test game using gamescope in a TTY.
# This will not accept mouse clicks.
poe drm
```

## Transistor

```sh
# Enter game directory.
cd ~/.local/games/transistor

# Configure wine prefix.
export WINEPREFIX="${HOME}/.local/games/transistor/wine"

# Configure wine settings.
# 1. Set Graphics > Screen resolution to 216 DPI.
# 2. Set Applications > Default Settings > Windows Version to Windows 11.
# 3. Set Desktop Integration > WinRT theme to Dark.
winecfg

# Install vulkan-based d3d9/10/11 support.
setup_dxvk.sh install --symlink

# Install vulkan-based d3d12 support.
setup_vkd3d_proton.sh install --symlink

# Create launcher.
tee ~/.local/bin/transistor >/dev/null <<'EOF'
#!/bin/sh
set -e
export WINEPREFIX="${HOME}/.local/games/transistor/wine"
cd ${HOME}/.local/games/transistor

if [ -z "${1}" ]; then
  echo "usage: transistor drm|wayland|wine"
  exit 1
fi

case "${1}" in
wine)
  wine Transistor.exe
  exit $?
  ;;
*)
  ;;
esac

gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F fsr -r 60 -o 30 -s 0.5 -g \
  --adaptive-sync --rt --backend "${1}" --force-windows-fullscreen -- wine Transistor.exe
EOF

chmod +x ~/.local/bin/transistor

# Test game using protin wine.
# This will not accept mouse clicks.
transistor wine

# Test game using gamescope on wayland.
# This will not accept mouse clicks.
transistor wayland

# Test game using gamescope in a TTY.
# This will not accept mouse clicks.
transistor drm
```
