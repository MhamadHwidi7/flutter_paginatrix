# CI/CD Workflow

## 📋 Simple Workflow

**One file:** `ci.yaml`

## 🚀 What It Does

### On Push to `development` or `main`:
- ✅ Tests code
- ✅ Validates formatting
- ✅ Analyzes code
- ✅ Uploads coverage

### On Version Tag (v1.0.0):
- ✅ Runs all tests
- ✅ Validates version
- ✅ Checks CHANGELOG
- ✅ Publishes to pub.dev
- ✅ Creates GitHub release

## 🔐 Setup

Add `PUB_CREDENTIALS` secret:
1. Settings → Secrets → Actions
2. New secret: `PUB_CREDENTIALS`
3. Value: From `flutter pub token add`

## 📝 Usage

### Daily Work:
```bash
git push origin development
```
→ CI runs automatically ✅

### Publish:
```bash
git tag v1.0.0
git push origin main --tags
```
→ Publishes automatically 🚀

That's it! Simple and complete.
