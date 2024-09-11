import 'package:flutter/material.dart';
import 'package:flutter_project/models/filters_model.dart';
import 'package:flutter_project/provider/filters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FiltersScreen extends ConsumerStatefulWidget {
  const FiltersScreen({super.key});

  @override
  ConsumerState<FiltersScreen> createState() {
    return _FiltersScreenState();
  }
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(filtersProvider);
    return Scaffold(
        appBar: AppBar(
            foregroundColor: Colors.white70,
            title: const Text(
              'Filters',
              style: TextStyle(color: Colors.white70),
            ),
            backgroundColor:
                Theme.of(context).colorScheme.onSecondaryContainer),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.6)
            ],
          )),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Old todos first',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Switch(
                      value: filters.isOldFirst,
                      onChanged: (value) {
                        ref.read(filtersProvider.notifier).toggleIsOldFirst();
                      }),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Only done todos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Switch(
                      value: filters.isDone,
                      onChanged: (value) {
                        ref.read(filtersProvider.notifier).toggleIsDone();
                      }),
                ],
              ),
              DropdownButton(
                  iconEnabledColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  dropdownColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  value: filters.status.name,
                  items: [
                    for (final status in FilterStatus.values)
                      DropdownMenuItem(
                          value: status.name,
                          child: Text(
                            status.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                  ],
                  onChanged: (newValue) {
                    final updated = FilterStatus.values
                        .where((el) => el.name == newValue)
                        .toList();
                    print(updated[0].name);
                    ref.read(filtersProvider.notifier).updateStatus(updated[0]);
                  }),
            ],
          ),
        ));
  }
}
