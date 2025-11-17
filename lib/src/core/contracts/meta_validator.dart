/// Contract for validating API response data structure
///
/// This interface follows the Interface Segregation Principle by separating
/// validation concerns from extraction concerns. Use this interface when you
/// only need to validate data structure without extracting.
abstract class MetaValidator {
  /// Validates that the response data has the expected structure
  ///
  /// [data] - Raw response data from API
  ///
  /// Returns true if data structure is valid, false otherwise
  bool validateStructure(Map<String, dynamic> data);
}
