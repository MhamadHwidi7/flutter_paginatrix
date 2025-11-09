import 'core/entities/pagination_error_test.dart' as pagination_error_test;
import 'core/entities/pagination_state_test.dart' as pagination_state_test;
import 'data/meta_parser/config_meta_parser_test.dart' as config_meta_parser_test;
import 'integration/pagination_integration_test.dart' as integration_test;
import 'integration/pagination_integration_expanded_test.dart' as integration_expanded_test;
import 'performance/pagination_performance_test.dart' as performance_test;
import 'presentation/controllers/paginated_controller_test.dart' as controller_test;
import 'presentation/widgets/paginatrix_list_view_test.dart' as list_view_test;
import 'presentation/widgets/paginatrix_grid_view_test.dart' as grid_view_test;

void main() {
  pagination_error_test.main();
  pagination_state_test.main();
  config_meta_parser_test.main();
  controller_test.main();
  integration_test.main();
  integration_expanded_test.main();
  list_view_test.main();
  grid_view_test.main();
  performance_test.main();
}

