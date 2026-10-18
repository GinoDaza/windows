# Custom new tab page in Edge (Windows)

The page itself lives in its own repo (`newtab`) and is published at https://ginodaza.github.io/newtab/. This note covers the manual steps around it that are easy to forget.

## Why an extension

Vimium cannot run on Edge's built-in new tab page. The extension in `windows/newtab/ext/` only redirects every new tab to the GitHub Pages site, which is a normal page where Vimium works.

## 1. Install the extension

1. Copy `windows/newtab/ext/` to `C:\Users\ginoD\newtab-ext`.
2. Open `edge://extensions` and turn on **Developer mode**.
3. Click **Load unpacked** and pick that folder.
4. Optional: on the extension's **Details** page, turn on **Allow in InPrivate**. Without it, InPrivate windows show Edge's own heavy new tab page.

Extensions are per profile, so repeat this in every Edge profile.

## 2. Vimium

- **Options > Advanced options > Default new tab URL**: `https://ginodaza.github.io/newtab/`. Without it, `t` opens Vimium's own blank page instead of the custom one.
- Default keys worth knowing: `t` new tab, `T` search open tabs, `o` open URL or bookmark in the current tab, `O` in a new tab, `b` / `B` same for bookmarks only.

## 3. Edge settings (per profile)

- `edge://settings/onStartup`: **Open tabs from the previous session**.
- `edge://settings/clearBrowsingDataOnClose`: keep history and cookies off, or the session is lost on close.

## 4. Data and backups

- The shortcuts are stored in `localStorage`, which is separate for each address: `localhost:8000` and `ginodaza.github.io` do not share them. Edit them on the `github.io` page.
- Back them up with the gear icon, then the download icon. The JSON includes any icons uploaded with **Upload image**, so no image files go in the repo.
- Clearing site data in Edge deletes them. Import the JSON to restore.

## 5. Publishing changes

GitHub Pages caches files for 10 minutes. After a push, an old `style.css` or `app.js` can be mixed with the new `index.html`, which shows up as a broken layout or a console error. Hard reload with **Ctrl+Shift+R**.

To test locally without pushing: `python3 -m http.server 8000` inside the `newtab` repo, then open `http://localhost:8000`.
