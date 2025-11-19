# 📚 Flutter Paginatrix Documentation

Welcome to the comprehensive documentation for **Flutter Paginatrix** - the most flexible, backend-agnostic pagination engine for Flutter applications.

---

## 🎯 What is Flutter Paginatrix?

Flutter Paginatrix is a complete pagination solution that provides:

- ✅ **Backend-agnostic** pagination supporting page-based, offset-based, and cursor-based strategies
- ✅ **Type-safe** implementation with full generics support
- ✅ **Clean architecture** with clear separation of concerns
- ✅ **Comprehensive error handling** with 6 error types and automatic retry
- ✅ **Beautiful UI components** built with Slivers for optimal performance
- ✅ **Zero boilerplate** - minimal configuration required

---

## 📖 Documentation Structure

### 🚀 Getting Started

New to Flutter Paginatrix? Start here:

1. **[Installation](getting-started/installation.md)** - Install and set up the package
2. **[Quick Start Guide](getting-started/quick-start.md)** - Get up and running in 5 minutes
3. **[Core Concepts](getting-started/core-concepts.md)** - Understand the architecture and key components

### 📘 Guides

Learn how to use Flutter Paginatrix effectively:

- **[Basic Usage](guides/basic-usage.md)** - Simple pagination examples and common patterns
- **[Advanced Usage](guides/advanced-usage.md)** - Search, filtering, sorting, and advanced configurations
- **[Error Handling](guides/error-handling.md)** - Comprehensive error handling strategies
- **[Performance Optimization](guides/performance.md)** - Tips and best practices for optimal performance
- **[Testing](guides/testing.md)** - How to test pagination in your applications

### 📚 API Reference

Complete API documentation:

- **[PaginatrixController](api-reference/paginatrix-controller.md)** - Main controller API (recommended)
- **[PaginatrixCubit](api-reference/paginatrix-cubit.md)** - Advanced Cubit API for BLoC pattern
- **[PaginationState](api-reference/pagination-state.md)** - State object reference
- **[Widgets](api-reference/widgets.md)** - UI widget reference (ListView, GridView, etc.)
- **[Meta Parsers](api-reference/meta-parsers.md)** - Parser configuration and customization
- **[Models & Entities](api-reference/models-entities.md)** - Data models and entities reference

### 💡 Examples

Real-world examples and use cases:

- **[ListView Example](examples/list-view.md)** - Basic list pagination
- **[GridView Example](examples/grid-view.md)** - Grid pagination
- **[Search Examples](examples/search.md)** - Basic and advanced search implementations
- **[BLoC Pattern Example](examples/bloc-pattern.md)** - Integration with BLoC pattern
- **[Cubit Direct Example](examples/cubit-direct.md)** - Direct PaginatrixCubit usage
- **[Web Examples](examples/web.md)** - Web-specific examples (infinite scroll & page selector)

### 🔧 Troubleshooting

Solutions to common problems:

- **[Common Issues](troubleshooting/common-issues.md)** - Solutions to frequently encountered problems
- **[FAQ](troubleshooting/faq.md)** - Frequently asked questions
- **[Migration Guide](troubleshooting/migration.md)** - Upgrading from other packages or versions

---

## 🚀 Quick Start

Here's the fastest way to get started:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:dio/dio.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final PaginatrixController<User> _controller;

  @override
  void initState() {
    super.initState();
    _controller = PaginatrixController<User>(
      loader: _loadUsers,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    _controller.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadUsers({
    int? page,
    int? perPage,
    CancelToken? cancelToken,
  }) async {
    final dio = Dio();
    final response = await dio.get(
      'https://api.example.com/users',
      queryParameters: {
        'page': page ?? 1,
        'per_page': perPage ?? 20,
      },
      cancelToken: cancelToken,
    );
    return response.data;
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: PaginatrixListView<User>(
        controller: _controller,
        itemBuilder: (context, user, index) {
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
      ),
    );
  }
}
```

**That's it!** Your pagination is ready. See the [Quick Start Guide](getting-started/quick-start.md) for more details.

---

## 🎓 Learning Path

### For Beginners

1. Start with [Installation](getting-started/installation.md)
2. Follow the [Quick Start Guide](getting-started/quick-start.md)
3. Read [Core Concepts](getting-started/core-concepts.md) to understand the architecture
4. Try [Basic Usage](guides/basic-usage.md) examples
5. Explore [Examples](examples/) to see real-world implementations

### For Intermediate Users

1. Review [Advanced Usage](guides/advanced-usage.md) for search, filtering, and sorting
2. Learn about [Error Handling](guides/error-handling.md)
3. Check [API Reference](api-reference/) for detailed method documentation
4. Optimize with [Performance Optimization](guides/performance.md) guide

### For Advanced Users

1. Deep dive into [API Reference](api-reference/) for all available options
2. Customize with [Meta Parsers](api-reference/meta-parsers.md)
3. Integrate with [BLoC Pattern](examples/bloc-pattern.md)
4. Review [Testing](guides/testing.md) strategies

---

## 🔍 Finding What You Need

### By Task

- **Setting up pagination**: [Installation](getting-started/installation.md) → [Quick Start](getting-started/quick-start.md)
- **Adding search**: [Advanced Usage - Search](guides/advanced-usage.md#search-functionality)
- **Handling errors**: [Error Handling Guide](guides/error-handling.md)
- **Customizing UI**: [Widgets API](api-reference/widgets.md)
- **Optimizing performance**: [Performance Guide](guides/performance.md)
- **Testing**: [Testing Guide](guides/testing.md)

### By Component

- **Controller**: [PaginatrixController API](api-reference/paginatrix-controller.md)
- **State**: [PaginationState API](api-reference/pagination-state.md)
- **Widgets**: [Widgets API](api-reference/widgets.md)
- **Parsers**: [Meta Parsers API](api-reference/meta-parsers.md)

### By Problem

- **Items not loading**: [Common Issues](troubleshooting/common-issues.md#items-not-loading)
- **Pagination not working**: [Common Issues](troubleshooting/common-issues.md#pagination-not-working)
- **Memory leaks**: [Common Issues](troubleshooting/common-issues.md#memory-leaks)
- **Performance issues**: [Performance Guide](guides/performance.md)

---

## 📦 Package Information

- **Package Name**: `flutter_paginatrix`
- **Version**: `1.0.0`
- **Flutter SDK**: `>=3.22.0`
- **Dart SDK**: `>=3.2.0 <4.0.0`
- **License**: MIT
- **Homepage**: [GitHub Repository](https://github.com/MhamadHwidi7/flutter_paginatrix)
- **Pub.dev**: [pub.dev/packages/flutter_paginatrix](https://pub.dev/packages/flutter_paginatrix)

---

## 🔗 Quick Links

- **[Pub.dev Package](https://pub.dev/packages/flutter_paginatrix)** - Package page on pub.dev
- **[GitHub Repository](https://github.com/MhamadHwidi7/flutter_paginatrix)** - Source code and issues
- **[Issue Tracker](https://github.com/MhamadHwidi7/flutter_paginatrix/issues)** - Report bugs or request features
- **[Changelog](../CHANGELOG.md)** - Version history and changes
- **[Code Review](../CODE_REVIEW.md)** - Comprehensive code review and improvements

---

## 💬 Getting Help

### Before Asking for Help

1. ✅ Check the [FAQ](troubleshooting/faq.md) - Your question might already be answered
2. ✅ Search [existing issues](https://github.com/MhamadHwidi7/flutter_paginatrix/issues) - Similar problems might have solutions
3. ✅ Review [Common Issues](troubleshooting/common-issues.md) - Solutions to frequent problems
4. ✅ Read the relevant [API Reference](api-reference/) - Complete method documentation

### When Asking for Help

If you still need help, create an issue with:

- **Description**: Clear description of the problem
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Code sample**: Minimal reproducible example
- **Environment**: Flutter/Dart versions, platform
- **Error messages**: Any error logs or stack traces

---

## 🤝 Contributing

We welcome contributions! See our [Contributing Guide](../CONTRIBUTING.md) for details.

### Ways to Contribute

- 🐛 **Report bugs** - Help us improve by reporting issues
- 💡 **Suggest features** - Share your ideas for improvements
- 📖 **Improve documentation** - Help others learn by improving docs
- 🔧 **Submit pull requests** - Fix bugs or add features
- ⭐ **Star the repository** - Help others discover the package

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

---

## 🙏 Acknowledgments

Special thanks to:

- The Flutter team for the amazing framework
- The `flutter_bloc` team for excellent state management
- The `freezed` team for powerful code generation
- All contributors and users of this package

---

## 📊 Documentation Status

- ✅ **Getting Started** - Complete
- ✅ **Guides** - Complete
- ✅ **API Reference** - Complete
- ✅ **Examples** - Complete
- ✅ **Troubleshooting** - Complete

**Last Updated**: January 2025  
**Documentation Version**: 1.0.0

---

**Made with ❤️ for the Flutter community**
