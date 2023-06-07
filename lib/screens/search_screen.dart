import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/group/search_group_delegate.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: IconButton(
          onPressed: () {
            showSearch(context: context, delegate: SearchGroupDelegate(ref));
          },
          icon: const Icon(Icons.search)),
    );
  }
}
