# Publishing Guide - Flutter Paginatrix

This guide provides step-by-step instructions for publishing `flutter_paginatrix` to pub.dev.

---

## 📋 Prerequisites

Before publishing, ensure you have:

1. ✅ **Dart/Flutter SDK** installed and up to date
2. ✅ **pub.dev account** - Create one at [pub.dev](https://pub.dev) if you don't have one
3. ✅ **Google Account** - Required for pub.dev authentication
4. ✅ **Package ownership** - You must be the owner or have publishing rights

---

## 🔍 Pre-Publication Checklist

### 1. Code Quality Checks

```bash
# Run analysis
flutter analyze

# Run tests
flutter test

# Check for any errors or warnings
# Should have 0 errors, warnings are acceptable but should be minimal
```

**Current Status:**
- ✅ No critical errors
- ✅ 0 info-level linting issues in library code
- ⚠️ 10 info-level linting issues in test files only (acceptable - print statements and variable names)
- ✅ All tests passing

### 2. Documentation Review

Verify all documentation is complete:

- [x] **README.md** - Comprehensive with examples
- [x] **CHANGELOG.md** - Follows Keep a Changelog format
- [x] **LICENSE** - MIT License present
- [x] **API Documentation** - All public APIs documented
- [x] **Examples** - Working examples in `examples/` directory

### 3. Version Number

Check `pubspec.yaml`:

```yaml
name: flutter_paginatrix
version: 1.0.0  # ← Verify this is correct for first release
```

**Version Guidelines:**
- `1.0.0` - First stable release
- `0.x.x` - Pre-release (not recommended for stable packages)
- Follow [Semantic Versioning](https://semver.org/)

### 4. Dependency Review

```bash
# Check for outdated dependencies
flutter pub outdated

# Review dependency_overrides (if any)
# In pubspec.yaml, you have:
# dependency_overrides:
#   meta: ^1.11.0
# Consider if this override is necessary
```

### 5. Dry Run Publication

**IMPORTANT:** Always do a dry run first!

```bash
# Dry run - simulates publication without actually publishing
flutter pub publish --dry-run
```

This will:
- ✅ Validate package structure
- ✅ Check for common issues
- ✅ Show what files will be published
- ✅ Verify all requirements are met

**Expected Output:**
```
Package has 0 warnings.
```

If you see warnings, address them before publishing.

---

## 🔐 Setting Up pub.dev Credentials

### Step 1: Create/Login to pub.dev Account

1. Go to [pub.dev](https://pub.dev)
2. Click "Sign in" (top right)
3. Sign in with your Google account

### Step 2: Get Publishing Token

1. Go to [pub.dev/account](https://pub.dev/account)
2. Scroll to "Publisher" section
3. Click "Create publisher" if you don't have one
4. Note: For first-time publishers, you may need to verify your account

### Step 3: Authenticate with pub.dev

```bash
# This will open a browser for authentication
dart pub token add https://pub.dev

# Follow the prompts:
# 1. Browser will open
# 2. Sign in with Google account
# 3. Authorize the token
# 4. Copy the token from browser
# 5. Paste it in the terminal
```

**Alternative Method (if browser doesn't open):**
```bash
# Get token manually from pub.dev account page
# Then add it:
dart pub token add https://pub.dev
# Paste token when prompted
```

---

## 📦 Publishing Steps

### Step 1: Final Verification

```bash
# Navigate to package directory
cd /Users/mhamad/Desktop/flutter_paginatrix

# Ensure you're on the main branch
git status

# Ensure all changes are committed (optional but recommended)
git add .
git commit -m "Prepare for v1.0.0 release"
```

### Step 2: Run Dry Run (Again)

```bash
flutter pub publish --dry-run
```

**Verify:**
- ✅ No errors
- ✅ Package structure is correct
- ✅ All files are included
- ✅ No sensitive files (API keys, etc.) are included

### Step 3: Check .gitignore

Ensure `.gitignore` excludes:
- `build/`
- `.dart_tool/`
- `*.iml`
- `*.lock` (if not needed)

But includes:
- `lib/`
- `README.md`
- `CHANGELOG.md`
- `LICENSE`
- `pubspec.yaml`

### Step 4: Publish

```bash
# Publish to pub.dev
flutter pub publish
```

**What happens:**
1. Package is validated
2. Files are uploaded
3. Package is processed by pub.dev
4. You'll see a success message with package URL

**Expected Output:**
```
Package published successfully!
Package URL: https://pub.dev/packages/flutter_paginatrix
```

### Step 5: Verify Publication

1. Visit your package URL: `https://pub.dev/packages/flutter_paginatrix`
2. Check that:
   - ✅ All files are present
   - ✅ Documentation renders correctly
   - ✅ Examples are accessible
   - ✅ Version number is correct

---

## 🚨 Common Issues & Solutions

### Issue 1: "Package name already taken"

**Solution:**
- Package name `flutter_paginatrix` must be unique
- If taken, you'll need to choose a different name
- Update `pubspec.yaml` with new name
- Update all references in code

### Issue 2: "Missing LICENSE file"

**Solution:**
```bash
# Ensure LICENSE file exists
ls LICENSE

# If missing, create one (MIT License recommended)
```

### Issue 3: "Invalid version number"

**Solution:**
- Version must follow semantic versioning: `MAJOR.MINOR.PATCH`
- Examples: `1.0.0`, `1.0.1`, `1.1.0`, `2.0.0`
- Cannot use `0.0.0` or negative numbers

### Issue 4: "Dependency conflicts"

**Solution:**
```bash
# Check for conflicts
flutter pub get

# Resolve conflicts by updating dependencies
# Or use dependency_overrides (use sparingly)
```

### Issue 5: "Authentication failed"

**Solution:**
```bash
# Remove old token
dart pub token remove https://pub.dev

# Add new token
dart pub token add https://pub.dev
```

### Issue 6: "Files too large"

**Solution:**
- pub.dev has file size limits
- Check for large files in package
- Exclude unnecessary files via `.gitignore` or `.pubignore`

### Issue 7: "Missing required fields"

**Solution:**
Ensure `pubspec.yaml` has:
- ✅ `name`
- ✅ `version`
- ✅ `description`
- ✅ `homepage` (or `repository`)
- ✅ `environment` (SDK constraints)

---

## 📝 Post-Publication Tasks

### 1. Create GitHub Release

```bash
# Tag the release
git tag v1.0.0
git push origin v1.0.0

# Create release on GitHub
# Go to: https://github.com/MhamadHwidi7/flutter_paginatrix/releases/new
# Use tag: v1.0.0
# Title: v1.0.0 - Initial Release
# Description: Copy from CHANGELOG.md
```

### 2. Update Documentation

- [ ] Update README badges (if needed)
- [ ] Verify all links work
- [ ] Check example apps still work

### 3. Announce Release

- [ ] Post on social media (Twitter, LinkedIn, etc.)
- [ ] Share in Flutter communities
- [ ] Update project website (if any)

### 4. Monitor

- [ ] Check pub.dev analytics
- [ ] Monitor for issues/feedback
- [ ] Respond to user questions

---

## 🔄 Updating Published Package

### For Patch Releases (1.0.0 → 1.0.1)

```bash
# 1. Update version in pubspec.yaml
version: 1.0.1

# 2. Update CHANGELOG.md
# Add entry under [1.0.1] section

# 3. Commit changes
git add .
git commit -m "Release v1.0.1"

# 4. Dry run
flutter pub publish --dry-run

# 5. Publish
flutter pub publish

# 6. Tag release
git tag v1.0.1
git push origin v1.0.1
```

### For Minor Releases (1.0.0 → 1.1.0)

Same process, but:
- Update minor version number
- Add new features to CHANGELOG
- Consider deprecation notices if API changes

### For Major Releases (1.0.0 → 2.0.0)

Same process, but:
- Update major version number
- Document breaking changes
- Provide migration guide if needed

---

## 📊 Package Maintenance

### Regular Tasks

1. **Monitor Dependencies**
   ```bash
   flutter pub outdated
   ```

2. **Update Dependencies** (when needed)
   ```bash
   flutter pub upgrade
   flutter test  # Ensure tests still pass
   ```

3. **Security Updates**
   - Monitor for security advisories
   - Update dependencies promptly
   - Publish patch releases for security fixes

4. **User Feedback**
   - Monitor GitHub issues
   - Respond to pub.dev comments
   - Consider feature requests

---

## 🎯 Pre-Publication Command Summary

Run these commands in order before publishing:

```bash
# 1. Navigate to package directory
cd /Users/mhamad/Desktop/flutter_paginatrix

# 2. Clean build artifacts
flutter clean

# 3. Get dependencies
flutter pub get

# 4. Run analysis
flutter analyze

# 5. Run tests
flutter test

# 6. Check for outdated dependencies
flutter pub outdated

# 7. Dry run publication
flutter pub publish --dry-run

# 8. If dry run succeeds, publish
flutter pub publish
```

---

## 📚 Additional Resources

- [pub.dev Publishing Guide](https://dart.dev/tools/pub/publishing)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Flutter Package Best Practices](https://dart.dev/guides/libraries/create-library-packages)

---

## ✅ Final Checklist Before Publishing

- [ ] All tests pass (`flutter test`)
- [ ] No analysis errors (`flutter analyze`)
- [ ] Version number is correct
- [ ] CHANGELOG.md is updated
- [ ] README.md is complete
- [ ] LICENSE file is present
- [ ] All examples work
- [ ] Dry run succeeds (`flutter pub publish --dry-run`)
- [ ] pub.dev credentials are set up
- [ ] Git repository is clean (optional but recommended)
- [ ] No sensitive information in code
- [ ] All dependencies are properly declared

---

## 🚀 Ready to Publish?

Once you've completed all checks:

1. **Run dry run one final time:**
   ```bash
   flutter pub publish --dry-run
   ```

2. **If successful, publish:**
   ```bash
   flutter pub publish
   ```

3. **Verify publication:**
   - Visit: https://pub.dev/packages/flutter_paginatrix
   - Check package page looks correct
   - Verify documentation renders properly

4. **Create GitHub release:**
   - Tag the release
   - Create release notes
   - Announce to community

---

**Good luck with your publication! 🎉**

---

**Note:** This guide is for reference. Always verify current pub.dev requirements as they may change.

