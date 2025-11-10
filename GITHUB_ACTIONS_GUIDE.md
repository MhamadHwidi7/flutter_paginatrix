# Complete GitHub Actions Guide

## 🤔 What is GitHub Actions?

**GitHub Actions** is GitHub's built-in CI/CD (Continuous Integration/Continuous Deployment) platform. It automatically runs tasks when you push code, create pull requests, or trigger workflows manually.

### Simple Explanation:
- **CI (Continuous Integration)**: Automatically test your code when you push changes
- **CD (Continuous Deployment)**: Automatically deploy/publish when tests pass

Think of it as a **robot assistant** that:
- ✅ Tests your code automatically
- ✅ Builds your project
- ✅ Publishes to pub.dev
- ✅ Checks for errors
- ✅ Runs on every code change

---

## 📋 What We Have

Your project has **4 workflows** that run automatically:

### 1. **Main CI/CD Pipeline** (`ci.yaml`)
**When it runs:**
- Every push to `main` or `develop` branch
- Every pull request
- When you create a version tag (v1.0.0)
- Manually (you can trigger it)

**What it does:**
- ✅ Builds your package in development mode
- ✅ Runs all tests
- ✅ Checks code formatting
- ✅ Analyzes code for errors
- ✅ Builds in production mode (on main branch)
- ✅ Publishes to pub.dev (on version tags)
- ✅ Tests on multiple platforms (Windows, Mac, Linux)
- ✅ Scans for security issues
- ✅ Generates documentation

### 2. **Release Workflow** (`release.yml`)
**When it runs:**
- When you create a version tag (e.g., `v1.0.0`)
- Manually with version input

**What it does:**
- ✅ Validates version format
- ✅ Checks CHANGELOG.md has entry
- ✅ Builds production version
- ✅ Publishes to pub.dev
- ✅ Creates GitHub release

### 3. **PR Checks** (`pr-checks.yml`)
**When it runs:**
- Every pull request to `main` or `develop`

**What it does:**
- ✅ Validates code formatting
- ✅ Runs static analysis
- ✅ Runs tests
- ✅ Checks test coverage (minimum 70%)
- ✅ Comments on PR with results

### 4. **Scheduled Maintenance** (`scheduled.yml`)
**When it runs:**
- Every Monday at 9 AM UTC
- Manually

**What it does:**
- ✅ Checks for outdated dependencies
- ✅ Runs security audit
- ✅ Validates documentation

---

## 🚀 How to Use It

### Setup (One-Time)

#### 1. Enable GitHub Actions
GitHub Actions is **automatically enabled** for your repository. No setup needed!

#### 2. Add pub.dev Credentials (For Publishing)

**Get your credentials:**
```bash
# On your local machine
flutter pub token add
```

This will:
1. Open your browser
2. Ask you to log in to pub.dev
3. Save credentials to `~/.pub-cache/credentials.json`

**Add to GitHub:**
1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `PUB_CREDENTIALS`
5. Value: Copy content of `~/.pub-cache/credentials.json`
6. Click **Add secret**

**Alternative (OAuth Token):**
1. Go to https://pub.dev/account/api
2. Generate a token
3. Add as `PUB_CREDENTIALS` secret

---

## 📝 Daily Usage

### Normal Development Workflow

#### 1. Make Changes
```bash
git add .
git commit -m "feat: add new feature"
git push origin main
```

**What happens automatically:**
- ✅ CI/CD pipeline runs
- ✅ Tests execute
- ✅ Code is validated
- ✅ Results shown in GitHub

#### 2. Check Results
1. Go to your GitHub repository
2. Click **Actions** tab
3. See workflow runs and results

**Green checkmark** = Everything passed ✅  
**Red X** = Something failed ❌

---

## 🏷️ Publishing a Release

### Method 1: Automatic (Recommended)

#### Step 1: Update Version
Edit `pubspec.yaml`:
```yaml
version: 1.0.1  # Increment version
```

#### Step 2: Update CHANGELOG
Edit `CHANGELOG.md`:
```markdown
## [1.0.1] - 2024-01-15

### Added
- New feature X

### Fixed
- Bug Y
```

#### Step 3: Commit and Tag
```bash
git add .
git commit -m "chore: release v1.0.1"
git tag v1.0.1
git push origin main --tags
```

**What happens automatically:**
1. ✅ Release workflow triggers
2. ✅ Version validated
3. ✅ CHANGELOG checked
4. ✅ Production build created
5. ✅ Published to pub.dev
6. ✅ GitHub release created

### Method 2: Manual Trigger

1. Go to **Actions** tab
2. Select **Release Workflow**
3. Click **Run workflow**
4. Enter version (e.g., `1.0.1`)
5. Click **Run workflow**

---

## 🔍 Understanding Workflow Runs

### Viewing Workflow Runs

1. **Go to Actions tab** in GitHub
2. **See all runs** with status:
   - 🟢 Green = Success
   - 🔴 Red = Failed
   - 🟡 Yellow = In progress

### Understanding a Run

Click on any run to see:
- **Jobs** - Different tasks (build, test, publish)
- **Steps** - Individual actions in each job
- **Logs** - Detailed output

### Example Run:
```
✅ build-dev (Development Build)
  ✅ Setup Project
  ✅ Validate Code
  ✅ Upload Coverage
  ✅ Build Development

✅ build-prod (Production Build)
  ✅ Setup Project
  ✅ Validate Version
  ✅ Validate Code (Strict)
  ✅ Build Production

✅ publish (Publish to pub.dev)
  ✅ Setup Project
  ✅ Dry-run publish
  ✅ Publish to pub.dev
  ✅ Create GitHub Release
```

---

## 🛠️ Manual Workflow Triggers

### Trigger Development Build

1. Go to **Actions** → **CI/CD Pipeline**
2. Click **Run workflow**
3. Select:
   - **Environment**: `dev`
   - **Publish**: Leave unchecked
4. Click **Run workflow**

### Trigger Production Build

1. Go to **Actions** → **CI/CD Pipeline**
2. Click **Run workflow**
3. Select:
   - **Environment**: `prod`
   - **Publish**: Leave unchecked
4. Click **Run workflow**

### Trigger Publish

1. Go to **Actions** → **CI/CD Pipeline**
2. Click **Run workflow**
3. Select:
   - **Environment**: `prod`
   - **Publish**: ✅ Check this
4. Click **Run workflow**

---

## 📊 Workflow Status Badges

Add these to your `README.md` to show CI status:

```markdown
![CI](https://github.com/yourusername/flutter_paginatrix/workflows/CI%2FCD%20Pipeline/badge.svg)
![Release](https://github.com/yourusername/flutter_paginatrix/workflows/Release%20Workflow/badge.svg)
![PR Checks](https://github.com/yourusername/flutter_paginatrix/workflows/PR%20Checks/badge.svg)
```

**Replace `yourusername` with your GitHub username!**

---

## 🐛 Troubleshooting

### Workflow Fails

#### Problem: "PUB_CREDENTIALS not found"
**Solution:** Add the secret (see Setup section above)

#### Problem: "Version already exists"
**Solution:** Increment version in `pubspec.yaml`

#### Problem: "CHANGELOG.md doesn't have entry"
**Solution:** Add entry for your version in `CHANGELOG.md`

#### Problem: "Tests failing"
**Solution:**
1. Check test logs in Actions tab
2. Run tests locally: `flutter test`
3. Fix failing tests
4. Push again

#### Problem: "Code formatting failed"
**Solution:**
```bash
flutter format .
git add .
git commit -m "style: format code"
git push
```

### Viewing Logs

1. Go to **Actions** tab
2. Click on failed workflow
3. Click on failed job
4. Click on failed step
5. Scroll to see error messages

---

## 📖 Workflow Files Explained

### `.github/workflows/ci.yaml`
**Main CI/CD pipeline**
- Runs on every push/PR
- Builds, tests, validates
- Publishes on tags

### `.github/workflows/release.yml`
**Release automation**
- Runs on version tags
- Validates and publishes releases

### `.github/workflows/pr-checks.yml`
**PR validation**
- Runs on pull requests
- Validates before merge

### `.github/workflows/scheduled.yml`
**Maintenance**
- Runs weekly
- Checks dependencies and security

### `.github/actions/`
**Reusable components**
- Used by workflows to avoid duplication
- You don't need to edit these

---

## 🎯 Common Scenarios

### Scenario 1: Daily Development

```bash
# 1. Make changes
git add .
git commit -m "feat: new feature"
git push origin main

# 2. Check GitHub Actions tab
# ✅ See tests running automatically
# ✅ Get notified if anything fails
```

### Scenario 2: Creating a Release

```bash
# 1. Update version
# Edit pubspec.yaml: version: 1.0.1

# 2. Update CHANGELOG.md
# Add entry for 1.0.1

# 3. Commit and tag
git add .
git commit -m "chore: release v1.0.1"
git tag v1.0.1
git push origin main --tags

# 4. GitHub Actions automatically:
# ✅ Validates version
# ✅ Builds production
# ✅ Publishes to pub.dev
# ✅ Creates GitHub release
```

### Scenario 3: Pull Request

```bash
# 1. Create branch
git checkout -b feature/new-feature

# 2. Make changes and push
git push origin feature/new-feature

# 3. Create PR on GitHub
# ✅ PR checks run automatically
# ✅ See results in PR comments
```

---

## 🔐 Secrets Management

### Required Secrets

| Secret Name | Purpose | How to Get |
|------------|---------|------------|
| `PUB_CREDENTIALS` | Publish to pub.dev | `flutter pub token add` |

### Adding Secrets

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Enter name and value
4. Click **Add secret**

**Note:** Secrets are encrypted and only visible to workflows.

---

## 📈 Monitoring Workflows

### View All Runs
- **Actions** tab → See all workflow runs

### Filter Runs
- Click workflow name to filter
- Use search to find specific runs

### Download Artifacts
- Click on a run
- Scroll to **Artifacts** section
- Download build artifacts

---

## 🎨 Customization

### Change Flutter Version

Edit workflow files:
```yaml
env:
  FLUTTER_VERSION: '3.22.0'  # Change this
```

### Change Test Coverage Threshold

Edit `pr-checks.yml`:
```yaml
coverage-threshold: '70'  # Change to your threshold
```

### Disable a Workflow

Comment out or delete the workflow file, or add:
```yaml
on:
  workflow_dispatch:  # Only manual trigger
```

---

## ✅ Best Practices

1. **Always check Actions tab** after pushing
2. **Fix failing tests** before merging
3. **Update CHANGELOG** before releases
4. **Use semantic versioning** (1.0.0, 1.0.1, 1.1.0)
5. **Test locally first** before pushing

---

## 🔗 Quick Reference

### Commands

```bash
# Run tests locally
flutter test

# Format code
flutter format .

# Analyze code
flutter analyze

# Build for production locally
./scripts/build_prod.sh

# Publish (dry-run)
flutter pub publish --dry-run
```

### GitHub Actions URLs

- **View workflows**: `https://github.com/yourusername/flutter_paginatrix/actions`
- **View secrets**: `https://github.com/yourusername/flutter_paginatrix/settings/secrets/actions`
- **View releases**: `https://github.com/yourusername/flutter_paginatrix/releases`

---

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Guide](https://docs.flutter.dev/deployment/ci)
- [pub.dev Publishing](https://dart.dev/tools/pub/publishing)
- [Semantic Versioning](https://semver.org/)

---

## 🎓 Summary

**GitHub Actions** = Automated CI/CD for your project

**What it does:**
- ✅ Tests code automatically
- ✅ Builds in dev/prod modes
- ✅ Publishes to pub.dev
- ✅ Validates everything
- ✅ Creates releases

**How to use:**
1. Push code → CI runs automatically
2. Create tag → Release workflow runs
3. Create PR → PR checks run
4. Check Actions tab → See results

**No manual work needed!** Everything is automated. 🚀

---

**Questions?** Check the logs in Actions tab or see [CI_CD_GUIDE.md](CI_CD_GUIDE.md) for more details.







# Branching Strategy Guide

## 🌿 Two-Branch Workflow

### Branches

1. **`development`** - Active development branch
   - Where you work on new features
   - Full CI/CD runs on every push
   - Tests, validation, builds

2. **`main`** - Stable release branch
   - Merged from `development` when ready
   - Full CI/CD runs on every push
   - Production-ready code

---

## 🔄 Workflow

### Daily Development (on `development` branch)

```bash
# 1. Create and switch to development branch
git checkout -b development

# 2. Make your changes
git add .
git commit -m "feat: new feature"

# 3. Push to development
git push origin development
```

**What happens:**
- ✅ CI/CD runs automatically
- ✅ Tests execute
- ✅ Code validated
- ✅ Results shown in Actions tab

### Merge to Main (when ready for release)

```bash
# 1. Switch to main
git checkout main

# 2. Pull latest
git pull origin main

# 3. Merge development into main
git merge development

# 4. Push to main
git push origin main
```

**What happens:**
- ✅ CI/CD runs automatically on main
- ✅ Tests execute again
- ✅ Code validated
- ✅ Ready for production

### Publish Release (from main)

```bash
# 1. Make sure you're on main
git checkout main

# 2. Update version in pubspec.yaml
# version: 1.0.1

# 3. Create tag and push
git tag v1.0.1
git push origin main --tags
```

**What happens:**
- ✅ CI/CD runs
- ✅ Automatically publishes to pub.dev
- ✅ Creates GitHub release

---

## 📋 Step-by-Step Example

### Scenario: Adding a New Feature

#### Step 1: Work on Development Branch
```bash
# Create development branch (first time only)
git checkout -b development

# Or switch to existing development branch
git checkout development
git pull origin development
```

#### Step 2: Make Changes
```bash
# Make your code changes
# ... edit files ...

git add .
git commit -m "feat: add pagination feature"
git push origin development
```

**Result:** CI/CD runs on `development` branch ✅

#### Step 3: Test and Validate
- Check Actions tab
- See if tests pass
- Fix any issues
- Push again if needed

#### Step 4: Merge to Main (when ready)
```bash
# Switch to main
git checkout main
git pull origin main

# Merge development
git merge development

# Push to main
git push origin main
```

**Result:** CI/CD runs on `main` branch ✅

#### Step 5: Publish (when ready)
```bash
# On main branch
git tag v1.0.1
git push origin main --tags
```

**Result:** Automatically publishes to pub.dev 🚀

---

## 🎯 Branch Rules

### Development Branch
- ✅ Push freely
- ✅ Full CI/CD runs
- ✅ Can have breaking changes
- ✅ Experimental features OK

### Main Branch
- ✅ Only merge from development
- ✅ Full CI/CD runs
- ✅ Should be stable
- ✅ Production-ready code

---

## 🔧 Setup (One-Time)

### Create Development Branch

```bash
# Create development branch
git checkout -b development

# Push to remote
git push -u origin development
```

**That's it!** Now you have two branches.

---

## 📊 What Runs When

### Push to `development`:
```
✅ Test and Validate job runs
✅ All tests execute
✅ Code validated
✅ Coverage uploaded
```

### Push to `main`:
```
✅ Test and Validate job runs
✅ All tests execute
✅ Code validated
✅ Coverage uploaded
```

### Create Tag (v1.0.0):
```
✅ Test and Validate job runs
✅ Publish job runs
✅ Published to pub.dev
```

---

## 💡 Best Practices

1. **Work on `development`** - Make all changes here
2. **Test on `development`** - CI runs automatically
3. **Merge to `main`** - When feature is complete
4. **Tag from `main`** - When ready to publish

### Workflow Diagram:
```
development branch
    ↓ (work here)
    ↓ (push → CI runs)
    ↓ (merge when ready)
main branch
    ↓ (CI runs again)
    ↓ (tag when ready)
    ↓
pub.dev 🚀
```

---

## 🚀 Quick Commands

### Daily Work:
```bash
git checkout development
# ... make changes ...
git push origin development
```

### Release:
```bash
git checkout main
git merge development
git push origin main
git tag v1.0.1
git push origin main --tags
```

---

## ✅ Summary

**Two branches:**
- `development` - Where you work
- `main` - Stable releases

**CI/CD runs on:**
- ✅ Every push to `development`
- ✅ Every push to `main`
- ✅ Every pull request to `main`
- ✅ Version tags (publishes)

**Simple workflow:**
1. Work on `development`
2. Merge to `main` when ready
3. Tag from `main` to publish

That's it! 🎉

