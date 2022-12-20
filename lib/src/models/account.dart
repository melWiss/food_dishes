import 'dart:convert';

enum Role { user, admin }

class Account {
  // TODO: [Account] add your missing properties and methods here.
  int? id;
  String? email;
  String? password;
  Role? role;
  Account({
    this.id,
    this.email,
    this.password,
    this.role,
  });

  Account copyWith({
    int? id,
    String? email,
    String? password,
    Role? role,
  }) {
    return Account(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role?.index,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id']?.toInt(),
      email: map['email'],
      password: map['password'],
      role: map['role'] != null ? Role.values[map['index']] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Account(id: $id, email: $email, password: $password, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Account &&
        other.id == id &&
        other.email == email &&
        other.password == password &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ password.hashCode ^ role.hashCode;
  }
}
