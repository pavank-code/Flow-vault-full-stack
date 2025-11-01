# 🎯 FlowVault MVP - Getting Started Guide

## 📱 System Requirements

- **Node.js**: v18.0.0 or higher
- **npm**: v9.0.0 or higher
- **OS**: macOS 10.15+, Windows 7+, or Linux (Ubuntu 18.04+)
- **Disk Space**: ~500MB for installation + database

## 🚀 Installation & Launch (5 minutes)

### Step 1: Verify Prerequisites

```bash
node --version  # Should be v18+
npm --version   # Should be v9+
```

### Step 2: Install Dependencies

```bash
cd flowvault
npm install
```

Expected output:
```
added 1234 packages in 45s
```

### Step 3: Launch Development Mode

**On macOS/Linux:**
```bash
npm run start:dev
```

**On Windows (PowerShell):**
```powershell
npm run start:dev
```

**Or use the Windows batch file:**
```
Double-click start-dev.bat
```

Wait for the Electron window to appear (usually 10-15 seconds).

## 🎮 First Steps in the App

### 1. Capture Your First Context

Click the **"Capture Context"** button in the top-right:
- The app will scan your current environment
- Creates a mock context with sample files and browser tabs
- Stores in local SQLite database
- Shows a confirmation message

### 2. View Captured Contexts

The main panel displays all captured contexts as cards:
- **Title**: Auto-generated from context metadata
- **Timestamp**: When the context was captured
- **Summary**: AI-generated summary of your work
- **Metadata**: Number of files, browser tabs, terminals
- **Focus Depth**: Score 0-100 (higher = deeper focus)

### 3. Restore a Context

Click the **"Restore"** button on any context card:
- Simulates opening files at saved positions
- Shows the AI summary
- In a full implementation, would open files in your editor

### 4. Use AI Chat

Click **"AI Chat"** button to open the chat panel:
- Type any question about your work
- Get AI-powered suggestions
- Chat history is maintained
- Examples:
  - "What should I work on next?"
  - "Help me debug this issue"
  - "Summarize my current context"

### 5. Search Contexts

Click **"Search"** button to open search:
- Type to search through all captured contexts
- Real-time filtering by title/summary
- Results appear instantly

## ⌨️ Keyboard Shortcuts

| Shortcut | Action | OS |
|----------|--------|-----|
| Cmd+Shift+C | Quick Capture | macOS |
| Ctrl+Shift+C | Quick Capture | Windows/Linux |
| Cmd+Shift+R | Quick Restore | macOS |
| Ctrl+Shift+R | Quick Restore | Windows/Linux |
| Cmd+Shift+A | AI Chat | macOS |
| Ctrl+Shift+A | AI Chat | Windows/Linux |

## 🏗️ Understanding the Architecture

```
Electron App
├── Main Process (Node.js)
│   ├── Database Service (SQLite)
│   ├── Context Capture Service
│   └── AI Assistant Service
│
└── Renderer Process (React)
    ├── Context Store (Zustand)
    ├── UI Components
    │   ├── ContextCard
    │   ├── AIChatPanel
    │   └── SearchPanel
    └── Styles (CSS)
```

### Data Flow

1. **User clicks "Capture"** → IPC message to main process
2. **Main process** → DatabaseService stores context
3. **DatabaseService** → Saves to local SQLite DB
4. **Main process** → Sends context to renderer via IPC
5. **Renderer** → Updates Zustand store
6. **UI** → React re-renders with new context card

## 🗄️ Database

### Location
```
Linux/Mac:   ~/.flowvault/flowvault.db
Windows:     C:\Users\[YourUsername]\AppData\Roaming\flowvault\flowvault.db
```

### Schema
```
Tables:
├── contexts (main context records)
├── files (captured file data)
├── browser_tabs (future)
└── terminal_sessions (future)
```

### Access Database

Install SQLite CLI:
```bash
# macOS
brew install sqlite

# Linux
sudo apt-get install sqlite3

# Windows
# Download from https://www.sqlite.org/download.html
```

Browse database:
```bash
sqlite3 ~/.flowvault/flowvault.db
.tables              # List tables
SELECT * FROM contexts;  # View all contexts
.quit                # Exit
```

## 🔧 Configuration

### Optional: OpenAI API Integration

To enable real AI responses (instead of mocked):

1. Get API key from https://platform.openai.com/api-keys
2. Create `.env` file in project root:
```env
OPENAI_API_KEY=sk_test_your_key_here
OPENAI_MODEL=gpt-4-turbo-preview
```

3. Restart the app

## 🐛 Troubleshooting

### Issue: "Port 5173 already in use"

**Solution**: Kill the process or use a different port

```bash
# macOS/Linux
lsof -i :5173
kill -9 <PID>

# Windows PowerShell
netstat -ano | findstr :5173
taskkill /PID <PID> /F
```

### Issue: "Cannot find module"

**Solution**: Reinstall dependencies

```bash
rm -rf node_modules
npm install
```

### Issue: "Database is locked"

**Solution**: Close app and restart

```bash
# Kill any remaining Electron processes
ps aux | grep electron
kill -9 <PID>
```

### Issue: App won't start

**Solution**: Check Node.js version

```bash
node --version  # Must be v18+
npm --version   # Must be v9+
```

### Issue: Blank white window

**Solution**: Check DevTools console (press F12)

```bash
# If you see errors, check:
1. All dependencies installed: npm install
2. Node version: node --version
3. Port 5173 available
```

## 📦 Building for Production

### Create Distribution Packages

```bash
# Build React + TypeScript
npm run build

# Create OS-specific installers
npm run dist
```

### Output Files
```
dist/
├── FlowVault-1.0.0.dmg (macOS)
├── FlowVault Setup 1.0.0.exe (Windows)
└── flowvault-1.0.0.AppImage (Linux)
```

## 📚 Project Files Overview

| File | Purpose |
|------|---------|
| `src/main/main.ts` | Electron entry point, window management, IPC handlers |
| `src/renderer/App.tsx` | Main React component |
| `src/renderer/store/contextStore.ts` | State management with Zustand |
| `src/main/services/database.ts` | SQLite operations |
| `src/main/services/contextCapture.ts` | Context capture logic |
| `src/main/services/aiAssistant.ts` | AI chat service |
| `package.json` | Dependencies and build scripts |
| `vite.config.ts` | Build configuration |

## 💡 Tips & Tricks

### Faster Development
- Keep DevTools open for real-time errors: `F12`
- Use hot reload: Changes auto-apply without restart
- Console logs appear in terminal and DevTools

### Testing Locally
- Create multiple contexts with capture button
- Try searching with different keywords
- Test AI chat with various prompts
- Restore different contexts multiple times

### File Organization
- Captured contexts organized by timestamp
- Search helps find specific contexts
- Can extend with tags in future versions

## 🎓 Learning Path

1. **Explore the UI** (5 mins)
   - Click through all buttons
   - Capture a context
   - Open AI chat

2. **Read the Code** (15 mins)
   - Open `src/main/main.ts` - understand IPC
   - Open `src/renderer/App.tsx` - see React structure
   - Open `src/shared/types.ts` - understand data models

3. **Modify Something** (30 mins)
   - Change button colors in `App.css`
   - Modify mock data in `contextCapture.ts`
   - Add new search filter in `SearchPanel.tsx`

4. **Add a Feature** (1-2 hours)
   - Add context tagging
   - Implement context deletion
   - Create export to JSON feature

## 🚀 Next Steps

1. **Test all features** thoroughly
2. **Report any bugs** with reproduction steps
3. **Extend with custom features** for your workflow
4. **Deploy** to production when ready

## 📖 Additional Resources

- **Electron Documentation**: https://www.electronjs.org/docs
- **React Hooks**: https://react.dev/reference/react/hooks
- **TypeScript**: https://www.typescriptlang.org/docs/
- **SQLite**: https://www.sqlite.org/docs.html
- **Zustand**: https://github.com/pmndrs/zustand

## ❓ FAQ

**Q: Can I use this on macOS, Windows, and Linux?**
A: Yes! The app is cross-platform. Download the installer for your OS.

**Q: Is my data stored online?**
A: No, all contexts are stored locally in SQLite. No cloud sync in MVP.

**Q: Can I delete captured contexts?**
A: Yes, click the trash icon on any context card (implementation in full version).

**Q: How much data can I store?**
A: Limited by your disk space. ~10MB per 1000 contexts on average.

**Q: Can I share contexts with others?**
A: In the MVP, sharing is manual (export/import). Full version has cloud sync.

## 📞 Support

For issues:
1. Check this guide's Troubleshooting section
2. Check the PRD (PRd.txt) for feature details
3. Review TypeScript types in `src/shared/types.ts`
4. Check app console (F12) for error messages

---

**Happy Coding! 🎉**

Remember: The goal of FlowVault is to help you maintain deep focus and never lose context of your work. Happy capturing!
