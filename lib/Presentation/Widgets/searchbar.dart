import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget{
  const SearchWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              elevation: MaterialStateProperty.all<double>(0),
              controller: controller,
              backgroundColor: MaterialStateColor
                  .resolveWith(
                      (states) => Colors.blue.shade300.withOpacity(0.1)
              ),
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              trailing: const [
                Icon(Icons.search)
              ],
              hintText: 'Search Applications',
            );
          },
          suggestionsBuilder:
          (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              /*setState(() {
                controller.closeView(item);
              });*/
            },
          );
        });
      }),
    );
  }
}
