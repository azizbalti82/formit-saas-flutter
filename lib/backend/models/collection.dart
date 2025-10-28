class Collection {
  final String id;
  String name;
  DateTime createdAt;
  String? parentId; //if parentId=null then this is root

  Collection({
    required this.id,
    required this.name,
    required this.parentId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}