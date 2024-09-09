import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalleryList extends ConsumerStatefulWidget {
  const GalleryList({super.key});

  @override
  ConsumerState<GalleryList> createState() {
    return _GlalleryListState();
  }
}

class _GlalleryListState extends ConsumerState<GalleryList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        padding: const EdgeInsets.all(10),
        itemCount: 100,
        itemBuilder: ((ctx, i) => const Card(
              child: ListTile(
                leading: Icon(Icons.place),
                title: Text('Place'),
              ),
            )),
      ),
    );
  }
}
