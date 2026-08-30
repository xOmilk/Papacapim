import 'package:flutter/material.dart';
import 'package:flutter_project/ui/screens/home/following_screen.dart';
import 'package:flutter_project/ui/screens/home/for_you_screen.dart';
import 'package:go_router/go_router.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onFabPress() {
    context.push("/create-post");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Following"),
            Tab(text: "For you"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [FollowingScreen(), ForYouScreen()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onFabPress,
        child: const Icon(Icons.add),
      ),
    );
  }
}
