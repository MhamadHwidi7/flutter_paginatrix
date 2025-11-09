import 'dart:convert';

/// Utility class for safe error logging / formatting
class ErrorUtils {
  /// Formats and (optionally) truncates data for error messages.
  ///
  /// - Pretty prints JSON/Map/List when possible.
  /// - Redacts common secrets.
  /// - Truncates by chars or bytes, with middle or end truncation.
  static String truncateData(
    dynamic data, {
    int maxChars = 200,
    int? maxBytes,               // If set, enforces a UTF-8 byte ceiling
    bool middle = true,          // Keep head+tail instead of tail-only
    int headChars = 140,         // Used for middle truncation
    int tailChars = 40,          // Used for middle truncation
    bool prettyJson = true,
    bool redactSecrets = true,
    String ellipsis = '…',
  }) {
    String s = _safeStringify(data, prettyJson: prettyJson);
    if (redactSecrets) {
      s = _redactSecrets(s);
    }
    final originalLen = s.runes.length;
    // Byte-based truncation (when logs have transport/storage limits)
    if (maxBytes != null) {
      final truncated = _truncateByBytes(
        s,
        maxBytes: maxBytes,
        middle: middle,
        headChars: headChars,
        tailChars: tailChars,
        ellipsis: ellipsis,
      );
      if (!identical(truncated, s)) {
        return _withMeta(truncated, originalLen, truncated.runes.length);
      }
      return s;
    }
    // Char-based truncation (Unicode-safe)
    if (originalLen > maxChars) {
      final truncated = middle
          ? _truncateMiddleByRunes(s, headChars, tailChars, ellipsis)
          : _truncateEndByRunes(s, maxChars, ellipsis);
      return _withMeta(truncated, originalLen, truncated.runes.length);
    }
    return s;
  }

  /// Adds a helpful suffix like " [truncated 1240→200]"
  static String _withMeta(String current, int originalLen, int newLen) {
    return '$current [truncated $originalLen→$newLen]';
  }

  /// Attempts to pretty-stringify objects/JSON safely.
  static String _safeStringify(dynamic data, {bool prettyJson = true}) {
    if (data == null) return 'null';
    try {
      // If Map/List, pretty print JSON
      if (prettyJson && (data is Map || data is List)) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      // If it's a string that looks like JSON, try to pretty print
      if (prettyJson && data is String) {
        final trimmed = data.trim();
        if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
            (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
          final decoded = json.decode(trimmed);
          return const JsonEncoder.withIndent('  ').convert(decoded);
        }
      }
    } catch (_) {
      // Fall through to toString() if JSON parsing fails
    }
    // Fallback
    try {
      return data.toString();
    } catch (_) {
      return '<unprintable object>';
    }
  }

  /// Redacts common secret patterns.
  static String _redactSecrets(String input) {
    final patterns = <RegExp>[
      // Authorization: Bearer <token>
      RegExp(r'(Authorization\s*:\s*)(Bearer\s+)?[A-Za-z0-9\-\._~\+\/]+=*', caseSensitive: false),
      // apiKey / token / password in JSON or query-like strings
      RegExp(r'("?(api[_\- ]?key|token|password|secret|access[_\- ]?token)"?\s*[:=]\s*)"[^"\r\n]+"', caseSensitive: false),
    ];
    var redacted = input;
    for (final p in patterns) {
      redacted = redacted.replaceAllMapped(p, (m) {
        // Keep the key part (group 1 if present), replace the value
        if (m.groupCount >= 2 && (m.group(1) != null)) {
          return '${m.group(1)}[REDACTED]';
        }
        return '[REDACTED]';
      });
    }
    return redacted;
  }

  /// Unicode-safe end truncation by code points.
  static String _truncateEndByRunes(String s, int maxChars, String ellipsis) {
    final runes = s.runes.toList();
    if (runes.length <= maxChars) return s;
    final head = String.fromCharCodes(runes.take(maxChars));
    return '$head$ellipsis';
  }

  /// Unicode-safe middle truncation by code points.
  static String _truncateMiddleByRunes(
      String s, int headChars, int tailChars, String ellipsis) {
    final runes = s.runes.toList();
    if (runes.length <= headChars + tailChars) return s;
    final head = String.fromCharCodes(runes.take(headChars));
    final tail = String.fromCharCodes(runes.skip(runes.length - tailChars));
    return '$head$ellipsis$tail';
  }

  /// UTF-8 byte-ceiling truncation (with Unicode safety).
  static String _truncateByBytes(
    String s, {
    required int maxBytes,
    required bool middle,
    required int headChars,
    required int tailChars,
    required String ellipsis,
  }) {
    // Quick path: already within limit
    if (utf8.encode(s).length <= maxBytes) return s;
    if (!middle) {
      // End truncation by bytes
      final buf = StringBuffer();
      var bytes = 0;
      for (final cp in s.runes) {
        final chunk = utf8.encode(String.fromCharCode(cp));
        if (bytes + chunk.length + utf8.encode(ellipsis).length > maxBytes) break;
        buf.writeCharCode(cp);
        bytes += chunk.length;
      }
      buf.write(ellipsis);
      return buf.toString();
    }
    // Middle truncation by bytes: build head, tail under the ceiling.
    String takeHead(int nChars) => String.fromCharCodes(s.runes.take(nChars));
    String takeTail(int nChars) =>
        String.fromCharCodes(s.runes.skip(s.runes.length - nChars));
    String head = takeHead(headChars);
    String tail = takeTail(tailChars);
    // Adjust head/tail to fit byte ceiling
    while (true) {
      final candidate = '$head$ellipsis$tail';
      final size = utf8.encode(candidate).length;
      if (size <= maxBytes) return candidate;
      // Shrink head first, then tail
      if (head.isNotEmpty) {
        head = String.fromCharCodes(head.runes.take(head.runes.length - 1));
      } else if (tail.isNotEmpty) {
        tail = String.fromCharCodes(tail.runes.skip(1));
      } else {
        // As a last resort, return just the ellipsis
        return ellipsis;
      }
    }
  }
}
