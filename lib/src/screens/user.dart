import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:food_dishes/src/blocs/account.dart';
import 'package:food_dishes/src/blocs/authentication.dart';
import 'package:food_dishes/src/blocs/dish.dart';
import 'package:food_dishes/src/blocs/favorite.dart';
import 'package:food_dishes/src/models/role/role.dart';
import 'package:food_dishes/src/screens/add_dish_dialog.dart';
import 'package:food_dishes/src/screens/add_favorite_dialog.dart';
import 'package:food_dishes/src/screens/add_user_dialog.dart';
import 'package:food_dishes/src/screens/admin_favorites.dart';
import 'package:food_dishes/src/screens/delete_dialog.dart';
import 'package:food_dishes/src/screens/dishes_list.dart';
import 'package:food_dishes/src/screens/logout_dialog.dart';
import 'package:food_dishes/src/screens/users.dart';
import 'package:food_dishes/src/widgets/stream.dart';
import 'package:rxdart/rxdart.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

BehaviorSubject<int> indexController = BehaviorSubject<int>.seeded(0);
BehaviorSubject<bool> extendedController = BehaviorSubject<bool>.seeded(false);

class _UserScreenState extends State<UserScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _menuIconController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 200),
  );
  late Animation<double> _menuIconAnimation =
      Tween<double>(begin: 0, end: 1).animate(_menuIconController);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("User"),
        actions: [
          if (size.width <= size.height)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      LogoutDialog(onLogout: AuthenticationBloc().logout),
                );
              },
              icon: Icon(Icons.logout),
            ),
        ],
        leading: size.width > size.height
            ? IconButton(
                onPressed: () {
                  if (_menuIconController.isCompleted) {
                    _menuIconController.reverse();
                  } else {
                    _menuIconController.forward();
                  }
                  extendedController.add(!extendedController.value);
                },
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: _menuIconAnimation,
                ),
              )
            : null,
      ),
      backgroundColor: Colors.white,
      body: size.width > size.height ? AdminDesktopBody() : AdminMobileBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () {
          showDialog(
            context: context,
            builder: ((context) => DeleteDialog(
                  onDelete: () {
                    switch (indexController.value) {
                      case 0:
                        AccountBloc().deleteSelected();
                        break;
                      case 1:
                        DishBloc().deleteSelected();
                        break;
                      default:
                        FavoriteBloc().deleteSelected();
                    }
                  },
                )),
          );
        },
      ),
    );
  }
}

class AdminDesktopBody extends StatefulWidget {
  const AdminDesktopBody({super.key});

  @override
  State<AdminDesktopBody> createState() => _AdminDesktopBodyState();
}

class _AdminDesktopBodyState extends State<AdminDesktopBody> {
  @override
  Widget build(BuildContext context) {
    return StreamWidget<bool>(
        stream: extendedController,
        widget: (context, extended) {
          return StreamWidget<int>(
            stream: indexController.stream,
            widget: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NavigationRail(
                    selectedIndex: index,
                    extended: extended,
                    onDestinationSelected: (value) =>
                        indexController.add(value),
                    trailing: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height - 220),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => LogoutDialog(
                                onLogout: AuthenticationBloc().logout),
                          );
                        },
                        icon: Icon(Icons.logout),
                      ),
                    ),
                    destinations: <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: Icon(Icons.food_bank),
                        label: Text("Dishes"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text("Favorites"),
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
                      child: [
                        DishesListDesktop(),
                        AdminFavoritesListDesktop(),
                      ][index],
                    ),
                  ),
                ],
              );
            },
          );
        });
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
              child: [
                DishesListMobile(),
                AdminFavoritesListMobile(),
              ][index],
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
                icon: Icon(Icons.food_bank),
                label: "Dishes",
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite),
                label: "Favorites",
              ),
            ],
          ),
        );
      },
    );
  }
}
