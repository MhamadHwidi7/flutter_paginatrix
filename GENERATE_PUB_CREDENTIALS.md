# How to Generate PUB_CREDENTIALS for GitHub Actions

This guide shows you how to generate the `PUB_CREDENTIALS` secret needed for publishing to pub.dev via GitHub Actions.

## Method 1: Using Flutter CLI (Recommended)

### Step 1: Generate Credentials
Run this command on your local machine:

```bash
flutter pub token add
```

**What happens:**
1. Opens your browser
2. Asks you to log in to pub.dev
3. Authenticates your account
4. Saves credentials to `~/.pub-cache/credentials.json`

### Step 2: Get the Credentials Content
Copy the entire content of the credentials file:

**On macOS/Linux:**
```bash
cat ~/.pub-cache/credentials.json
```

**On Windows:**
```bash
type %USERPROFILE%\.pub-cache\credentials.json
```

**Or manually:**
- Navigate to: `~/.pub-cache/credentials.json` (or `%USERPROFILE%\.pub-cache\credentials.json` on Windows)
- Open the file
- Copy all its content

### Step 3: Add to GitHub Secrets
1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. **Name:** `PUB_CREDENTIALS`
5. **Value:** Paste the entire content from `credentials.json`
6. Click **Add secret**

✅ Done! Your CI/CD can now publish to pub.dev.

---

## Method 2: Using OAuth Token (Alternative)

### Step 1: Generate OAuth Token
1. Go to https://pub.dev/account/api
2. Log in to your pub.dev account
3. Click **Generate token** or **Create token**
4. Copy the generated token

### Step 2: Add to GitHub Secrets
1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. **Name:** `PUB_CREDENTIALS`
5. **Value:** Paste the OAuth token
6. Click **Add secret**

✅ Done!

---

## 🔍 Verify It Works

After adding the secret, test it by:

1. Creating a version tag:
   ```bash
   git tag v1.0.0
   git push origin main --tags
   ```

2. Check GitHub Actions:
   - Go to **Actions** tab
   - Watch the workflow run
   - The publish step should succeed ✅

---

## ⚠️ Important Notes

- **Never commit credentials to git!** They should only be in GitHub Secrets
- The credentials file contains sensitive information - keep it private
- If you regenerate credentials, update the GitHub secret
- The secret is encrypted and only accessible to GitHub Actions

---

## 🆘 Troubleshooting

### "Authentication failed" error
- Verify the secret name is exactly `PUB_CREDENTIALS` (case-sensitive)
- Check that you copied the entire credentials.json content
- Try regenerating credentials with `flutter pub token add`

### "Token expired" error
- Generate a new token from https://pub.dev/account/api
- Update the `PUB_CREDENTIALS` secret in GitHub

### Can't find credentials.json
- Make sure you've run `flutter pub token add` at least once
- Check the path: `~/.pub-cache/credentials.json` (macOS/Linux) or `%USERPROFILE%\.pub-cache\credentials.json` (Windows)

