class User {
  int? _ID;
  String? _username;
  int? _password;

  User(this._username, this._password);
  User.withId(this._ID, this._username, this._password);

  int get id => _ID!;
  String get username => _username!;
  int get password => _password!;

  set username(String newUsername) {
    _username = newUsername;
  }

  set password(int newPassword) {
    _password = newPassword;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (_ID != null) {
      map['id'] = _ID;
    }
    map['username'] = _username;
    map['password'] = _password;
    return map;
  }

  User.fromMapObject(Map<String, dynamic> map) {
    this._ID = map['id'];
    this._username = map['username'];
    this._password = map['password'];
  }
}
