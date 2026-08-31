class User {
  const User({
    required this.id,
    required this.username,
    required this.nickname,
    this.birthday,
    this.school,
    this.className,
    this.bio,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, Object?> json) => User(
    id: json['id']! as int,
    username: json['username']! as String,
    nickname: json['nickname']! as String,
    birthday: json['birthday'] as String?,
    school: json['school'] as String?,
    className: json['className'] as String?,
    bio: json['bio'] as String?,
    avatarUrl: json['avatarUrl'] as String?,
  );

  final int id;
  final String username;
  final String nickname;
  final String? birthday;
  final String? school;
  final String? className;
  final String? bio;
  final String? avatarUrl;
}

class UserSummary {
  const UserSummary({
    required this.id,
    required this.nickname,
    this.school,
    this.avatarUrl,
  });

  factory UserSummary.fromJson(Map<String, Object?> json) => UserSummary(
    id: json['id']! as int,
    nickname: json['nickname']! as String,
    school: json['school'] as String?,
    avatarUrl: json['avatarUrl'] as String?,
  );

  final int id;
  final String nickname;
  final String? school;
  final String? avatarUrl;
}
