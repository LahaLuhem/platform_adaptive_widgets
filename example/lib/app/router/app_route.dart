/// Page-routes in the app. Reference routes by `AppRoute.<name>.name`, never by string literal.
enum AppRoute {
  catalog(routeAddress: '/catalog'),

  showcase(routeAddress: '/showcase'),

  about(routeAddress: '/about');

  final String routeAddress;

  const AppRoute({required this.routeAddress});
}
