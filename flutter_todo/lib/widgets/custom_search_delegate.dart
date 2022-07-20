import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/data/local_storage.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/models/task_model.dart';
import 'package:flutter_todo/widgets/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;
  CustomSearchDelegate({required this.allTask});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTask
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList(); //Bütün görevlere bakıp, görevin ismini küçük harfe çevirip karşılaştırma yapıyoruz.
    return filteredList.length > 0
        ? ListView.builder(
            itemBuilder: (context, index) {
              var _oankiEleman = filteredList[index];
              return Dismissible(
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, color: Colors.grey),
                    SizedBox(width: 10),
                    Text('remove_task').tr()
                  ],
                ),
                key: Key(_oankiEleman.id),
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await locator<LocalStorage>().deleteTask(task: _oankiEleman);
                },
                child: TaskItem(task: _oankiEleman),
              );
            },
            itemCount: filteredList.length,
          )
        : Center(
            child: Text('search_not_found').tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
