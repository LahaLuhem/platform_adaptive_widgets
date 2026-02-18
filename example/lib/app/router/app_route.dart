/// Page-routes in the app
enum AppRoute {
  home(_RoutesInfo(routeAddress: '/home')),
  homeL1(_RoutesInfo(routeAddress: 'l1')),
  settings(_RoutesInfo(routeAddress: '/settings'));

  final _RoutesInfo _routeInfo;

  /// Address of the route
  String get routeAddress => _routeInfo.routeAddress;

  const AppRoute(this._routeInfo);
}

class _RoutesInfo {
  final String routeAddress;

  const _RoutesInfo({required this.routeAddress});
}
