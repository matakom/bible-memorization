class BibleTranslation {
  final String id;           // Unique ID
  final String name;         // Full name
  final String abbreviation; // For display
  final String assetPath;    // JSON file location

  const BibleTranslation({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.assetPath,
  });
}

const List<BibleTranslation> availableBibleTranslations = [
  BibleTranslation(
    id: 'b21',
    name: 'Bible 21',
    abbreviation: 'B21',
    assetPath: 'assets/bible/b21.json',
  ),
  BibleTranslation(
    id: 'ekumena',
    name: 'Bible Ekumenická',
    abbreviation: 'EK',
    assetPath: 'assets/bible/ekumena.json',
  ),
  BibleTranslation(
    id: 'kralicka',
    name: 'Bible Kralická',
    abbreviation: 'KR',
    assetPath: 'assets/bible/kralicka.json',
  ),
];