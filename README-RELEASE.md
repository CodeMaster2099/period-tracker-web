# Release build (AAB / APK) and signing

This repository includes CI workflows to build Android artifacts. To produce a signed AAB (suitable for Play Store) you need to create a Java keystore and add it as a secret in your repository.

Steps to create a keystore locally:

1. Generate a keystore (example):

```powershell
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Encode keystore as base64 and add as a GitHub secret named `KEYSTORE_BASE64`:

```powershell
$b = [Convert]::ToBase64String([IO.File]::ReadAllBytes('upload-keystore.jks'))
Write-Output $b > keystore.b64
```

3. In your GitHub repo settings → Secrets and variables → Actions, add the following secrets:
- `KEYSTORE_BASE64` : contents of `keystore.b64` (the base64 string)
- `KEYSTORE_PASSWORD` : the keystore password you used
- `KEY_ALIAS` : the alias you chose (e.g., `upload`)
- `KEY_PASSWORD` : the key password (often same as keystore password)

4. Trigger the `Android Release - Build AAB and optionally sign` workflow in Actions UI or push to `main`.

Notes:
- The CI template will build an unsigned AAB by default and upload it as an artifact. If the keystore secrets are present it will attempt to sign the AAB.
- For Play Store upload you usually upload the signed AAB.
