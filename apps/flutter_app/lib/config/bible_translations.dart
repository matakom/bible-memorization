/// Model and constant list for supported Bible versions.
class BibleTranslation {
  final String id;
  final String name;
  final String abbreviation;
  final String assetPath;

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