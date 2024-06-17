class LocalFile {
  final String path;
  final String name;
  LocalFile(this.path, this.name);

  factory LocalFile.fromJson(Map<String, dynamic> json) {
    return LocalFile(json['path'], json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'path': path, 'name': name};
  }

  // 重载 == 操作符
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalFile &&
          runtimeType == other.runtimeType &&
          path == other.path && 
          name == other.name;
  // 重载 hashCode 方法
  @override
  int get hashCode => name.hashCode ^ path.hashCode;

  @override
  String toString() {
    return 'Person{name: $name, path: $path}';
  }
}
