# Deploying period-tracker-web to GitHub Pages

This repo includes a GitHub Actions workflow that will build the Flutter web app and publish the `build/web` contents to GitHub Pages (branch: `gh-pages`). The workflow will also patch the `<base href>` in `build/web/index.html` to `/period-tracker-web/` so GitHub Pages serves the site with correct paths.

How it works:
- On push to `main` (or when triggered manually), the workflow runs `flutter build web --release`.
- It then replaces `<base href="/">` with `<base href="/period-tracker-web/">` in `build/web/index.html`.
- Finally it publishes `build/web` using `peaceiris/actions-gh-pages` (no extra secrets required).

After pushing these workflow files to your repository, the next push to `main` will trigger the workflow and publish your site at:

https://CodeMaster2099.github.io/period-tracker-web/

If you prefer to copy `build/web` into the repository root (legacy approach), you can still do so locally and then commit and push. However, the workflow above avoids committing generated files.

Notes:
- If your repo name differs, update `deploy_web.yml`'s `sed` replacement to match the repo name.
- For Android builds, use the `Android CI - Build APK` workflow; it produces an APK artifact you can download from the workflow run page.
