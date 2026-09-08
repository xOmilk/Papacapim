import 'package:flutter_project/ui/components/feed_list_view.dart';
import 'package:flutter/material.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeedListView(params: (feed: 1, search: null));
  }
}
