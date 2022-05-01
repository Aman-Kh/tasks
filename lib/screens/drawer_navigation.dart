import 'package:flutter/material.dart';
import 'package:tasks/config/app_router.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Aman Kharzoum'),
              accountEmail: Text('aman.kharzoum@gmail.com'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () =>
                  Navigator.of(context).pushNamed(RouteNames.HOME_SCREEN),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Tasks'),
              onTap: () =>
                  Navigator.of(context).pushNamed(RouteNames.TASKS_SCREEN),
            )
          ],
        ),
      ),
    );
  }
}
