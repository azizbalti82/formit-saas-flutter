

enum PathType {
  section,
  collection,
}

class Path {
  final String title;
  final PathType type;
  final String? collectionId;

  Path({
    required this.title,
    required this.type,
    this.collectionId
  });

  // ✅ Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Path &&
        other.title == title &&
        other.type == type;
  }
}


//all paths
enum AppPath {
  home,
  templates,
  trash,
  collections,
  favorites,
  billing
}

extension AppPathExtension on AppPath {
  Path data({String? folderName,String? collectionId}) {
    switch (this) {
      case AppPath.home:
        return Path(
          title: 'Home',
          type: PathType.section,
        );
      case AppPath.templates:
        return Path(
          title: 'Templates',
          type: PathType.section,
        );
      case AppPath.favorites:
        return Path(
          title: 'Favorites',
          type: PathType.section,
        );
      case AppPath.trash:
        return Path(
          title: 'Trash',
          type: PathType.section,
        );
      case AppPath.billing:
        return Path(
          title: 'Billing & usage',
          type: PathType.section,
        );
      case AppPath.collections:
        return Path(
          title: folderName??"Collection",
          type: PathType.collection,
          collectionId: collectionId
        );
    }
  }
}
