import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasks/screens/home_screen.dart';
import 'package:tasks/screens/tasks_screen.dart';

class RouteGenerator extends NavigatorObserver {
  static List<Route> routeStack = [];
  static int transitionDuration = 300; // Milliseconds - The default duration
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RouteNames.HOME_SCREEN:
        var r =
            MaterialPageRoute(builder: (_) => HomeScreen(), settings: settings);
        addToStack(r);
        return r;
      case RouteNames.TASKS_SCREEN:
        var r = MaterialPageRoute(
            builder: (_) => TasksScreen(), settings: settings);
        addToStack(r);
        return r;
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: MaterialButton(
            child: Text('ERROR'),
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          ),
        ),
      );
    });
  }

  static void addToStack(MaterialPageRoute route) {
    routeStack.add(route);
    print('PUSHED A NEW ROUTE :${route.settings.name ?? 'UNKNOWN'}');
    printStackCount();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    try {
      if (route is DialogRoute || route is PopupRoute) {
        return;
      }
      routeStack.removeLast();
      print('REMOVED A ROUTE :${route.settings.name ?? 'UNKNOWN'}');
      printStackCount();
      super.didPop(route, previousRoute);
    } catch (e) {
      print('ROUTE GENERATOR EXCEPTION ${e.toString()}');
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    try {
      routeStack.removeLast();
      routeStack.add(newRoute!);
      print(
          'REPLACED A ROUTE :${newRoute.settings.name ?? 'UNKNOWN'} WITH ${oldRoute?.settings.name ?? 'UNKNOWN'}');
      printStackCount();
    } catch (e) {
      print('ROUTE GENERATOR EXCEPTION ${e.toString()}');
    }
  }

  static void printStackCount() {
    print('STACK LENGTH IS :${routeStack.length}');
  }

  static bool hasThisRoute(String routeName) {
    bool hasTheRoute = false;
    for (var route in routeStack) {
      if (route.settings.name == routeName) {
        hasTheRoute = true;
        break;
      }
    }
    return hasTheRoute;
  }

  static void handleFlowBackButton(String desiredRoute, BuildContext context) {
    if (hasThisRoute(desiredRoute)) {
      Navigator.of(context).pop();
    } else {
      Navigator.popAndPushNamed(context, desiredRoute,
          arguments: <String, bool>{'quick': true});
    }
  }
}

class RouteNames {
  static const HOME_SCREEN = '/home_screen';
  static const TASKS_SCREEN = '/tasks_screen';
  static const ADD_TASK_SCREEN = '/add_item_screen';
}

class CustomMaterialRoute extends MaterialPageRoute {
  CustomMaterialRoute({builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => Duration(milliseconds: 20);
}
