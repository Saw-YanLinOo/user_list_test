class User {
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
    );
  }

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String image;

  String get fullName => '$firstName $lastName';

  @override
  bool operator ==(Object other) {
    return other is User &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.image == image;
  }

  @override
  int get hashCode => Object.hash(id, firstName, lastName, email, image);
}
