# Contributing to Flutter Paginatrix

First off, thank you for considering contributing to Flutter Paginatrix! It's people like you that make the open source community such an amazing place to learn, inspire, and create.

## 🤝 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to [mhamadhwidi440@gmail.com](mailto:mhamadhwidi440@gmail.com).

## 🐛 Bug Reports

A bug is a _demonstrable problem_ that is caused by the code in the repository. Good bug reports are extremely helpful - thank you!

**Guidelines for Bug Reports:**

1. **Use the GitHub issue search** — check if the issue has already been reported.
2. **Check if the issue has been fixed** — try to reproduce it using the latest `master` or development branch in the repository.
3. **Isolate the problem** — ideally create a reduced test case and a live example.

**A good bug report shouldn't leave others needing to chase you up for more information.** Please try to be as detailed as possible in your report. What is your environment? What steps will reproduce the issue? What browser(s) and OS experience the problem? What would you expect to be the outcome? All these details will help people to fix any potential bugs.

## 💡 Feature Requests

Feature requests are welcome. But take a moment to find out whether your idea fits with the scope and aims of the project. It's up to _you_ to make a strong case to convince the project's developers of the merits of this feature. Please provide as much detail and context as possible.

## 🔧 Pull Requests

Good pull requests - patches, improvements, new features - are a fantastic help. They should remain focused in scope and avoid containing unrelated commits.

**Please ask first** before embarking on any significant pull request (e.g. implementing features, refactoring code, porting to a different language), otherwise you risk spending a lot of time working on something that the project's developers might not want to merge into the project.

**Adhering to the following process is the best way to get your work included in the project:**

1. [Fork](https://help.github.com/articles/fork-a-repo/) the project, clone your fork, and configure the remotes:

    ```bash
    # Clone your fork of the repo into the current directory
    git clone https://github.com/<your-username>/flutter_paginatrix.git
    # Navigate to the newly cloned directory
    cd flutter_paginatrix
    # Assign the original repo to a remote called "upstream"
    git remote add upstream https://github.com/MhamadHwidi7/flutter_paginatrix.git
    ```

2. If you cloned a while ago, get the latest changes from upstream:

    ```bash
    git checkout master
    git pull upstream master
    ```

3. Create a new topic branch (off the main project development branch) to contain your feature, change, or fix:

    ```bash
    git checkout -b <topic-branch-name>
    ```

4. Commit your changes in logical chunks. Please adhere to these [git commit message guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) or your code is unlikely be merged into the main project. Use Git's [interactive rebase](https://help.github.com/articles/interactive-rebase) feature to tidy up your commits before making them public.

5. Locally merge (or rebase) the upstream development branch into your topic branch:

    ```bash
    git pull [--rebase] upstream master
    ```

6. Push your topic branch up to your fork:

    ```bash
    git push origin <topic-branch-name>
    ```

7. [Open a Pull Request](https://help.github.com/articles/using-pull-requests/) with a clear title and description against the `master` branch.

## 🧪 Testing

We use `flutter_test` for testing. Please ensure that all tests pass before submitting your pull request.

```bash
flutter test
```

If you add new features, please add tests for them.

## 📝 Coding Style

- We follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
- Run `dart format .` to format your code.
- Run `dart analyze` to check for linting errors.

## 📄 License

By contributing your code, you agree to license your contribution under the [MIT License](LICENSE).
