import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project/provider/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserData extends ConsumerStatefulWidget {
  const UserData({super.key});

  @override
  ConsumerState<UserData> createState() {
    return _UserDataState();
  }
}

class _UserDataState extends ConsumerState<UserData> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            foregroundImage:
                user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
            maxRadius: 80,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(user.name!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white70)),
          Text(user.email!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white70))
        ],
      ),
    );
  }
}
