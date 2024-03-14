import 'package:flutter/material.dart';
import 'route_names.dart';

/// Предоставляет способ отслеживать навигационные действия пользователя в приложении,
/// такие как переход на новый экран или возврат к предыдущему экрану, и отправлять соответствующую
/// информацию в сервис аналитики.
class CustomNavigatorObserver extends NavigatorObserver {
  // final _analService = GetIt.instance<AnalyticsFacadeService>();
  // final _networkService = GetIt.instance<NetworkService>();
  Route<dynamic>? previousRoute;

  /// Вызывается при возврате на предыдущий экран.
  /// [route] - текущий маршрут.
  /// [previousRoute] - маршрут предыдущего экрана.
  @override
  void didPop(Route route, Route? previousRoute) {
    // final newRoute = previousRoute?.settings.name;
    // _analService.setCurrentScreen(newRoute);
    this.previousRoute = route;
    super.didPop(route, previousRoute);
  }

  /// Вызывается при переходе на новый экран.
  /// [route] - маршрут нового экрана.
  /// [previousRoute] - текущий маршрут.
  /// При отсутствии интернет-соединения происходит переход на экран [RouteNames.noConnection]
  @override
  void didPush(Route route, Route? previousRoute) async {
    // final newRoute = route.settings.name;
    // _analService.setCurrentScreen(newRoute);
    // if (route.settings.name != RouteNames.noConnection &&
    //     !(await _networkService.checkConnection())) {
    //   route.navigator?.pushNamed(RouteNames.noConnection);
    // }
    this.previousRoute = previousRoute;
    super.didPush(route, previousRoute);
  }

  /// Вызывается при замене текущего экрана на новый.
  /// [newRoute] - маршрут нового экрана.
  /// [oldRoute] - маршрут текущего экрана.
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    // final newRouteName = newRoute?.settings.name;
    // _analService.setCurrentScreen(newRouteName);
    this.previousRoute = oldRoute;
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}