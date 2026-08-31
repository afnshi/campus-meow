import 'package:flutter/material.dart';

import '../app_view_model.dart';

class AuthView extends StatefulWidget {
  const AuthView({required this.viewModel, super.key});
  final AppViewModel viewModel;

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _nickname = TextEditingController();
  bool _register = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _nickname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.pets, size: 72),
                  Text(
                    'CampusMeow',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _username,
                    decoration: const InputDecoration(labelText: '用户名'),
                    validator: (value) =>
                        (value ?? '').length < 3 ? '用户名至少 3 位' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: '密码'),
                    validator: (value) =>
                        (value ?? '').length < 8 ? '密码至少 8 位' : null,
                  ),
                  if (_register) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nickname,
                      decoration: const InputDecoration(labelText: '昵称'),
                      validator: (value) =>
                          (value ?? '').trim().isEmpty ? '请输入昵称' : null,
                    ),
                  ],
                  if (widget.viewModel.error case final message?) ...[
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: widget.viewModel.loading ? null : _submit,
                    child: Text(
                      widget.viewModel.loading
                          ? '请稍候…'
                          : (_register ? '注册' : '登录'),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.viewModel.loading
                        ? null
                        : () => setState(() => _register = !_register),
                    child: Text(_register ? '已有账号，去登录' : '没有账号，去注册'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_register) {
      widget.viewModel.register(
        _username.text.trim(),
        _password.text,
        _nickname.text.trim(),
      );
    } else {
      widget.viewModel.login(_username.text.trim(), _password.text);
    }
  }
}
