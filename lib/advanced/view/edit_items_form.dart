import 'package:flutter/material.dart';

class EditItemsForm extends StatelessWidget {
  const EditItemsForm({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const EditItemsForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nested ReorderableListView'),
      ),
      body: MyNestedReorderableListView(),
    );
  }
}

class MyNestedReorderableListView extends StatefulWidget {
  const MyNestedReorderableListView({super.key});

  @override
  State<MyNestedReorderableListView> createState() =>
      _MyNestedReorderableListViewState();
}

class _MyNestedReorderableListViewState
    extends State<MyNestedReorderableListView> {
  List<List<String>> data = [
    ['Item 1', 'Item 2', 'Item 3'],
    ['Subitem 1', 'Subitem 2', 'Subitem 3'],
    ['NestedItem 1', 'NestedItem 2', 'NestedItem 3'],
  ];

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ReorderableListView.builder(
          key: Key('${index.toString()}'),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: data[index].length,
          itemBuilder: (context, subIndex) {
            return ListTile(
              key: Key('${index.toString()}_$subIndex'),
              title: Text(data[index][subIndex]),
            );
          },
          onReorder: (oldIndex, newIndex) {
            setState(() {
              _reorderList(data[index], oldIndex, newIndex);
            });
          },
        );
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          _reorderList(data, oldIndex, newIndex);
        });
      },
    );
  }

  void _reorderList(List list, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
  }
}
