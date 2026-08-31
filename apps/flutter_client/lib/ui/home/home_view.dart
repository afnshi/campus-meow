import 'package:flutter/material.dart';

import '../../domain/models/post.dart';
import '../app_view_model.dart';
import '../profile/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({required this.viewModel, super.key});
  final AppViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      PostFeed(viewModel: widget.viewModel),
      ProfileView(viewModel: widget.viewModel),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(_index == 0 ? '校园广场' : '我的资料')),
      body: pages[_index],
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: _newPost,
              icon: const Icon(Icons.add),
              label: const Text('发布'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.forum_outlined), label: '广场'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '我的'),
        ],
      ),
    );
  }

  Future<void> _newPost() async {
    final title = TextEditingController();
    final content = TextEditingController();
    final submitted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('发布帖子'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: '标题'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: content,
              maxLines: 4,
              decoration: const InputDecoration(labelText: '正文'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('发布'),
          ),
        ],
      ),
    );
    if (submitted == true &&
        title.text.trim().isNotEmpty &&
        content.text.trim().isNotEmpty) {
      await widget.viewModel.createPost(title.text.trim(), content.text.trim());
    }
    title.dispose();
    content.dispose();
  }
}

class PostFeed extends StatefulWidget {
  const PostFeed({required this.viewModel, super.key});
  final AppViewModel viewModel;

  @override
  State<PostFeed> createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  @override
  void initState() {
    super.initState();
    if (widget.viewModel.posts.isEmpty) widget.viewModel.loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.loading && widget.viewModel.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.viewModel.posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: widget.viewModel.loadPosts,
        child: ListView(
          children: [
            SizedBox(height: 220),
            Center(child: Text('还没有帖子')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: widget.viewModel.loadPosts,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: widget.viewModel.posts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            PostCard(post: widget.viewModel.posts[index]),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({required this.post, super.key});
  final Post post;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.author.nickname,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Text(post.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(post.content, maxLines: 4, overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
  );
}
