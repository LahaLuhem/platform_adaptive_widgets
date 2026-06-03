/// Page-routes in the app. Reference routes by `AppRoute.<name>.name`, never by
/// string literal.
enum AppRoute {
  /// The Catalog tab (top-level branch).
  catalog(routeAddress: '/catalog'),

  /// The Showcase tab (top-level branch).
  showcase(routeAddress: '/showcase'),

  /// The About tab (top-level branch).
  about(routeAddress: '/about');

  /// Address (path) of the route.
  final String routeAddress;

  const AppRoute({required this.routeAddress});
}
