# 📦 FlowVault - Build & Distribution Guide

## Build Scripts Reference

```json
{
  "dev": "Vite dev server + TypeScript watch",
  "build": "Build both React and Electron",
  "build:react": "Vite production build",
  "build:electron": "TypeScript compile main process",
  "start": "Launch built app",
  "start:dev": "Development mode with hot reload",
  "electron:dev": "TypeScript + Electron watch",
  "pack": "Create unpackaged distribution",
  "dist": "Create OS-specific installers"
}
```

## Development Workflow

### 1. Start Development Server

```bash
npm run start:dev
```

This command:
- Starts Vite dev server on http://localhost:5173
- Watches main process TypeScript files
- Auto-reloads Electron on file changes
- Opens DevTools automatically

### 2. Make Changes

- **Renderer Changes** (React components):
  - Edit files in `src/renderer/`
  - Hot reload happens automatically
  - Refresh browser to see changes

- **Main Process Changes**:
  - Edit files in `src/main/`
  - TypeScript recompiles automatically
  - Electron reloads automatically

- **Shared Types**:
  - Edit `src/shared/types.ts`
  - Affects both main and renderer

### 3. Test Locally

- Use DevTools (F12) to debug renderer
- Check console for IPC messages
- Test all user interactions

## Building for Production

### Step 1: Production Build

```bash
npm run build
```

This creates:
- `dist/` - React production build
- `dist-electron/` - Compiled TypeScript

### Step 2: Create Installers

```bash
npm run dist
```

Creates platform-specific installers in `dist/` directory

## Platform-Specific Instructions

### macOS

```bash
npm run build
npm run dist
```

Generates:
- `dist/FlowVault-1.0.0.dmg` - Drag-and-drop installer
- `dist/FlowVault-1.0.0-mac.zip` - Portable ZIP

**Requirements:**
- macOS 10.15 or later
- Apple Developer certificate (optional, for notarization)

**Installation:**
1. Download .dmg file
2. Drag FlowVault to Applications folder
3. Launch from Applications

### Windows

```bash
npm run build
npm run dist
```

Generates:
- `dist/FlowVault Setup 1.0.0.exe` - NSIS installer
- `dist/FlowVault 1.0.0.exe` - Portable executable

**Requirements:**
- Windows 7 or later
- ~200MB free disk space

**Installation:**
1. Download .exe installer
2. Run installer
3. Follow setup wizard
4. Launch from Start menu

### Linux

```bash
npm run build
npm run dist
```

Generates:
- `dist/flowvault-1.0.0.AppImage` - Portable AppImage
- `dist/flowvault_1.0.0_amd64.deb` - Debian package
- `dist/flowvault-1.0.0-1.x86_64.rpm` - RPM package

**Installation:**

For AppImage:
```bash
chmod +x flowvault-1.0.0.AppImage
./flowvault-1.0.0.AppImage
```

For Debian:
```bash
sudo dpkg -i flowvault_1.0.0_amd64.deb
flowvault  # Launch from terminal
```

For RPM:
```bash
sudo rpm -i flowvault-1.0.0-1.x86_64.rpm
flowvault  # Launch from terminal
```

## Code Signing & Notarization

### macOS Code Signing

For Mac App Store or Notarization:

1. **Get Developer Certificate**
   - Apple Developer Account required
   - Get certificate from Keychain Access

2. **Update electron-builder config**
   ```json
   {
     "mac": {
       "certificateFile": "/path/to/certificate.p12",
       "certificatePassword": "password",
       "signingIdentity": "Developer ID Application"
     }
   }
   ```

3. **Build with signing**
   ```bash
   npm run dist
   ```

### Windows Code Signing

1. **Get Code Signing Certificate**
   - DigiCert, Sectigo, or similar provider

2. **Update electron-builder config**
   ```json
   {
     "win": {
       "certificateFile": "/path/to/certificate.pfx",
       "certificatePassword": "password",
       "signingHashAlgorithms": ["sha256"]
     }
   }
   ```

3. **Build with signing**
   ```bash
   npm run dist
   ```

## Version Management

### Update Version Number

Edit `package.json`:
```json
{
  "version": "1.0.1",  // Change this
  "name": "flowvault"
}
```

Version format: `MAJOR.MINOR.PATCH`
- MAJOR: Breaking changes
- MINOR: New features
- PATCH: Bug fixes

Example: `1.0.0` → `1.0.1` (bug fix)

## Auto-Update Implementation

### Setup Update Server

The app checks for updates on startup:

```typescript
// In main.ts
autoUpdater.checkForUpdates();

// On update available
autoUpdater.on('update-available', () => {
  // Show update notification
});

// After download
autoUpdater.on('update-downloaded', () => {
  // Show restart dialog
});

// User clicks "Install & Restart"
autoUpdater.quitAndInstall();
```

### Configure Update Server

Edit `package.json`:
```json
{
  "publish": {
    "provider": "github",  // or "s3", "generic"
    "owner": "your-org",
    "repo": "flowvault",
    "releaseType": "release"
  }
}
```

### Deploy Updates

1. Build new version
2. Create GitHub Release with installer files
3. App automatically detects and installs

## Debugging Builds

### Debug Compiled App

```bash
# Build without packaging
npm run pack

# Run built app with DevTools
npm start
```

Press F12 to open DevTools.

### Debug Build Process

```bash
# Verbose build output
npm run dist --verbose

# Keep build temp files
npm run dist --keep-build-dir
```

### Common Build Issues

**Issue: "Signing failed"**
```
Solution: Check certificate path and password
npm run dist -- --verbose
```

**Issue: "Out of memory"**
```
Solution: Increase Node memory
NODE_OPTIONS=--max-old-space-size=4096 npm run dist
```

**Issue: "Cannot find module"**
```
Solution: Rebuild native dependencies
npm rebuild
npm run build
```

## Distribution Methods

### Method 1: GitHub Releases

Best for: Open source projects

```bash
# Create GitHub release
# Upload .exe, .dmg, .AppImage files
# Users download from releases page
```

### Method 2: Website Download

Best for: Commercial products

```
Website structure:
/
├── /download
│   ├── flowvault-mac-x64.dmg
│   ├── flowvault-win-x64.exe
│   └── flowvault-linux-x64.AppImage
```

### Method 3: Package Manager

#### Homebrew (macOS)

```bash
# Create tap
brew tap your-org/flowvault
brew install flowvault
```

#### Chocolatey (Windows)

```bash
# Publish to Chocolatey
choco install flowvault
```

#### Snapcraft (Linux)

```bash
# Create snap
snap install flowvault
```

### Method 4: App Stores

#### Microsoft Store

1. Get Microsoft Partner account
2. Create app package (.appx)
3. Submit for review
4. Published in Store

#### Mac App Store

1. Get Apple Developer account
2. Code sign for MAS
3. Build .app package
4. Submit for review

## Performance Optimization

### Reduce App Size

```bash
# Enable code splitting
npm run build -- --analyze

# Use dynamic imports
const component = React.lazy(() => import('./Heavy'));

# Minimize dependencies
npm list --depth=0
npm prune --production
```

### Faster Startup

```typescript
// Lazy load heavy modules
import('openai').then(module => {
  // Use OpenAI
});

// Use setTimeout for non-critical initialization
setTimeout(() => {
  initializeHeavyService();
}, 5000);
```

## Deployment Checklist

- [ ] All tests passing
- [ ] No console errors
- [ ] Version number updated
- [ ] Release notes prepared
- [ ] Code signed (if required)
- [ ] Installers tested on each platform
- [ ] Update server configured
- [ ] Documentation updated
- [ ] Release notes published
- [ ] Users notified

## Post-Release

### Monitor

- Track crash reports (via Sentry if enabled)
- Monitor GitHub issues
- Collect user feedback

### Maintenance

- Fix critical bugs immediately
- Patch security vulnerabilities ASAP
- Plan next version features
- Update dependencies monthly

## Useful Commands Reference

```bash
# Development
npm run start:dev          # Start dev mode
npm run build             # Production build
npm run pack              # Create unpackaged dist
npm run dist              # Create installers

# Testing
npm run test              # Run tests (future)
npm run lint              # Lint code (future)

# Cleaning
rm -rf dist/              # Remove build output
rm -rf dist-electron/     # Remove compiled main
rm -rf node_modules/      # Remove dependencies

# Debugging
npm run dist -- --verbose # Verbose build output
npm start                 # Run built app
```

## Resources

- **Electron Builder Docs**: https://www.electron.build/
- **Code Signing Guide**: https://www.electron.build/code-signing
- **Publishing**: https://www.electron.build/publishing
- **Auto Update**: https://www.electron.build/auto-update

---

**Remember:** Always test on actual hardware before releasing to users!
