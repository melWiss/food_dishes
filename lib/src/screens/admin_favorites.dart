import 'package:flutter/material.dart';
import 'package:food_dishes/src/blocs/dish.dart';
import 'package:food_dishes/src/blocs/favorite.dart';
import 'package:food_dishes/src/events/dish.dart';
import 'package:food_dishes/src/events/favorite.dart';
import 'package:food_dishes/src/widgets/stream.dart';

class AdminFavoritesListDesktop extends StatelessWidget {
  const AdminFavoritesListDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final _bloc = FavoriteBloc();
    return StreamWidget<FavoriteEvent>(
        stream: _bloc.stream,
        widget: (context, event) {
          return SingleChildScrollView(
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(label: Text("ID"), numeric: true),
                DataColumn(label: Text("USER"), numeric: true),
                DataColumn(label: Text("DISH"), numeric: true),
                DataColumn(label: Text("ACTIONS")),
              ],
              rows: _bloc.state
                      ?.map<DataRow>(
                        (e) => DataRow(
                          onSelectChanged: (value) {
                            _bloc.switchSelect(e);
                          },
                          selected: e.selected,
                          cells: <DataCell>[
                            DataCell(Text(e.id.toString())),
                            DataCell(Text(e.user!.email.toString())),
                            DataCell(Text(e.dish!.title.toString())),
                            DataCell(
                              ButtonBar(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList() ??
                  [],
            ),
          );
        });
  }
}

class AdminFavoritesListMobile extends StatelessWidget {
  const AdminFavoritesListMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final _bloc = FavoriteBloc();
    return StreamWidget<FavoriteEvent>(
      stream: _bloc.stream,
      widget: (context, event) {
        return ListView.builder(
          itemCount: _bloc.state!.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(_bloc.state![index].user!.email!),
            leading: Text(_bloc.state![index].dish!.title!),
          ),
        );
      },
    );
  }
}
