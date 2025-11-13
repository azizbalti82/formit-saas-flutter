import '../backend/models/collection/collection.dart';

final List<Collection> fakeCollections = [
  // 🌳 Root collection
  Collection(id: '1', name: 'Root', parentId: null),

  // 📁 Level 1 (children of Root)
  Collection(id: '2', name: 'Documents', parentId: '1'),
  Collection(id: '3', name: 'Images', parentId: '1'),
  Collection(id: '4', name: 'Videos', parentId: '1'),

  // 🗂 Level 2 (children of Documents)
  Collection(id: '5', name: 'Work', parentId: '2'),
  Collection(id: '6', name: 'Personal', parentId: '2'),

  // 🖼 Level 2 (children of Images)
  Collection(id: '7', name: 'Travel', parentId: '3'),
  Collection(id: '8', name: 'Family', parentId: '3'),

  // 🎬 Level 2 (children of Videos)
  Collection(id: '9', name: 'Projects', parentId: '4'),
  Collection(id: '10', name: 'Tutorials', parentId: '4'),

  // 📄 Level 3 (children of Work)
  Collection(id: '11', name: 'Reports', parentId: '5'),
  Collection(id: '12', name: 'Presentations', parentId: '5'),
];