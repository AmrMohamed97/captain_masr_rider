void main() {
  Map<dynamic, dynamic> data = {"1": {"a": "b"}};
  var res = data.map((key, value) => MapEntry(key, value as Map));
  print(res.runtimeType);
}
