import 'package:flutter_paginatrix/src/core/contracts/meta_extractor.dart';
import 'package:flutter_paginatrix/src/core/contracts/meta_validator.dart';

/// Contract for parsing pagination metadata from API responses
///
/// This interface combines [MetaExtractor] and [MetaValidator] for convenience.
/// It follows the Interface Segregation Principle by composing smaller,
/// focused interfaces rather than having a single broad interface.
///
/// **Usage:**
/// - Use [MetaExtractor] if you only need extraction capabilities
/// - Use [MetaValidator] if you only need validation capabilities
/// - Use [MetaParser] if you need both (most common case)
abstract class MetaParser implements MetaExtractor, MetaValidator {
  // All methods are inherited from MetaExtractor and MetaValidator
  // This interface serves as a convenience composition of both concerns
}
