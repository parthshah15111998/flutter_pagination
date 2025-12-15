class UserModel {
  final int id;
  final String login;
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.login,
    required this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      login: json['login'],
      avatarUrl: json['avatar_url'],
    );
  }
}
