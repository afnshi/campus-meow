import 'package:flutter/material.dart';

import '../app_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({required this.viewModel, super.key});
  final AppViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final user = viewModel.user!;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
        const SizedBox(height: 16),
        Text(
          user.nickname,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text('@${user.username}', textAlign: TextAlign.center),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.school),
          title: Text(user.school ?? '未填写学校'),
        ),
        ListTile(
          leading: const Icon(Icons.groups),
          title: Text(user.className ?? '未填写班级'),
        ),
        ListTile(
          leading: const Icon(Icons.notes),
          title: Text(user.bio ?? '未填写简介'),
        ),
        const SizedBox(height: 16),
        FilledButton.tonal(
          onPressed: () => _edit(context),
          child: const Text('编辑资料'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: viewModel.logout, child: const Text('退出登录')),
      ],
    );
  }

  Future<void> _edit(BuildContext context) async {
    final user = viewModel.user!;
    final nickname = TextEditingController(text: user.nickname);
    final school = TextEditingController(text: user.school);
    final className = TextEditingController(text: user.className);
    final bio = TextEditingController(text: user.bio);
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑资料'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nickname,
                decoration: const InputDecoration(labelText: '昵称'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: school,
                decoration: const InputDecoration(labelText: '学校'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: className,
                decoration: const InputDecoration(labelText: '班级'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bio,
                decoration: const InputDecoration(labelText: '简介'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (saved == true && nickname.text.trim().isNotEmpty) {
      await viewModel.updateProfile(
        nickname.text.trim(),
        school.text.trim(),
        className.text.trim(),
        bio.text.trim(),
      );
    }
    nickname.dispose();
    school.dispose();
    className.dispose();
    bio.dispose();
  }
}
