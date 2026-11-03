/// Page-routes in the app. Reference routes by `AppRoute.<name>.name`, never by string literal.
enum AppRoute({required final String routeAddress}) {
  catalog(routeAddress: '/catalog'),

  showcase(routeAddress: '/showcase'),

  about(routeAddress: '/about'),
}
