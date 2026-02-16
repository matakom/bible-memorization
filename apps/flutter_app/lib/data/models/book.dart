class Book {
  final int id;
  final String name;
  final int totalChapters;

  const Book({
    required this.id, 
    required this.name,
    required this.totalChapters
  });
  
  // Useful for debugging
  @override
  String toString() => 'Book(id: $id, name: $name)';
}