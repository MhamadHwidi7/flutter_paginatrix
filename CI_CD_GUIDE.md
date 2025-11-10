# CI/CD Pipeline Guide

This document explains the complete CI/CD setup for the `flutter_paginatrix` package.

## 🎯 Overview

The CI/CD pipeline automates:
- ✅ Building in development and production modes
- ✅ Running tests and code analysis
- ✅ Publishing to pub.dev
- ✅ Creating GitHub releases
- ✅ Security scanning
- ✅ Multi-platform testing

## 📋 Workflows

### 1. Main CI/CD Pipeline (`.github/workflows/ci.yaml`)

**Triggers:**
- Push to `main` or `develop` branches
- Push tags starting with `v*.*.*`
- Pull requests to `main` or `develop`
- Manual workflow dispatch

**Jobs:**

#### `build-dev` - Development Build
- Runs on every push/PR
- Builds in development mode
- Runs tests and analysis
- Uploads coverage reports

#### `build-prod` - Production Build
- Runs on `main` branch or tags
- Validates version and changelog
- Builds in production mode
- Strict analysis and tests
- Uploads build artifacts

#### `publish` - Publish to pub.dev
- Runs on version tags or manual trigger
- Publishes to pub.dev
- Creates GitHub release
- Requires `PUB_CREDENTIALS` secret

#### `security` - Security Scan
- Scans for vulnerabilities
- Checks for secrets in code
- Runs security audit

#### `test-matrix` - Multi-platform Testing
- Tests on Ubuntu, macOS, Windows
- Ensures cross-platform compatibility

#### `dependencies` - Dependency Check
- Checks for outdated packages
- Runs on schedule or manual trigger

#### `docs` - Documentation Build
- Generates API documentation
- Deploys to GitHub Pages on releases

---

### 2. Release Workflow (`.github/workflows/release.yml`)

**Triggers:**
- Push tags starting with `v*.*.*`
- Manual workflow dispatch

**Jobs:**

#### `validate-release`
- Validates version format
- Checks version matches pubspec.yaml
- Verifies CHANGELOG entry exists

#### `build-release`
- Builds production version
- Runs all tests
- Uploads build artifacts

#### `publish-release`
- Publishes to pub.dev
- Creates GitHub release with notes
- Notifies on success

---

### 3. PR Checks (`.github/workflows/pr-checks.yml`)

**Triggers:**
- Pull requests to `main` or `develop`

**Checks:**
- Code formatting
- Static analysis
- Test coverage (minimum 70%)
- Development build
- Comments PR with results

---

### 4. Scheduled Maintenance (`.github/workflows/scheduled.yml`)

**Triggers:**
- Every Monday at 9 AM UTC
- Manual workflow dispatch

**Jobs:**
- Dependency updates check
- Security audit
- Documentation check

---

## 🔐 Required Secrets

### For Publishing to pub.dev

1. **Get your pub.dev credentials:**
   ```bash
   flutter pub token add
   ```

2. **Add to GitHub Secrets:**
   - Go to: Settings → Secrets and variables → Actions
   - Add secret: `PUB_CREDENTIALS`
   - Value: Content of `~/.pub-cache/credentials.json`

### Alternative: Using OAuth Token

If you prefer OAuth:
1. Go to https://pub.dev/account/api
2. Generate a token
3. Add as `PUB_CREDENTIALS` secret

---

## 🚀 Usage

### Automatic Workflows

#### On Push to Main
```bash
git push origin main
```
- ✅ Development build runs
- ✅ Production build runs
- ✅ Tests run
- ✅ Documentation builds

#### On Creating a Tag
```bash
# Update version in pubspec.yaml
# Update CHANGELOG.md
git add .
git commit -m "chore: release v1.0.0"
git tag v1.0.0
git push origin main --tags
```
- ✅ Release workflow triggers
- ✅ Validates version
- ✅ Builds production
- ✅ Publishes to pub.dev
- ✅ Creates GitHub release

### Manual Workflows

#### Development Build
1. Go to Actions tab
2. Select "CI/CD Pipeline"
3. Click "Run workflow"
4. Select environment: `dev`
5. Click "Run workflow"

#### Production Build
1. Go to Actions tab
2. Select "CI/CD Pipeline"
3. Click "Run workflow"
4. Select environment: `prod`
5. Click "Run workflow"

#### Publish Manually
1. Go to Actions tab
2. Select "CI/CD Pipeline"
3. Click "Run workflow"
4. Select environment: `prod`
5. Check "Publish to pub.dev"
6. Click "Run workflow"

#### Create Release
1. Go to Actions tab
2. Select "Release Workflow"
3. Click "Run workflow"
4. Enter version (e.g., `1.0.0`)
5. Check "Create git tag"
6. Click "Run workflow"

---

## 📊 Workflow Status Badges

Add these to your README.md:

```markdown
![CI](https://github.com/yourusername/flutter_paginatrix/workflows/CI%2FCD%20Pipeline/badge.svg)
![Release](https://github.com/yourusername/flutter_paginatrix/workflows/Release%20Workflow/badge.svg)
![PR Checks](https://github.com/yourusername/flutter_paginatrix/workflows/PR%20Checks/badge.svg)
```

---

## 🔍 Monitoring

### View Workflow Runs
1. Go to Actions tab in GitHub
2. Select workflow from left sidebar
3. View run history and details

### View Logs
- Click on any workflow run
- Click on a job
- Click on a step to see logs

### Debugging Failed Workflows
1. Check the failed step
2. Review error logs
3. Test locally with same commands
4. Fix and push again

---

## 🎨 Customization

### Change Flutter Version
Edit `env.FLUTTER_VERSION` in workflow files:
```yaml
env:
  FLUTTER_VERSION: '3.22.0'  # Change this
```

### Change Test Coverage Threshold
Edit in `pr-checks.yml`:
```yaml
if (( $(echo "$COVERAGE < 70" | bc -l) )); then  # Change 70 to your threshold
```

### Change Schedule
Edit cron in `scheduled.yml`:
```yaml
- cron: '0 9 * * 1'  # Every Monday at 9 AM UTC
```

---

## 🐛 Troubleshooting

### Workflow Fails on Publish

**Problem:** `PUB_CREDENTIALS` not set
**Solution:** Add secret in GitHub Settings

**Problem:** Version already exists on pub.dev
**Solution:** Increment version in pubspec.yaml

### Tests Fail

**Problem:** Flaky tests
**Solution:** Review test logs, fix timing issues

**Problem:** Coverage too low
**Solution:** Add more tests or lower threshold

### Build Fails

**Problem:** Code generation issues
**Solution:** Run `flutter pub run build_runner build --delete-conflicting-outputs` locally

**Problem:** Formatting issues
**Solution:** Run `flutter format .` locally

---

## 📝 Best Practices

1. **Always test locally first**
   ```bash
   ./scripts/build_prod.sh
   ```

2. **Update CHANGELOG.md before release**
   - Add entry for new version
   - Document breaking changes

3. **Use semantic versioning**
   - `1.0.0` - Major release
   - `1.1.0` - Minor release
   - `1.0.1` - Patch release

4. **Create tags for releases**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

5. **Review PR checks before merging**
   - Ensure all checks pass
   - Review coverage reports

---

## 🔗 Related Documentation

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/ci)
- [pub.dev Publishing Guide](https://dart.dev/tools/pub/publishing)
- [FLAVORS.md](FLAVORS.md) - Build flavors guide
- [BUILD_SYSTEM_EXPLANATION.md](BUILD_SYSTEM_EXPLANATION.md) - Build system explanation

---

## 📞 Support

If you encounter issues with the CI/CD pipeline:
1. Check workflow logs
2. Review this guide
3. Open an issue on GitHub
4. Check GitHub Actions status page

---

**Last Updated:** 2024
**Maintained by:** Package maintainers

