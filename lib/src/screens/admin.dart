import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:food_dishes/src/screens/dishes_list.dart';
import 'package:food_dishes/src/screens/users.dart';
import 'package:food_dishes/src/widgets/stream.dart';
import 'package:rxdart/rxdart.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

BehaviorSubject<int> indexController = BehaviorSubject<int>.seeded(0);

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
      ),
      backgroundColor: Colors.white,
      body: size.width > size.height ? AdminDesktopBody() : AdminMobileBody(),
    );
  }
}

class AdminDesktopBody extends StatefulWidget {
  const AdminDesktopBody({super.key});

  @override
  State<AdminDesktopBody> createState() => _AdminDesktopBodyState();
}

class _AdminDesktopBodyState extends State<AdminDesktopBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _menuIconController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 200),
  );
  late Animation<double> _menuIconAnimation =
      Tween<double>(begin: 0, end: 1).animate(_menuIconController);
  bool extended = false;
  @override
  Widget build(BuildContext context) {
    return StreamWidget<int>(
      stream: indexController.stream,
      widget: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NavigationRail(
              selectedIndex: index,
              leading: IconButton(
                onPressed: () {
                  if (_menuIconController.isCompleted) {
                    _menuIconController.reverse();
                  } else {
                    _menuIconController.forward();
                  }
                  setState(() {
                    extended = !extended;
                  });
                },
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: _menuIconAnimation,
                ),
              ),
              extended: extended,
              onDestinationSelected: (value) => indexController.add(value),
              destinations: <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text("Users"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.food_bank),
                  label: Text("Dishes"),
                ),
              ],
            ),
            Expanded(
              child: Material(
                color: Colors.grey.shade100,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                ),
                elevation: 8,
                child: [UsersListDesktop(), DishesList()][index],
              ),
            ),
          ],
        );
      },
    );
  }
}

class AdminMobileBody extends StatelessWidget {
  const AdminMobileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamWidget<int>(
      stream: indexController.stream,
      widget: (context, index) {
        return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Material(
              child: [UsersListMobile(), DishesList()][index],
              color: Colors.grey.shade100,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              elevation: 8,
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            onDestinationSelected: (value) => indexController.add(value),
            destinations: <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.person),
                label: "Users",
              ),
              NavigationDestination(
                icon: Icon(Icons.food_bank),
                label: "Dishes",
              ),
            ],
          ),
        );
      },
    );
  }
}
