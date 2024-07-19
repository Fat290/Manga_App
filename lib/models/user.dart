class User {
  final int? userId;
  final String? name;
  final String? email;
  final String? avatar;
  final String? token;
  User( {
    this.userId, this.name, this.email,this.avatar,this.token
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user']['user_id'],
      name: json['user']['name'],
      email: json['user']['email'],
      avatar: json['user']['avatar'],
      token: json['token']
    );
  }
}
