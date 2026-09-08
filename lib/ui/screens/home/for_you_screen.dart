import 'package:flutter_project/ui/components/feed_list_view.dart';
import 'package:flutter/material.dart';

class ForYouScreen extends StatelessWidget {
  const ForYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeedListView(params: (feed: null, search: null));
  }
}
