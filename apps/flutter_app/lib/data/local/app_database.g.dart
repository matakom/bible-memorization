// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalBibleVersesTable extends LocalBibleVerses
    with TableInfo<$LocalBibleVersesTable, LocalBibleVerse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalBibleVersesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  @override
  late final GeneratedColumn<int> book = GeneratedColumn<int>(
    'book',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
    'verse',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textContentMeta = const VerificationMeta(
    'textContent',
  );
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
    'text_content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordCountMeta = const VerificationMeta(
    'wordCount',
  );
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
    'word_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    book,
    chapter,
    verse,
    textContent,
    translation,
    wordCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_bible_verses';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalBibleVerse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book')) {
      context.handle(
        _bookMeta,
        book.isAcceptableOrUnknown(data['book']!, _bookMeta),
      );
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
        _verseMeta,
        verse.isAcceptableOrUnknown(data['verse']!, _verseMeta),
      );
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('text_content')) {
      context.handle(
        _textContentMeta,
        textContent.isAcceptableOrUnknown(
          data['text_content']!,
          _textContentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    if (data.containsKey('word_count')) {
      context.handle(
        _wordCountMeta,
        wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta),
      );
    } else if (isInserting) {
      context.missing(_wordCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {book, chapter, verse, translation},
  ];
  @override
  LocalBibleVerse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalBibleVerse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      book: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      verse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse'],
      )!,
      textContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_content'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      )!,
      wordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_count'],
      )!,
    );
  }

  @override
  $LocalBibleVersesTable createAlias(String alias) {
    return $LocalBibleVersesTable(attachedDatabase, alias);
  }
}

class LocalBibleVerse extends DataClass implements Insertable<LocalBibleVerse> {
  final int id;
  final int book;
  final int chapter;
  final int verse;
  final String textContent;
  final String translation;
  final int wordCount;
  const LocalBibleVerse({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.textContent,
    required this.translation,
    required this.wordCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book'] = Variable<int>(book);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['text_content'] = Variable<String>(textContent);
    map['translation'] = Variable<String>(translation);
    map['word_count'] = Variable<int>(wordCount);
    return map;
  }

  LocalBibleVersesCompanion toCompanion(bool nullToAbsent) {
    return LocalBibleVersesCompanion(
      id: Value(id),
      book: Value(book),
      chapter: Value(chapter),
      verse: Value(verse),
      textContent: Value(textContent),
      translation: Value(translation),
      wordCount: Value(wordCount),
    );
  }

  factory LocalBibleVerse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalBibleVerse(
      id: serializer.fromJson<int>(json['id']),
      book: serializer.fromJson<int>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      textContent: serializer.fromJson<String>(json['textContent']),
      translation: serializer.fromJson<String>(json['translation']),
      wordCount: serializer.fromJson<int>(json['wordCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'book': serializer.toJson<int>(book),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'textContent': serializer.toJson<String>(textContent),
      'translation': serializer.toJson<String>(translation),
      'wordCount': serializer.toJson<int>(wordCount),
    };
  }

  LocalBibleVerse copyWith({
    int? id,
    int? book,
    int? chapter,
    int? verse,
    String? textContent,
    String? translation,
    int? wordCount,
  }) => LocalBibleVerse(
    id: id ?? this.id,
    book: book ?? this.book,
    chapter: chapter ?? this.chapter,
    verse: verse ?? this.verse,
    textContent: textContent ?? this.textContent,
    translation: translation ?? this.translation,
    wordCount: wordCount ?? this.wordCount,
  );
  LocalBibleVerse copyWithCompanion(LocalBibleVersesCompanion data) {
    return LocalBibleVerse(
      id: data.id.present ? data.id.value : this.id,
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      textContent: data.textContent.present
          ? data.textContent.value
          : this.textContent,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalBibleVerse(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('textContent: $textContent, ')
          ..write('translation: $translation, ')
          ..write('wordCount: $wordCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    book,
    chapter,
    verse,
    textContent,
    translation,
    wordCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalBibleVerse &&
          other.id == this.id &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.textContent == this.textContent &&
          other.translation == this.translation &&
          other.wordCount == this.wordCount);
}

class LocalBibleVersesCompanion extends UpdateCompanion<LocalBibleVerse> {
  final Value<int> id;
  final Value<int> book;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<String> textContent;
  final Value<String> translation;
  final Value<int> wordCount;
  const LocalBibleVersesCompanion({
    this.id = const Value.absent(),
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.textContent = const Value.absent(),
    this.translation = const Value.absent(),
    this.wordCount = const Value.absent(),
  });
  LocalBibleVersesCompanion.insert({
    this.id = const Value.absent(),
    required int book,
    required int chapter,
    required int verse,
    required String textContent,
    required String translation,
    required int wordCount,
  }) : book = Value(book),
       chapter = Value(chapter),
       verse = Value(verse),
       textContent = Value(textContent),
       translation = Value(translation),
       wordCount = Value(wordCount);
  static Insertable<LocalBibleVerse> custom({
    Expression<int>? id,
    Expression<int>? book,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<String>? textContent,
    Expression<String>? translation,
    Expression<int>? wordCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (textContent != null) 'text_content': textContent,
      if (translation != null) 'translation': translation,
      if (wordCount != null) 'word_count': wordCount,
    });
  }

  LocalBibleVersesCompanion copyWith({
    Value<int>? id,
    Value<int>? book,
    Value<int>? chapter,
    Value<int>? verse,
    Value<String>? textContent,
    Value<String>? translation,
    Value<int>? wordCount,
  }) {
    return LocalBibleVersesCompanion(
      id: id ?? this.id,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      textContent: textContent ?? this.textContent,
      translation: translation ?? this.translation,
      wordCount: wordCount ?? this.wordCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (book.present) {
      map['book'] = Variable<int>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalBibleVersesCompanion(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('textContent: $textContent, ')
          ..write('translation: $translation, ')
          ..write('wordCount: $wordCount')
          ..write(')'))
        .toString();
  }
}

class $SavedVersesTable extends SavedVerses
    with TableInfo<$SavedVersesTable, SavedVerse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedVersesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  @override
  late final GeneratedColumn<int> book = GeneratedColumn<int>(
    'book',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
    'verse',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextReviewDateMeta = const VerificationMeta(
    'nextReviewDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewDate =
      GeneratedColumn<DateTime>(
        'next_review_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sm2EaseFactorMeta = const VerificationMeta(
    'sm2EaseFactor',
  );
  @override
  late final GeneratedColumn<double> sm2EaseFactor = GeneratedColumn<double>(
    'sm2_ease_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _sm2IntervalDaysMeta = const VerificationMeta(
    'sm2IntervalDays',
  );
  @override
  late final GeneratedColumn<int> sm2IntervalDays = GeneratedColumn<int>(
    'sm2_interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sm2RepetitionCountMeta =
      const VerificationMeta('sm2RepetitionCount');
  @override
  late final GeneratedColumn<int> sm2RepetitionCount = GeneratedColumn<int>(
    'sm2_repetition_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hlrStabilityMeta = const VerificationMeta(
    'hlrStability',
  );
  @override
  late final GeneratedColumn<double> hlrStability = GeneratedColumn<double>(
    'hlr_stability',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlrDifficultyMeta = const VerificationMeta(
    'hlrDifficulty',
  );
  @override
  late final GeneratedColumn<double> hlrDifficulty = GeneratedColumn<double>(
    'hlr_difficulty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hlrCorrectCountMeta = const VerificationMeta(
    'hlrCorrectCount',
  );
  @override
  late final GeneratedColumn<int> hlrCorrectCount = GeneratedColumn<int>(
    'hlr_correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hlrIncorrectCountMeta = const VerificationMeta(
    'hlrIncorrectCount',
  );
  @override
  late final GeneratedColumn<int> hlrIncorrectCount = GeneratedColumn<int>(
    'hlr_incorrect_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    book,
    chapter,
    verse,
    translation,
    nextReviewDate,
    sm2EaseFactor,
    sm2IntervalDays,
    sm2RepetitionCount,
    hlrStability,
    hlrDifficulty,
    hlrCorrectCount,
    hlrIncorrectCount,
    updatedAt,
    needsSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_verses';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedVerse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book')) {
      context.handle(
        _bookMeta,
        book.isAcceptableOrUnknown(data['book']!, _bookMeta),
      );
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
        _verseMeta,
        verse.isAcceptableOrUnknown(data['verse']!, _verseMeta),
      );
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    if (data.containsKey('next_review_date')) {
      context.handle(
        _nextReviewDateMeta,
        nextReviewDate.isAcceptableOrUnknown(
          data['next_review_date']!,
          _nextReviewDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextReviewDateMeta);
    }
    if (data.containsKey('sm2_ease_factor')) {
      context.handle(
        _sm2EaseFactorMeta,
        sm2EaseFactor.isAcceptableOrUnknown(
          data['sm2_ease_factor']!,
          _sm2EaseFactorMeta,
        ),
      );
    }
    if (data.containsKey('sm2_interval_days')) {
      context.handle(
        _sm2IntervalDaysMeta,
        sm2IntervalDays.isAcceptableOrUnknown(
          data['sm2_interval_days']!,
          _sm2IntervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('sm2_repetition_count')) {
      context.handle(
        _sm2RepetitionCountMeta,
        sm2RepetitionCount.isAcceptableOrUnknown(
          data['sm2_repetition_count']!,
          _sm2RepetitionCountMeta,
        ),
      );
    }
    if (data.containsKey('hlr_stability')) {
      context.handle(
        _hlrStabilityMeta,
        hlrStability.isAcceptableOrUnknown(
          data['hlr_stability']!,
          _hlrStabilityMeta,
        ),
      );
    }
    if (data.containsKey('hlr_difficulty')) {
      context.handle(
        _hlrDifficultyMeta,
        hlrDifficulty.isAcceptableOrUnknown(
          data['hlr_difficulty']!,
          _hlrDifficultyMeta,
        ),
      );
    }
    if (data.containsKey('hlr_correct_count')) {
      context.handle(
        _hlrCorrectCountMeta,
        hlrCorrectCount.isAcceptableOrUnknown(
          data['hlr_correct_count']!,
          _hlrCorrectCountMeta,
        ),
      );
    }
    if (data.containsKey('hlr_incorrect_count')) {
      context.handle(
        _hlrIncorrectCountMeta,
        hlrIncorrectCount.isAcceptableOrUnknown(
          data['hlr_incorrect_count']!,
          _hlrIncorrectCountMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedVerse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedVerse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      book: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      verse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      )!,
      nextReviewDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_date'],
      )!,
      sm2EaseFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sm2_ease_factor'],
      )!,
      sm2IntervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sm2_interval_days'],
      )!,
      sm2RepetitionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sm2_repetition_count'],
      )!,
      hlrStability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hlr_stability'],
      ),
      hlrDifficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hlr_difficulty'],
      ),
      hlrCorrectCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hlr_correct_count'],
      )!,
      hlrIncorrectCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hlr_incorrect_count'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
    );
  }

  @override
  $SavedVersesTable createAlias(String alias) {
    return $SavedVersesTable(attachedDatabase, alias);
  }
}

class SavedVerse extends DataClass implements Insertable<SavedVerse> {
  final String id;
  final int book;
  final int chapter;
  final int verse;
  final String translation;
  final DateTime nextReviewDate;
  final double sm2EaseFactor;
  final int sm2IntervalDays;
  final int sm2RepetitionCount;
  final double? hlrStability;
  final double? hlrDifficulty;
  final int hlrCorrectCount;
  final int hlrIncorrectCount;
  final DateTime updatedAt;
  final bool needsSync;
  const SavedVerse({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.translation,
    required this.nextReviewDate,
    required this.sm2EaseFactor,
    required this.sm2IntervalDays,
    required this.sm2RepetitionCount,
    this.hlrStability,
    this.hlrDifficulty,
    required this.hlrCorrectCount,
    required this.hlrIncorrectCount,
    required this.updatedAt,
    required this.needsSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book'] = Variable<int>(book);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['translation'] = Variable<String>(translation);
    map['next_review_date'] = Variable<DateTime>(nextReviewDate);
    map['sm2_ease_factor'] = Variable<double>(sm2EaseFactor);
    map['sm2_interval_days'] = Variable<int>(sm2IntervalDays);
    map['sm2_repetition_count'] = Variable<int>(sm2RepetitionCount);
    if (!nullToAbsent || hlrStability != null) {
      map['hlr_stability'] = Variable<double>(hlrStability);
    }
    if (!nullToAbsent || hlrDifficulty != null) {
      map['hlr_difficulty'] = Variable<double>(hlrDifficulty);
    }
    map['hlr_correct_count'] = Variable<int>(hlrCorrectCount);
    map['hlr_incorrect_count'] = Variable<int>(hlrIncorrectCount);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['needs_sync'] = Variable<bool>(needsSync);
    return map;
  }

  SavedVersesCompanion toCompanion(bool nullToAbsent) {
    return SavedVersesCompanion(
      id: Value(id),
      book: Value(book),
      chapter: Value(chapter),
      verse: Value(verse),
      translation: Value(translation),
      nextReviewDate: Value(nextReviewDate),
      sm2EaseFactor: Value(sm2EaseFactor),
      sm2IntervalDays: Value(sm2IntervalDays),
      sm2RepetitionCount: Value(sm2RepetitionCount),
      hlrStability: hlrStability == null && nullToAbsent
          ? const Value.absent()
          : Value(hlrStability),
      hlrDifficulty: hlrDifficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(hlrDifficulty),
      hlrCorrectCount: Value(hlrCorrectCount),
      hlrIncorrectCount: Value(hlrIncorrectCount),
      updatedAt: Value(updatedAt),
      needsSync: Value(needsSync),
    );
  }

  factory SavedVerse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedVerse(
      id: serializer.fromJson<String>(json['id']),
      book: serializer.fromJson<int>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      translation: serializer.fromJson<String>(json['translation']),
      nextReviewDate: serializer.fromJson<DateTime>(json['nextReviewDate']),
      sm2EaseFactor: serializer.fromJson<double>(json['sm2EaseFactor']),
      sm2IntervalDays: serializer.fromJson<int>(json['sm2IntervalDays']),
      sm2RepetitionCount: serializer.fromJson<int>(json['sm2RepetitionCount']),
      hlrStability: serializer.fromJson<double?>(json['hlrStability']),
      hlrDifficulty: serializer.fromJson<double?>(json['hlrDifficulty']),
      hlrCorrectCount: serializer.fromJson<int>(json['hlrCorrectCount']),
      hlrIncorrectCount: serializer.fromJson<int>(json['hlrIncorrectCount']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'book': serializer.toJson<int>(book),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'translation': serializer.toJson<String>(translation),
      'nextReviewDate': serializer.toJson<DateTime>(nextReviewDate),
      'sm2EaseFactor': serializer.toJson<double>(sm2EaseFactor),
      'sm2IntervalDays': serializer.toJson<int>(sm2IntervalDays),
      'sm2RepetitionCount': serializer.toJson<int>(sm2RepetitionCount),
      'hlrStability': serializer.toJson<double?>(hlrStability),
      'hlrDifficulty': serializer.toJson<double?>(hlrDifficulty),
      'hlrCorrectCount': serializer.toJson<int>(hlrCorrectCount),
      'hlrIncorrectCount': serializer.toJson<int>(hlrIncorrectCount),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
    };
  }

  SavedVerse copyWith({
    String? id,
    int? book,
    int? chapter,
    int? verse,
    String? translation,
    DateTime? nextReviewDate,
    double? sm2EaseFactor,
    int? sm2IntervalDays,
    int? sm2RepetitionCount,
    Value<double?> hlrStability = const Value.absent(),
    Value<double?> hlrDifficulty = const Value.absent(),
    int? hlrCorrectCount,
    int? hlrIncorrectCount,
    DateTime? updatedAt,
    bool? needsSync,
  }) => SavedVerse(
    id: id ?? this.id,
    book: book ?? this.book,
    chapter: chapter ?? this.chapter,
    verse: verse ?? this.verse,
    translation: translation ?? this.translation,
    nextReviewDate: nextReviewDate ?? this.nextReviewDate,
    sm2EaseFactor: sm2EaseFactor ?? this.sm2EaseFactor,
    sm2IntervalDays: sm2IntervalDays ?? this.sm2IntervalDays,
    sm2RepetitionCount: sm2RepetitionCount ?? this.sm2RepetitionCount,
    hlrStability: hlrStability.present ? hlrStability.value : this.hlrStability,
    hlrDifficulty: hlrDifficulty.present
        ? hlrDifficulty.value
        : this.hlrDifficulty,
    hlrCorrectCount: hlrCorrectCount ?? this.hlrCorrectCount,
    hlrIncorrectCount: hlrIncorrectCount ?? this.hlrIncorrectCount,
    updatedAt: updatedAt ?? this.updatedAt,
    needsSync: needsSync ?? this.needsSync,
  );
  SavedVerse copyWithCompanion(SavedVersesCompanion data) {
    return SavedVerse(
      id: data.id.present ? data.id.value : this.id,
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      nextReviewDate: data.nextReviewDate.present
          ? data.nextReviewDate.value
          : this.nextReviewDate,
      sm2EaseFactor: data.sm2EaseFactor.present
          ? data.sm2EaseFactor.value
          : this.sm2EaseFactor,
      sm2IntervalDays: data.sm2IntervalDays.present
          ? data.sm2IntervalDays.value
          : this.sm2IntervalDays,
      sm2RepetitionCount: data.sm2RepetitionCount.present
          ? data.sm2RepetitionCount.value
          : this.sm2RepetitionCount,
      hlrStability: data.hlrStability.present
          ? data.hlrStability.value
          : this.hlrStability,
      hlrDifficulty: data.hlrDifficulty.present
          ? data.hlrDifficulty.value
          : this.hlrDifficulty,
      hlrCorrectCount: data.hlrCorrectCount.present
          ? data.hlrCorrectCount.value
          : this.hlrCorrectCount,
      hlrIncorrectCount: data.hlrIncorrectCount.present
          ? data.hlrIncorrectCount.value
          : this.hlrIncorrectCount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedVerse(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('translation: $translation, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('sm2EaseFactor: $sm2EaseFactor, ')
          ..write('sm2IntervalDays: $sm2IntervalDays, ')
          ..write('sm2RepetitionCount: $sm2RepetitionCount, ')
          ..write('hlrStability: $hlrStability, ')
          ..write('hlrDifficulty: $hlrDifficulty, ')
          ..write('hlrCorrectCount: $hlrCorrectCount, ')
          ..write('hlrIncorrectCount: $hlrIncorrectCount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('needsSync: $needsSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    book,
    chapter,
    verse,
    translation,
    nextReviewDate,
    sm2EaseFactor,
    sm2IntervalDays,
    sm2RepetitionCount,
    hlrStability,
    hlrDifficulty,
    hlrCorrectCount,
    hlrIncorrectCount,
    updatedAt,
    needsSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedVerse &&
          other.id == this.id &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.translation == this.translation &&
          other.nextReviewDate == this.nextReviewDate &&
          other.sm2EaseFactor == this.sm2EaseFactor &&
          other.sm2IntervalDays == this.sm2IntervalDays &&
          other.sm2RepetitionCount == this.sm2RepetitionCount &&
          other.hlrStability == this.hlrStability &&
          other.hlrDifficulty == this.hlrDifficulty &&
          other.hlrCorrectCount == this.hlrCorrectCount &&
          other.hlrIncorrectCount == this.hlrIncorrectCount &&
          other.updatedAt == this.updatedAt &&
          other.needsSync == this.needsSync);
}

class SavedVersesCompanion extends UpdateCompanion<SavedVerse> {
  final Value<String> id;
  final Value<int> book;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<String> translation;
  final Value<DateTime> nextReviewDate;
  final Value<double> sm2EaseFactor;
  final Value<int> sm2IntervalDays;
  final Value<int> sm2RepetitionCount;
  final Value<double?> hlrStability;
  final Value<double?> hlrDifficulty;
  final Value<int> hlrCorrectCount;
  final Value<int> hlrIncorrectCount;
  final Value<DateTime> updatedAt;
  final Value<bool> needsSync;
  final Value<int> rowid;
  const SavedVersesCompanion({
    this.id = const Value.absent(),
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.translation = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.sm2EaseFactor = const Value.absent(),
    this.sm2IntervalDays = const Value.absent(),
    this.sm2RepetitionCount = const Value.absent(),
    this.hlrStability = const Value.absent(),
    this.hlrDifficulty = const Value.absent(),
    this.hlrCorrectCount = const Value.absent(),
    this.hlrIncorrectCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedVersesCompanion.insert({
    required String id,
    required int book,
    required int chapter,
    required int verse,
    required String translation,
    required DateTime nextReviewDate,
    this.sm2EaseFactor = const Value.absent(),
    this.sm2IntervalDays = const Value.absent(),
    this.sm2RepetitionCount = const Value.absent(),
    this.hlrStability = const Value.absent(),
    this.hlrDifficulty = const Value.absent(),
    this.hlrCorrectCount = const Value.absent(),
    this.hlrIncorrectCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       book = Value(book),
       chapter = Value(chapter),
       verse = Value(verse),
       translation = Value(translation),
       nextReviewDate = Value(nextReviewDate);
  static Insertable<SavedVerse> custom({
    Expression<String>? id,
    Expression<int>? book,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<String>? translation,
    Expression<DateTime>? nextReviewDate,
    Expression<double>? sm2EaseFactor,
    Expression<int>? sm2IntervalDays,
    Expression<int>? sm2RepetitionCount,
    Expression<double>? hlrStability,
    Expression<double>? hlrDifficulty,
    Expression<int>? hlrCorrectCount,
    Expression<int>? hlrIncorrectCount,
    Expression<DateTime>? updatedAt,
    Expression<bool>? needsSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (translation != null) 'translation': translation,
      if (nextReviewDate != null) 'next_review_date': nextReviewDate,
      if (sm2EaseFactor != null) 'sm2_ease_factor': sm2EaseFactor,
      if (sm2IntervalDays != null) 'sm2_interval_days': sm2IntervalDays,
      if (sm2RepetitionCount != null)
        'sm2_repetition_count': sm2RepetitionCount,
      if (hlrStability != null) 'hlr_stability': hlrStability,
      if (hlrDifficulty != null) 'hlr_difficulty': hlrDifficulty,
      if (hlrCorrectCount != null) 'hlr_correct_count': hlrCorrectCount,
      if (hlrIncorrectCount != null) 'hlr_incorrect_count': hlrIncorrectCount,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedVersesCompanion copyWith({
    Value<String>? id,
    Value<int>? book,
    Value<int>? chapter,
    Value<int>? verse,
    Value<String>? translation,
    Value<DateTime>? nextReviewDate,
    Value<double>? sm2EaseFactor,
    Value<int>? sm2IntervalDays,
    Value<int>? sm2RepetitionCount,
    Value<double?>? hlrStability,
    Value<double?>? hlrDifficulty,
    Value<int>? hlrCorrectCount,
    Value<int>? hlrIncorrectCount,
    Value<DateTime>? updatedAt,
    Value<bool>? needsSync,
    Value<int>? rowid,
  }) {
    return SavedVersesCompanion(
      id: id ?? this.id,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      translation: translation ?? this.translation,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      sm2EaseFactor: sm2EaseFactor ?? this.sm2EaseFactor,
      sm2IntervalDays: sm2IntervalDays ?? this.sm2IntervalDays,
      sm2RepetitionCount: sm2RepetitionCount ?? this.sm2RepetitionCount,
      hlrStability: hlrStability ?? this.hlrStability,
      hlrDifficulty: hlrDifficulty ?? this.hlrDifficulty,
      hlrCorrectCount: hlrCorrectCount ?? this.hlrCorrectCount,
      hlrIncorrectCount: hlrIncorrectCount ?? this.hlrIncorrectCount,
      updatedAt: updatedAt ?? this.updatedAt,
      needsSync: needsSync ?? this.needsSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (book.present) {
      map['book'] = Variable<int>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (nextReviewDate.present) {
      map['next_review_date'] = Variable<DateTime>(nextReviewDate.value);
    }
    if (sm2EaseFactor.present) {
      map['sm2_ease_factor'] = Variable<double>(sm2EaseFactor.value);
    }
    if (sm2IntervalDays.present) {
      map['sm2_interval_days'] = Variable<int>(sm2IntervalDays.value);
    }
    if (sm2RepetitionCount.present) {
      map['sm2_repetition_count'] = Variable<int>(sm2RepetitionCount.value);
    }
    if (hlrStability.present) {
      map['hlr_stability'] = Variable<double>(hlrStability.value);
    }
    if (hlrDifficulty.present) {
      map['hlr_difficulty'] = Variable<double>(hlrDifficulty.value);
    }
    if (hlrCorrectCount.present) {
      map['hlr_correct_count'] = Variable<int>(hlrCorrectCount.value);
    }
    if (hlrIncorrectCount.present) {
      map['hlr_incorrect_count'] = Variable<int>(hlrIncorrectCount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedVersesCompanion(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('translation: $translation, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('sm2EaseFactor: $sm2EaseFactor, ')
          ..write('sm2IntervalDays: $sm2IntervalDays, ')
          ..write('sm2RepetitionCount: $sm2RepetitionCount, ')
          ..write('hlrStability: $hlrStability, ')
          ..write('hlrDifficulty: $hlrDifficulty, ')
          ..write('hlrCorrectCount: $hlrCorrectCount, ')
          ..write('hlrIncorrectCount: $hlrIncorrectCount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedVerseIdMeta = const VerificationMeta(
    'savedVerseId',
  );
  @override
  late final GeneratedColumn<String> savedVerseId = GeneratedColumn<String>(
    'saved_verse_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES saved_verses (id)',
    ),
  );
  static const VerificationMeta _rawScoreMeta = const VerificationMeta(
    'rawScore',
  );
  @override
  late final GeneratedColumn<double> rawScore = GeneratedColumn<double>(
    'raw_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GameType, String> gameType =
      GeneratedColumn<String>(
        'game_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GameType>($ExercisesTable.$convertergameType);
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _performedAtMeta = const VerificationMeta(
    'performedAt',
  );
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
    'performed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    savedVerseId,
    rawScore,
    gameType,
    durationMs,
    performedAt,
    needsSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('saved_verse_id')) {
      context.handle(
        _savedVerseIdMeta,
        savedVerseId.isAcceptableOrUnknown(
          data['saved_verse_id']!,
          _savedVerseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_savedVerseIdMeta);
    }
    if (data.containsKey('raw_score')) {
      context.handle(
        _rawScoreMeta,
        rawScore.isAcceptableOrUnknown(data['raw_score']!, _rawScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_rawScoreMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('performed_at')) {
      context.handle(
        _performedAtMeta,
        performedAt.isAcceptableOrUnknown(
          data['performed_at']!,
          _performedAtMeta,
        ),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      savedVerseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}saved_verse_id'],
      )!,
      rawScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}raw_score'],
      )!,
      gameType: $ExercisesTable.$convertergameType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}game_type'],
        )!,
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      performedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}performed_at'],
      )!,
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GameType, String, String> $convertergameType =
      const EnumNameConverter<GameType>(GameType.values);
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final String id;
  final String savedVerseId;
  final double rawScore;
  final GameType gameType;
  final int durationMs;
  final DateTime performedAt;
  final bool needsSync;
  const Exercise({
    required this.id,
    required this.savedVerseId,
    required this.rawScore,
    required this.gameType,
    required this.durationMs,
    required this.performedAt,
    required this.needsSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['saved_verse_id'] = Variable<String>(savedVerseId);
    map['raw_score'] = Variable<double>(rawScore);
    {
      map['game_type'] = Variable<String>(
        $ExercisesTable.$convertergameType.toSql(gameType),
      );
    }
    map['duration_ms'] = Variable<int>(durationMs);
    map['performed_at'] = Variable<DateTime>(performedAt);
    map['needs_sync'] = Variable<bool>(needsSync);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      savedVerseId: Value(savedVerseId),
      rawScore: Value(rawScore),
      gameType: Value(gameType),
      durationMs: Value(durationMs),
      performedAt: Value(performedAt),
      needsSync: Value(needsSync),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      savedVerseId: serializer.fromJson<String>(json['savedVerseId']),
      rawScore: serializer.fromJson<double>(json['rawScore']),
      gameType: $ExercisesTable.$convertergameType.fromJson(
        serializer.fromJson<String>(json['gameType']),
      ),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'savedVerseId': serializer.toJson<String>(savedVerseId),
      'rawScore': serializer.toJson<double>(rawScore),
      'gameType': serializer.toJson<String>(
        $ExercisesTable.$convertergameType.toJson(gameType),
      ),
      'durationMs': serializer.toJson<int>(durationMs),
      'performedAt': serializer.toJson<DateTime>(performedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
    };
  }

  Exercise copyWith({
    String? id,
    String? savedVerseId,
    double? rawScore,
    GameType? gameType,
    int? durationMs,
    DateTime? performedAt,
    bool? needsSync,
  }) => Exercise(
    id: id ?? this.id,
    savedVerseId: savedVerseId ?? this.savedVerseId,
    rawScore: rawScore ?? this.rawScore,
    gameType: gameType ?? this.gameType,
    durationMs: durationMs ?? this.durationMs,
    performedAt: performedAt ?? this.performedAt,
    needsSync: needsSync ?? this.needsSync,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      savedVerseId: data.savedVerseId.present
          ? data.savedVerseId.value
          : this.savedVerseId,
      rawScore: data.rawScore.present ? data.rawScore.value : this.rawScore,
      gameType: data.gameType.present ? data.gameType.value : this.gameType,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      performedAt: data.performedAt.present
          ? data.performedAt.value
          : this.performedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('savedVerseId: $savedVerseId, ')
          ..write('rawScore: $rawScore, ')
          ..write('gameType: $gameType, ')
          ..write('durationMs: $durationMs, ')
          ..write('performedAt: $performedAt, ')
          ..write('needsSync: $needsSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    savedVerseId,
    rawScore,
    gameType,
    durationMs,
    performedAt,
    needsSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.savedVerseId == this.savedVerseId &&
          other.rawScore == this.rawScore &&
          other.gameType == this.gameType &&
          other.durationMs == this.durationMs &&
          other.performedAt == this.performedAt &&
          other.needsSync == this.needsSync);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<String> savedVerseId;
  final Value<double> rawScore;
  final Value<GameType> gameType;
  final Value<int> durationMs;
  final Value<DateTime> performedAt;
  final Value<bool> needsSync;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.savedVerseId = const Value.absent(),
    this.rawScore = const Value.absent(),
    this.gameType = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String id,
    required String savedVerseId,
    required double rawScore,
    required GameType gameType,
    required int durationMs,
    this.performedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       savedVerseId = Value(savedVerseId),
       rawScore = Value(rawScore),
       gameType = Value(gameType),
       durationMs = Value(durationMs);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<String>? savedVerseId,
    Expression<double>? rawScore,
    Expression<String>? gameType,
    Expression<int>? durationMs,
    Expression<DateTime>? performedAt,
    Expression<bool>? needsSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (savedVerseId != null) 'saved_verse_id': savedVerseId,
      if (rawScore != null) 'raw_score': rawScore,
      if (gameType != null) 'game_type': gameType,
      if (durationMs != null) 'duration_ms': durationMs,
      if (performedAt != null) 'performed_at': performedAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? savedVerseId,
    Value<double>? rawScore,
    Value<GameType>? gameType,
    Value<int>? durationMs,
    Value<DateTime>? performedAt,
    Value<bool>? needsSync,
    Value<int>? rowid,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      savedVerseId: savedVerseId ?? this.savedVerseId,
      rawScore: rawScore ?? this.rawScore,
      gameType: gameType ?? this.gameType,
      durationMs: durationMs ?? this.durationMs,
      performedAt: performedAt ?? this.performedAt,
      needsSync: needsSync ?? this.needsSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (savedVerseId.present) {
      map['saved_verse_id'] = Variable<String>(savedVerseId.value);
    }
    if (rawScore.present) {
      map['raw_score'] = Variable<double>(rawScore.value);
    }
    if (gameType.present) {
      map['game_type'] = Variable<String>(
        $ExercisesTable.$convertergameType.toSql(gameType.value),
      );
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('savedVerseId: $savedVerseId, ')
          ..write('rawScore: $rawScore, ')
          ..write('gameType: $gameType, ')
          ..write('durationMs: $durationMs, ')
          ..write('performedAt: $performedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FriendshipsTable extends Friendships
    with TableInfo<$FriendshipsTable, Friendship> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FriendshipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _friendIdMeta = const VerificationMeta(
    'friendId',
  );
  @override
  late final GeneratedColumn<String> friendId = GeneratedColumn<String>(
    'friend_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _friendFirstNameMeta = const VerificationMeta(
    'friendFirstName',
  );
  @override
  late final GeneratedColumn<String> friendFirstName = GeneratedColumn<String>(
    'friend_first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _friendLastNameMeta = const VerificationMeta(
    'friendLastName',
  );
  @override
  late final GeneratedColumn<String> friendLastName = GeneratedColumn<String>(
    'friend_last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _friendScoreMeta = const VerificationMeta(
    'friendScore',
  );
  @override
  late final GeneratedColumn<int> friendScore = GeneratedColumn<int>(
    'friend_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<FriendshipStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FriendshipStatus>($FriendshipsTable.$converterstatus);
  static const VerificationMeta _isOutgoingMeta = const VerificationMeta(
    'isOutgoing',
  );
  @override
  late final GeneratedColumn<bool> isOutgoing = GeneratedColumn<bool>(
    'is_outgoing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_outgoing" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    friendId,
    friendFirstName,
    friendLastName,
    friendScore,
    status,
    isOutgoing,
    createdAt,
    updatedAt,
    needsSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'friendships';
  @override
  VerificationContext validateIntegrity(
    Insertable<Friendship> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('friend_id')) {
      context.handle(
        _friendIdMeta,
        friendId.isAcceptableOrUnknown(data['friend_id']!, _friendIdMeta),
      );
    } else if (isInserting) {
      context.missing(_friendIdMeta);
    }
    if (data.containsKey('friend_first_name')) {
      context.handle(
        _friendFirstNameMeta,
        friendFirstName.isAcceptableOrUnknown(
          data['friend_first_name']!,
          _friendFirstNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_friendFirstNameMeta);
    }
    if (data.containsKey('friend_last_name')) {
      context.handle(
        _friendLastNameMeta,
        friendLastName.isAcceptableOrUnknown(
          data['friend_last_name']!,
          _friendLastNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_friendLastNameMeta);
    }
    if (data.containsKey('friend_score')) {
      context.handle(
        _friendScoreMeta,
        friendScore.isAcceptableOrUnknown(
          data['friend_score']!,
          _friendScoreMeta,
        ),
      );
    }
    if (data.containsKey('is_outgoing')) {
      context.handle(
        _isOutgoingMeta,
        isOutgoing.isAcceptableOrUnknown(data['is_outgoing']!, _isOutgoingMeta),
      );
    } else if (isInserting) {
      context.missing(_isOutgoingMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Friendship map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Friendship(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      friendId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}friend_id'],
      )!,
      friendFirstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}friend_first_name'],
      )!,
      friendLastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}friend_last_name'],
      )!,
      friendScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}friend_score'],
      )!,
      status: $FriendshipsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      isOutgoing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_outgoing'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
    );
  }

  @override
  $FriendshipsTable createAlias(String alias) {
    return $FriendshipsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FriendshipStatus, String, String> $converterstatus =
      const EnumNameConverter<FriendshipStatus>(FriendshipStatus.values);
}

class Friendship extends DataClass implements Insertable<Friendship> {
  final String id;
  final String friendId;
  final String friendFirstName;
  final String friendLastName;
  final int friendScore;
  final FriendshipStatus status;
  final bool isOutgoing;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool needsSync;
  const Friendship({
    required this.id,
    required this.friendId,
    required this.friendFirstName,
    required this.friendLastName,
    required this.friendScore,
    required this.status,
    required this.isOutgoing,
    required this.createdAt,
    required this.updatedAt,
    required this.needsSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['friend_id'] = Variable<String>(friendId);
    map['friend_first_name'] = Variable<String>(friendFirstName);
    map['friend_last_name'] = Variable<String>(friendLastName);
    map['friend_score'] = Variable<int>(friendScore);
    {
      map['status'] = Variable<String>(
        $FriendshipsTable.$converterstatus.toSql(status),
      );
    }
    map['is_outgoing'] = Variable<bool>(isOutgoing);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['needs_sync'] = Variable<bool>(needsSync);
    return map;
  }

  FriendshipsCompanion toCompanion(bool nullToAbsent) {
    return FriendshipsCompanion(
      id: Value(id),
      friendId: Value(friendId),
      friendFirstName: Value(friendFirstName),
      friendLastName: Value(friendLastName),
      friendScore: Value(friendScore),
      status: Value(status),
      isOutgoing: Value(isOutgoing),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      needsSync: Value(needsSync),
    );
  }

  factory Friendship.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Friendship(
      id: serializer.fromJson<String>(json['id']),
      friendId: serializer.fromJson<String>(json['friendId']),
      friendFirstName: serializer.fromJson<String>(json['friendFirstName']),
      friendLastName: serializer.fromJson<String>(json['friendLastName']),
      friendScore: serializer.fromJson<int>(json['friendScore']),
      status: $FriendshipsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      isOutgoing: serializer.fromJson<bool>(json['isOutgoing']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'friendId': serializer.toJson<String>(friendId),
      'friendFirstName': serializer.toJson<String>(friendFirstName),
      'friendLastName': serializer.toJson<String>(friendLastName),
      'friendScore': serializer.toJson<int>(friendScore),
      'status': serializer.toJson<String>(
        $FriendshipsTable.$converterstatus.toJson(status),
      ),
      'isOutgoing': serializer.toJson<bool>(isOutgoing),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
    };
  }

  Friendship copyWith({
    String? id,
    String? friendId,
    String? friendFirstName,
    String? friendLastName,
    int? friendScore,
    FriendshipStatus? status,
    bool? isOutgoing,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? needsSync,
  }) => Friendship(
    id: id ?? this.id,
    friendId: friendId ?? this.friendId,
    friendFirstName: friendFirstName ?? this.friendFirstName,
    friendLastName: friendLastName ?? this.friendLastName,
    friendScore: friendScore ?? this.friendScore,
    status: status ?? this.status,
    isOutgoing: isOutgoing ?? this.isOutgoing,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    needsSync: needsSync ?? this.needsSync,
  );
  Friendship copyWithCompanion(FriendshipsCompanion data) {
    return Friendship(
      id: data.id.present ? data.id.value : this.id,
      friendId: data.friendId.present ? data.friendId.value : this.friendId,
      friendFirstName: data.friendFirstName.present
          ? data.friendFirstName.value
          : this.friendFirstName,
      friendLastName: data.friendLastName.present
          ? data.friendLastName.value
          : this.friendLastName,
      friendScore: data.friendScore.present
          ? data.friendScore.value
          : this.friendScore,
      status: data.status.present ? data.status.value : this.status,
      isOutgoing: data.isOutgoing.present
          ? data.isOutgoing.value
          : this.isOutgoing,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Friendship(')
          ..write('id: $id, ')
          ..write('friendId: $friendId, ')
          ..write('friendFirstName: $friendFirstName, ')
          ..write('friendLastName: $friendLastName, ')
          ..write('friendScore: $friendScore, ')
          ..write('status: $status, ')
          ..write('isOutgoing: $isOutgoing, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('needsSync: $needsSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    friendId,
    friendFirstName,
    friendLastName,
    friendScore,
    status,
    isOutgoing,
    createdAt,
    updatedAt,
    needsSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Friendship &&
          other.id == this.id &&
          other.friendId == this.friendId &&
          other.friendFirstName == this.friendFirstName &&
          other.friendLastName == this.friendLastName &&
          other.friendScore == this.friendScore &&
          other.status == this.status &&
          other.isOutgoing == this.isOutgoing &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.needsSync == this.needsSync);
}

class FriendshipsCompanion extends UpdateCompanion<Friendship> {
  final Value<String> id;
  final Value<String> friendId;
  final Value<String> friendFirstName;
  final Value<String> friendLastName;
  final Value<int> friendScore;
  final Value<FriendshipStatus> status;
  final Value<bool> isOutgoing;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> needsSync;
  final Value<int> rowid;
  const FriendshipsCompanion({
    this.id = const Value.absent(),
    this.friendId = const Value.absent(),
    this.friendFirstName = const Value.absent(),
    this.friendLastName = const Value.absent(),
    this.friendScore = const Value.absent(),
    this.status = const Value.absent(),
    this.isOutgoing = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FriendshipsCompanion.insert({
    required String id,
    required String friendId,
    required String friendFirstName,
    required String friendLastName,
    this.friendScore = const Value.absent(),
    required FriendshipStatus status,
    required bool isOutgoing,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       friendId = Value(friendId),
       friendFirstName = Value(friendFirstName),
       friendLastName = Value(friendLastName),
       status = Value(status),
       isOutgoing = Value(isOutgoing),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Friendship> custom({
    Expression<String>? id,
    Expression<String>? friendId,
    Expression<String>? friendFirstName,
    Expression<String>? friendLastName,
    Expression<int>? friendScore,
    Expression<String>? status,
    Expression<bool>? isOutgoing,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? needsSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (friendId != null) 'friend_id': friendId,
      if (friendFirstName != null) 'friend_first_name': friendFirstName,
      if (friendLastName != null) 'friend_last_name': friendLastName,
      if (friendScore != null) 'friend_score': friendScore,
      if (status != null) 'status': status,
      if (isOutgoing != null) 'is_outgoing': isOutgoing,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FriendshipsCompanion copyWith({
    Value<String>? id,
    Value<String>? friendId,
    Value<String>? friendFirstName,
    Value<String>? friendLastName,
    Value<int>? friendScore,
    Value<FriendshipStatus>? status,
    Value<bool>? isOutgoing,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? needsSync,
    Value<int>? rowid,
  }) {
    return FriendshipsCompanion(
      id: id ?? this.id,
      friendId: friendId ?? this.friendId,
      friendFirstName: friendFirstName ?? this.friendFirstName,
      friendLastName: friendLastName ?? this.friendLastName,
      friendScore: friendScore ?? this.friendScore,
      status: status ?? this.status,
      isOutgoing: isOutgoing ?? this.isOutgoing,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      needsSync: needsSync ?? this.needsSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (friendId.present) {
      map['friend_id'] = Variable<String>(friendId.value);
    }
    if (friendFirstName.present) {
      map['friend_first_name'] = Variable<String>(friendFirstName.value);
    }
    if (friendLastName.present) {
      map['friend_last_name'] = Variable<String>(friendLastName.value);
    }
    if (friendScore.present) {
      map['friend_score'] = Variable<int>(friendScore.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $FriendshipsTable.$converterstatus.toSql(status.value),
      );
    }
    if (isOutgoing.present) {
      map['is_outgoing'] = Variable<bool>(isOutgoing.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FriendshipsCompanion(')
          ..write('id: $id, ')
          ..write('friendId: $friendId, ')
          ..write('friendFirstName: $friendFirstName, ')
          ..write('friendLastName: $friendLastName, ')
          ..write('friendScore: $friendScore, ')
          ..write('status: $status, ')
          ..write('isOutgoing: $isOutgoing, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _friendCodeMeta = const VerificationMeta(
    'friendCode',
  );
  @override
  late final GeneratedColumn<String> friendCode = GeneratedColumn<String>(
    'friend_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetRetentionMeta = const VerificationMeta(
    'targetRetention',
  );
  @override
  late final GeneratedColumn<double> targetRetention = GeneratedColumn<double>(
    'target_retention',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.9),
  );
  static const VerificationMeta _userMemoryFactorMeta = const VerificationMeta(
    'userMemoryFactor',
  );
  @override
  late final GeneratedColumn<double> userMemoryFactor = GeneratedColumn<double>(
    'user_memory_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastName,
    email,
    friendCode,
    score,
    targetRetention,
    userMemoryFactor,
    language,
    updatedAt,
    needsSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('friend_code')) {
      context.handle(
        _friendCodeMeta,
        friendCode.isAcceptableOrUnknown(data['friend_code']!, _friendCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_friendCodeMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('target_retention')) {
      context.handle(
        _targetRetentionMeta,
        targetRetention.isAcceptableOrUnknown(
          data['target_retention']!,
          _targetRetentionMeta,
        ),
      );
    }
    if (data.containsKey('user_memory_factor')) {
      context.handle(
        _userMemoryFactorMeta,
        userMemoryFactor.isAcceptableOrUnknown(
          data['user_memory_factor']!,
          _userMemoryFactorMeta,
        ),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      friendCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}friend_code'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      targetRetention: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_retention'],
      )!,
      userMemoryFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}user_memory_factor'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String friendCode;
  final int score;
  final double targetRetention;
  final double userMemoryFactor;
  final String language;
  final DateTime updatedAt;
  final bool needsSync;
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.friendCode,
    required this.score,
    required this.targetRetention,
    required this.userMemoryFactor,
    required this.language,
    required this.updatedAt,
    required this.needsSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['email'] = Variable<String>(email);
    map['friend_code'] = Variable<String>(friendCode);
    map['score'] = Variable<int>(score);
    map['target_retention'] = Variable<double>(targetRetention);
    map['user_memory_factor'] = Variable<double>(userMemoryFactor);
    map['language'] = Variable<String>(language);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['needs_sync'] = Variable<bool>(needsSync);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      email: Value(email),
      friendCode: Value(friendCode),
      score: Value(score),
      targetRetention: Value(targetRetention),
      userMemoryFactor: Value(userMemoryFactor),
      language: Value(language),
      updatedAt: Value(updatedAt),
      needsSync: Value(needsSync),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String>(json['email']),
      friendCode: serializer.fromJson<String>(json['friendCode']),
      score: serializer.fromJson<int>(json['score']),
      targetRetention: serializer.fromJson<double>(json['targetRetention']),
      userMemoryFactor: serializer.fromJson<double>(json['userMemoryFactor']),
      language: serializer.fromJson<String>(json['language']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String>(email),
      'friendCode': serializer.toJson<String>(friendCode),
      'score': serializer.toJson<int>(score),
      'targetRetention': serializer.toJson<double>(targetRetention),
      'userMemoryFactor': serializer.toJson<double>(userMemoryFactor),
      'language': serializer.toJson<String>(language),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
    };
  }

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? friendCode,
    int? score,
    double? targetRetention,
    double? userMemoryFactor,
    String? language,
    DateTime? updatedAt,
    bool? needsSync,
  }) => User(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    friendCode: friendCode ?? this.friendCode,
    score: score ?? this.score,
    targetRetention: targetRetention ?? this.targetRetention,
    userMemoryFactor: userMemoryFactor ?? this.userMemoryFactor,
    language: language ?? this.language,
    updatedAt: updatedAt ?? this.updatedAt,
    needsSync: needsSync ?? this.needsSync,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      friendCode: data.friendCode.present
          ? data.friendCode.value
          : this.friendCode,
      score: data.score.present ? data.score.value : this.score,
      targetRetention: data.targetRetention.present
          ? data.targetRetention.value
          : this.targetRetention,
      userMemoryFactor: data.userMemoryFactor.present
          ? data.userMemoryFactor.value
          : this.userMemoryFactor,
      language: data.language.present ? data.language.value : this.language,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('friendCode: $friendCode, ')
          ..write('score: $score, ')
          ..write('targetRetention: $targetRetention, ')
          ..write('userMemoryFactor: $userMemoryFactor, ')
          ..write('language: $language, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('needsSync: $needsSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    firstName,
    lastName,
    email,
    friendCode,
    score,
    targetRetention,
    userMemoryFactor,
    language,
    updatedAt,
    needsSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.friendCode == this.friendCode &&
          other.score == this.score &&
          other.targetRetention == this.targetRetention &&
          other.userMemoryFactor == this.userMemoryFactor &&
          other.language == this.language &&
          other.updatedAt == this.updatedAt &&
          other.needsSync == this.needsSync);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> email;
  final Value<String> friendCode;
  final Value<int> score;
  final Value<double> targetRetention;
  final Value<double> userMemoryFactor;
  final Value<String> language;
  final Value<DateTime> updatedAt;
  final Value<bool> needsSync;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.friendCode = const Value.absent(),
    this.score = const Value.absent(),
    this.targetRetention = const Value.absent(),
    this.userMemoryFactor = const Value.absent(),
    this.language = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String friendCode,
    this.score = const Value.absent(),
    this.targetRetention = const Value.absent(),
    this.userMemoryFactor = const Value.absent(),
    this.language = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       firstName = Value(firstName),
       lastName = Value(lastName),
       email = Value(email),
       friendCode = Value(friendCode);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? friendCode,
    Expression<int>? score,
    Expression<double>? targetRetention,
    Expression<double>? userMemoryFactor,
    Expression<String>? language,
    Expression<DateTime>? updatedAt,
    Expression<bool>? needsSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (friendCode != null) 'friend_code': friendCode,
      if (score != null) 'score': score,
      if (targetRetention != null) 'target_retention': targetRetention,
      if (userMemoryFactor != null) 'user_memory_factor': userMemoryFactor,
      if (language != null) 'language': language,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? email,
    Value<String>? friendCode,
    Value<int>? score,
    Value<double>? targetRetention,
    Value<double>? userMemoryFactor,
    Value<String>? language,
    Value<DateTime>? updatedAt,
    Value<bool>? needsSync,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      friendCode: friendCode ?? this.friendCode,
      score: score ?? this.score,
      targetRetention: targetRetention ?? this.targetRetention,
      userMemoryFactor: userMemoryFactor ?? this.userMemoryFactor,
      language: language ?? this.language,
      updatedAt: updatedAt ?? this.updatedAt,
      needsSync: needsSync ?? this.needsSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (friendCode.present) {
      map['friend_code'] = Variable<String>(friendCode.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (targetRetention.present) {
      map['target_retention'] = Variable<double>(targetRetention.value);
    }
    if (userMemoryFactor.present) {
      map['user_memory_factor'] = Variable<double>(userMemoryFactor.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('friendCode: $friendCode, ')
          ..write('score: $score, ')
          ..write('targetRetention: $targetRetention, ')
          ..write('userMemoryFactor: $userMemoryFactor, ')
          ..write('language: $language, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeletedItemsTable extends DeletedItems
    with TableInfo<$DeletedItemsTable, DeletedItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeletedItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DeleteResourceType, String>
  resourceType =
      GeneratedColumn<String>(
        'resource_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DeleteResourceType>(
        $DeletedItemsTable.$converterresourceType,
      );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, resourceType, needsSync];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deleted_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeletedItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  DeletedItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeletedItem(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      resourceType: $DeletedItemsTable.$converterresourceType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}resource_type'],
        )!,
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
    );
  }

  @override
  $DeletedItemsTable createAlias(String alias) {
    return $DeletedItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DeleteResourceType, String, String>
  $converterresourceType = const EnumNameConverter<DeleteResourceType>(
    DeleteResourceType.values,
  );
}

class DeletedItem extends DataClass implements Insertable<DeletedItem> {
  final String itemId;
  final DeleteResourceType resourceType;
  final bool needsSync;
  const DeletedItem({
    required this.itemId,
    required this.resourceType,
    required this.needsSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    {
      map['resource_type'] = Variable<String>(
        $DeletedItemsTable.$converterresourceType.toSql(resourceType),
      );
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    return map;
  }

  DeletedItemsCompanion toCompanion(bool nullToAbsent) {
    return DeletedItemsCompanion(
      itemId: Value(itemId),
      resourceType: Value(resourceType),
      needsSync: Value(needsSync),
    );
  }

  factory DeletedItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeletedItem(
      itemId: serializer.fromJson<String>(json['itemId']),
      resourceType: $DeletedItemsTable.$converterresourceType.fromJson(
        serializer.fromJson<String>(json['resourceType']),
      ),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'resourceType': serializer.toJson<String>(
        $DeletedItemsTable.$converterresourceType.toJson(resourceType),
      ),
      'needsSync': serializer.toJson<bool>(needsSync),
    };
  }

  DeletedItem copyWith({
    String? itemId,
    DeleteResourceType? resourceType,
    bool? needsSync,
  }) => DeletedItem(
    itemId: itemId ?? this.itemId,
    resourceType: resourceType ?? this.resourceType,
    needsSync: needsSync ?? this.needsSync,
  );
  DeletedItem copyWithCompanion(DeletedItemsCompanion data) {
    return DeletedItem(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      resourceType: data.resourceType.present
          ? data.resourceType.value
          : this.resourceType,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeletedItem(')
          ..write('itemId: $itemId, ')
          ..write('resourceType: $resourceType, ')
          ..write('needsSync: $needsSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, resourceType, needsSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeletedItem &&
          other.itemId == this.itemId &&
          other.resourceType == this.resourceType &&
          other.needsSync == this.needsSync);
}

class DeletedItemsCompanion extends UpdateCompanion<DeletedItem> {
  final Value<String> itemId;
  final Value<DeleteResourceType> resourceType;
  final Value<bool> needsSync;
  final Value<int> rowid;
  const DeletedItemsCompanion({
    this.itemId = const Value.absent(),
    this.resourceType = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeletedItemsCompanion.insert({
    required String itemId,
    required DeleteResourceType resourceType,
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       resourceType = Value(resourceType);
  static Insertable<DeletedItem> custom({
    Expression<String>? itemId,
    Expression<String>? resourceType,
    Expression<bool>? needsSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (resourceType != null) 'resource_type': resourceType,
      if (needsSync != null) 'needs_sync': needsSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeletedItemsCompanion copyWith({
    Value<String>? itemId,
    Value<DeleteResourceType>? resourceType,
    Value<bool>? needsSync,
    Value<int>? rowid,
  }) {
    return DeletedItemsCompanion(
      itemId: itemId ?? this.itemId,
      resourceType: resourceType ?? this.resourceType,
      needsSync: needsSync ?? this.needsSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (resourceType.present) {
      map['resource_type'] = Variable<String>(
        $DeletedItemsTable.$converterresourceType.toSql(resourceType.value),
      );
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeletedItemsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('resourceType: $resourceType, ')
          ..write('needsSync: $needsSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BibleBooksTable extends BibleBooks
    with TableInfo<$BibleBooksTable, BibleBook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BibleBooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, translation];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bible_books';
  @override
  VerificationContext validateIntegrity(
    Insertable<BibleBook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, translation};
  @override
  BibleBook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BibleBook(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      )!,
    );
  }

  @override
  $BibleBooksTable createAlias(String alias) {
    return $BibleBooksTable(attachedDatabase, alias);
  }
}

class BibleBook extends DataClass implements Insertable<BibleBook> {
  final int id;
  final String name;
  final String translation;
  const BibleBook({
    required this.id,
    required this.name,
    required this.translation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['translation'] = Variable<String>(translation);
    return map;
  }

  BibleBooksCompanion toCompanion(bool nullToAbsent) {
    return BibleBooksCompanion(
      id: Value(id),
      name: Value(name),
      translation: Value(translation),
    );
  }

  factory BibleBook.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BibleBook(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      translation: serializer.fromJson<String>(json['translation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'translation': serializer.toJson<String>(translation),
    };
  }

  BibleBook copyWith({int? id, String? name, String? translation}) => BibleBook(
    id: id ?? this.id,
    name: name ?? this.name,
    translation: translation ?? this.translation,
  );
  BibleBook copyWithCompanion(BibleBooksCompanion data) {
    return BibleBook(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BibleBook(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('translation: $translation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, translation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BibleBook &&
          other.id == this.id &&
          other.name == this.name &&
          other.translation == this.translation);
}

class BibleBooksCompanion extends UpdateCompanion<BibleBook> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> translation;
  final Value<int> rowid;
  const BibleBooksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.translation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BibleBooksCompanion.insert({
    required int id,
    required String name,
    required String translation,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       translation = Value(translation);
  static Insertable<BibleBook> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? translation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (translation != null) 'translation': translation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BibleBooksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? translation,
    Value<int>? rowid,
  }) {
    return BibleBooksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      translation: translation ?? this.translation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BibleBooksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('translation: $translation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalBibleVersesTable localBibleVerses = $LocalBibleVersesTable(
    this,
  );
  late final $SavedVersesTable savedVerses = $SavedVersesTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $FriendshipsTable friendships = $FriendshipsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $DeletedItemsTable deletedItems = $DeletedItemsTable(this);
  late final $BibleBooksTable bibleBooks = $BibleBooksTable(this);
  late final BibleDao bibleDao = BibleDao(this as AppDatabase);
  late final SavedVersesDao savedVersesDao = SavedVersesDao(
    this as AppDatabase,
  );
  late final FriendshipsDao friendshipsDao = FriendshipsDao(
    this as AppDatabase,
  );
  late final ExercisesDao exercisesDao = ExercisesDao(this as AppDatabase);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localBibleVerses,
    savedVerses,
    exercises,
    friendships,
    users,
    deletedItems,
    bibleBooks,
  ];
}

typedef $$LocalBibleVersesTableCreateCompanionBuilder =
    LocalBibleVersesCompanion Function({
      Value<int> id,
      required int book,
      required int chapter,
      required int verse,
      required String textContent,
      required String translation,
      required int wordCount,
    });
typedef $$LocalBibleVersesTableUpdateCompanionBuilder =
    LocalBibleVersesCompanion Function({
      Value<int> id,
      Value<int> book,
      Value<int> chapter,
      Value<int> verse,
      Value<String> textContent,
      Value<String> translation,
      Value<int> wordCount,
    });

class $$LocalBibleVersesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalBibleVersesTable> {
  $$LocalBibleVersesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalBibleVersesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalBibleVersesTable> {
  $$LocalBibleVersesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalBibleVersesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalBibleVersesTable> {
  $$LocalBibleVersesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);
}

class $$LocalBibleVersesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalBibleVersesTable,
          LocalBibleVerse,
          $$LocalBibleVersesTableFilterComposer,
          $$LocalBibleVersesTableOrderingComposer,
          $$LocalBibleVersesTableAnnotationComposer,
          $$LocalBibleVersesTableCreateCompanionBuilder,
          $$LocalBibleVersesTableUpdateCompanionBuilder,
          (
            LocalBibleVerse,
            BaseReferences<
              _$AppDatabase,
              $LocalBibleVersesTable,
              LocalBibleVerse
            >,
          ),
          LocalBibleVerse,
          PrefetchHooks Function()
        > {
  $$LocalBibleVersesTableTableManager(
    _$AppDatabase db,
    $LocalBibleVersesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalBibleVersesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalBibleVersesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalBibleVersesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> book = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verse = const Value.absent(),
                Value<String> textContent = const Value.absent(),
                Value<String> translation = const Value.absent(),
                Value<int> wordCount = const Value.absent(),
              }) => LocalBibleVersesCompanion(
                id: id,
                book: book,
                chapter: chapter,
                verse: verse,
                textContent: textContent,
                translation: translation,
                wordCount: wordCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int book,
                required int chapter,
                required int verse,
                required String textContent,
                required String translation,
                required int wordCount,
              }) => LocalBibleVersesCompanion.insert(
                id: id,
                book: book,
                chapter: chapter,
                verse: verse,
                textContent: textContent,
                translation: translation,
                wordCount: wordCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalBibleVersesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalBibleVersesTable,
      LocalBibleVerse,
      $$LocalBibleVersesTableFilterComposer,
      $$LocalBibleVersesTableOrderingComposer,
      $$LocalBibleVersesTableAnnotationComposer,
      $$LocalBibleVersesTableCreateCompanionBuilder,
      $$LocalBibleVersesTableUpdateCompanionBuilder,
      (
        LocalBibleVerse,
        BaseReferences<_$AppDatabase, $LocalBibleVersesTable, LocalBibleVerse>,
      ),
      LocalBibleVerse,
      PrefetchHooks Function()
    >;
typedef $$SavedVersesTableCreateCompanionBuilder =
    SavedVersesCompanion Function({
      required String id,
      required int book,
      required int chapter,
      required int verse,
      required String translation,
      required DateTime nextReviewDate,
      Value<double> sm2EaseFactor,
      Value<int> sm2IntervalDays,
      Value<int> sm2RepetitionCount,
      Value<double?> hlrStability,
      Value<double?> hlrDifficulty,
      Value<int> hlrCorrectCount,
      Value<int> hlrIncorrectCount,
      Value<DateTime> updatedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });
typedef $$SavedVersesTableUpdateCompanionBuilder =
    SavedVersesCompanion Function({
      Value<String> id,
      Value<int> book,
      Value<int> chapter,
      Value<int> verse,
      Value<String> translation,
      Value<DateTime> nextReviewDate,
      Value<double> sm2EaseFactor,
      Value<int> sm2IntervalDays,
      Value<int> sm2RepetitionCount,
      Value<double?> hlrStability,
      Value<double?> hlrDifficulty,
      Value<int> hlrCorrectCount,
      Value<int> hlrIncorrectCount,
      Value<DateTime> updatedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });

final class $$SavedVersesTableReferences
    extends BaseReferences<_$AppDatabase, $SavedVersesTable, SavedVerse> {
  $$SavedVersesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExercisesTable, List<Exercise>>
  _exercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exercises,
    aliasName: $_aliasNameGenerator(
      db.savedVerses.id,
      db.exercises.savedVerseId,
    ),
  );

  $$ExercisesTableProcessedTableManager get exercisesRefs {
    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.savedVerseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_exercisesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SavedVersesTableFilterComposer
    extends Composer<_$AppDatabase, $SavedVersesTable> {
  $$SavedVersesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sm2EaseFactor => $composableBuilder(
    column: $table.sm2EaseFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sm2IntervalDays => $composableBuilder(
    column: $table.sm2IntervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sm2RepetitionCount => $composableBuilder(
    column: $table.sm2RepetitionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hlrStability => $composableBuilder(
    column: $table.hlrStability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hlrDifficulty => $composableBuilder(
    column: $table.hlrDifficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hlrCorrectCount => $composableBuilder(
    column: $table.hlrCorrectCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hlrIncorrectCount => $composableBuilder(
    column: $table.hlrIncorrectCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> exercisesRefs(
    Expression<bool> Function($$ExercisesTableFilterComposer f) f,
  ) {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.savedVerseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SavedVersesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedVersesTable> {
  $$SavedVersesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sm2EaseFactor => $composableBuilder(
    column: $table.sm2EaseFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sm2IntervalDays => $composableBuilder(
    column: $table.sm2IntervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sm2RepetitionCount => $composableBuilder(
    column: $table.sm2RepetitionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hlrStability => $composableBuilder(
    column: $table.hlrStability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hlrDifficulty => $composableBuilder(
    column: $table.hlrDifficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hlrCorrectCount => $composableBuilder(
    column: $table.hlrCorrectCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hlrIncorrectCount => $composableBuilder(
    column: $table.hlrIncorrectCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedVersesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedVersesTable> {
  $$SavedVersesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sm2EaseFactor => $composableBuilder(
    column: $table.sm2EaseFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sm2IntervalDays => $composableBuilder(
    column: $table.sm2IntervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sm2RepetitionCount => $composableBuilder(
    column: $table.sm2RepetitionCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hlrStability => $composableBuilder(
    column: $table.hlrStability,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hlrDifficulty => $composableBuilder(
    column: $table.hlrDifficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hlrCorrectCount => $composableBuilder(
    column: $table.hlrCorrectCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hlrIncorrectCount => $composableBuilder(
    column: $table.hlrIncorrectCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  Expression<T> exercisesRefs<T extends Object>(
    Expression<T> Function($$ExercisesTableAnnotationComposer a) f,
  ) {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.savedVerseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SavedVersesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedVersesTable,
          SavedVerse,
          $$SavedVersesTableFilterComposer,
          $$SavedVersesTableOrderingComposer,
          $$SavedVersesTableAnnotationComposer,
          $$SavedVersesTableCreateCompanionBuilder,
          $$SavedVersesTableUpdateCompanionBuilder,
          (SavedVerse, $$SavedVersesTableReferences),
          SavedVerse,
          PrefetchHooks Function({bool exercisesRefs})
        > {
  $$SavedVersesTableTableManager(_$AppDatabase db, $SavedVersesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedVersesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedVersesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedVersesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> book = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verse = const Value.absent(),
                Value<String> translation = const Value.absent(),
                Value<DateTime> nextReviewDate = const Value.absent(),
                Value<double> sm2EaseFactor = const Value.absent(),
                Value<int> sm2IntervalDays = const Value.absent(),
                Value<int> sm2RepetitionCount = const Value.absent(),
                Value<double?> hlrStability = const Value.absent(),
                Value<double?> hlrDifficulty = const Value.absent(),
                Value<int> hlrCorrectCount = const Value.absent(),
                Value<int> hlrIncorrectCount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedVersesCompanion(
                id: id,
                book: book,
                chapter: chapter,
                verse: verse,
                translation: translation,
                nextReviewDate: nextReviewDate,
                sm2EaseFactor: sm2EaseFactor,
                sm2IntervalDays: sm2IntervalDays,
                sm2RepetitionCount: sm2RepetitionCount,
                hlrStability: hlrStability,
                hlrDifficulty: hlrDifficulty,
                hlrCorrectCount: hlrCorrectCount,
                hlrIncorrectCount: hlrIncorrectCount,
                updatedAt: updatedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int book,
                required int chapter,
                required int verse,
                required String translation,
                required DateTime nextReviewDate,
                Value<double> sm2EaseFactor = const Value.absent(),
                Value<int> sm2IntervalDays = const Value.absent(),
                Value<int> sm2RepetitionCount = const Value.absent(),
                Value<double?> hlrStability = const Value.absent(),
                Value<double?> hlrDifficulty = const Value.absent(),
                Value<int> hlrCorrectCount = const Value.absent(),
                Value<int> hlrIncorrectCount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedVersesCompanion.insert(
                id: id,
                book: book,
                chapter: chapter,
                verse: verse,
                translation: translation,
                nextReviewDate: nextReviewDate,
                sm2EaseFactor: sm2EaseFactor,
                sm2IntervalDays: sm2IntervalDays,
                sm2RepetitionCount: sm2RepetitionCount,
                hlrStability: hlrStability,
                hlrDifficulty: hlrDifficulty,
                hlrCorrectCount: hlrCorrectCount,
                hlrIncorrectCount: hlrIncorrectCount,
                updatedAt: updatedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SavedVersesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (exercisesRefs) db.exercises],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exercisesRefs)
                    await $_getPrefetchedData<
                      SavedVerse,
                      $SavedVersesTable,
                      Exercise
                    >(
                      currentTable: table,
                      referencedTable: $$SavedVersesTableReferences
                          ._exercisesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SavedVersesTableReferences(
                            db,
                            table,
                            p0,
                          ).exercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.savedVerseId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SavedVersesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedVersesTable,
      SavedVerse,
      $$SavedVersesTableFilterComposer,
      $$SavedVersesTableOrderingComposer,
      $$SavedVersesTableAnnotationComposer,
      $$SavedVersesTableCreateCompanionBuilder,
      $$SavedVersesTableUpdateCompanionBuilder,
      (SavedVerse, $$SavedVersesTableReferences),
      SavedVerse,
      PrefetchHooks Function({bool exercisesRefs})
    >;
typedef $$ExercisesTableCreateCompanionBuilder =
    ExercisesCompanion Function({
      required String id,
      required String savedVerseId,
      required double rawScore,
      required GameType gameType,
      required int durationMs,
      Value<DateTime> performedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });
typedef $$ExercisesTableUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<String> id,
      Value<String> savedVerseId,
      Value<double> rawScore,
      Value<GameType> gameType,
      Value<int> durationMs,
      Value<DateTime> performedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SavedVersesTable _savedVerseIdTable(_$AppDatabase db) =>
      db.savedVerses.createAlias(
        $_aliasNameGenerator(db.exercises.savedVerseId, db.savedVerses.id),
      );

  $$SavedVersesTableProcessedTableManager get savedVerseId {
    final $_column = $_itemColumn<String>('saved_verse_id')!;

    final manager = $$SavedVersesTableTableManager(
      $_db,
      $_db.savedVerses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_savedVerseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rawScore => $composableBuilder(
    column: $table.rawScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GameType, GameType, String> get gameType =>
      $composableBuilder(
        column: $table.gameType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  $$SavedVersesTableFilterComposer get savedVerseId {
    final $$SavedVersesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.savedVerseId,
      referencedTable: $db.savedVerses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedVersesTableFilterComposer(
            $db: $db,
            $table: $db.savedVerses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rawScore => $composableBuilder(
    column: $table.rawScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameType => $composableBuilder(
    column: $table.gameType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  $$SavedVersesTableOrderingComposer get savedVerseId {
    final $$SavedVersesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.savedVerseId,
      referencedTable: $db.savedVerses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedVersesTableOrderingComposer(
            $db: $db,
            $table: $db.savedVerses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get rawScore =>
      $composableBuilder(column: $table.rawScore, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GameType, String> get gameType =>
      $composableBuilder(column: $table.gameType, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  $$SavedVersesTableAnnotationComposer get savedVerseId {
    final $$SavedVersesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.savedVerseId,
      referencedTable: $db.savedVerses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedVersesTableAnnotationComposer(
            $db: $db,
            $table: $db.savedVerses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({bool savedVerseId})
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> savedVerseId = const Value.absent(),
                Value<double> rawScore = const Value.absent(),
                Value<GameType> gameType = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<DateTime> performedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                savedVerseId: savedVerseId,
                rawScore: rawScore,
                gameType: gameType,
                durationMs: durationMs,
                performedAt: performedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String savedVerseId,
                required double rawScore,
                required GameType gameType,
                required int durationMs,
                Value<DateTime> performedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                savedVerseId: savedVerseId,
                rawScore: rawScore,
                gameType: gameType,
                durationMs: durationMs,
                performedAt: performedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({savedVerseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (savedVerseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.savedVerseId,
                                referencedTable: $$ExercisesTableReferences
                                    ._savedVerseIdTable(db),
                                referencedColumn: $$ExercisesTableReferences
                                    ._savedVerseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({bool savedVerseId})
    >;
typedef $$FriendshipsTableCreateCompanionBuilder =
    FriendshipsCompanion Function({
      required String id,
      required String friendId,
      required String friendFirstName,
      required String friendLastName,
      Value<int> friendScore,
      required FriendshipStatus status,
      required bool isOutgoing,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });
typedef $$FriendshipsTableUpdateCompanionBuilder =
    FriendshipsCompanion Function({
      Value<String> id,
      Value<String> friendId,
      Value<String> friendFirstName,
      Value<String> friendLastName,
      Value<int> friendScore,
      Value<FriendshipStatus> status,
      Value<bool> isOutgoing,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });

class $$FriendshipsTableFilterComposer
    extends Composer<_$AppDatabase, $FriendshipsTable> {
  $$FriendshipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get friendId => $composableBuilder(
    column: $table.friendId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get friendFirstName => $composableBuilder(
    column: $table.friendFirstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get friendLastName => $composableBuilder(
    column: $table.friendLastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get friendScore => $composableBuilder(
    column: $table.friendScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FriendshipStatus, FriendshipStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isOutgoing => $composableBuilder(
    column: $table.isOutgoing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FriendshipsTableOrderingComposer
    extends Composer<_$AppDatabase, $FriendshipsTable> {
  $$FriendshipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get friendId => $composableBuilder(
    column: $table.friendId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get friendFirstName => $composableBuilder(
    column: $table.friendFirstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get friendLastName => $composableBuilder(
    column: $table.friendLastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get friendScore => $composableBuilder(
    column: $table.friendScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOutgoing => $composableBuilder(
    column: $table.isOutgoing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FriendshipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FriendshipsTable> {
  $$FriendshipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get friendId =>
      $composableBuilder(column: $table.friendId, builder: (column) => column);

  GeneratedColumn<String> get friendFirstName => $composableBuilder(
    column: $table.friendFirstName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get friendLastName => $composableBuilder(
    column: $table.friendLastName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get friendScore => $composableBuilder(
    column: $table.friendScore,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FriendshipStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isOutgoing => $composableBuilder(
    column: $table.isOutgoing,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);
}

class $$FriendshipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FriendshipsTable,
          Friendship,
          $$FriendshipsTableFilterComposer,
          $$FriendshipsTableOrderingComposer,
          $$FriendshipsTableAnnotationComposer,
          $$FriendshipsTableCreateCompanionBuilder,
          $$FriendshipsTableUpdateCompanionBuilder,
          (
            Friendship,
            BaseReferences<_$AppDatabase, $FriendshipsTable, Friendship>,
          ),
          Friendship,
          PrefetchHooks Function()
        > {
  $$FriendshipsTableTableManager(_$AppDatabase db, $FriendshipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FriendshipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FriendshipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FriendshipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> friendId = const Value.absent(),
                Value<String> friendFirstName = const Value.absent(),
                Value<String> friendLastName = const Value.absent(),
                Value<int> friendScore = const Value.absent(),
                Value<FriendshipStatus> status = const Value.absent(),
                Value<bool> isOutgoing = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FriendshipsCompanion(
                id: id,
                friendId: friendId,
                friendFirstName: friendFirstName,
                friendLastName: friendLastName,
                friendScore: friendScore,
                status: status,
                isOutgoing: isOutgoing,
                createdAt: createdAt,
                updatedAt: updatedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String friendId,
                required String friendFirstName,
                required String friendLastName,
                Value<int> friendScore = const Value.absent(),
                required FriendshipStatus status,
                required bool isOutgoing,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FriendshipsCompanion.insert(
                id: id,
                friendId: friendId,
                friendFirstName: friendFirstName,
                friendLastName: friendLastName,
                friendScore: friendScore,
                status: status,
                isOutgoing: isOutgoing,
                createdAt: createdAt,
                updatedAt: updatedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FriendshipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FriendshipsTable,
      Friendship,
      $$FriendshipsTableFilterComposer,
      $$FriendshipsTableOrderingComposer,
      $$FriendshipsTableAnnotationComposer,
      $$FriendshipsTableCreateCompanionBuilder,
      $$FriendshipsTableUpdateCompanionBuilder,
      (
        Friendship,
        BaseReferences<_$AppDatabase, $FriendshipsTable, Friendship>,
      ),
      Friendship,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String firstName,
      required String lastName,
      required String email,
      required String friendCode,
      Value<int> score,
      Value<double> targetRetention,
      Value<double> userMemoryFactor,
      Value<String> language,
      Value<DateTime> updatedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> email,
      Value<String> friendCode,
      Value<int> score,
      Value<double> targetRetention,
      Value<double> userMemoryFactor,
      Value<String> language,
      Value<DateTime> updatedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get friendCode => $composableBuilder(
    column: $table.friendCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetRetention => $composableBuilder(
    column: $table.targetRetention,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get userMemoryFactor => $composableBuilder(
    column: $table.userMemoryFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get friendCode => $composableBuilder(
    column: $table.friendCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetRetention => $composableBuilder(
    column: $table.targetRetention,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get userMemoryFactor => $composableBuilder(
    column: $table.userMemoryFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get friendCode => $composableBuilder(
    column: $table.friendCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<double> get targetRetention => $composableBuilder(
    column: $table.targetRetention,
    builder: (column) => column,
  );

  GeneratedColumn<double> get userMemoryFactor => $composableBuilder(
    column: $table.userMemoryFactor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> friendCode = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<double> targetRetention = const Value.absent(),
                Value<double> userMemoryFactor = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                friendCode: friendCode,
                score: score,
                targetRetention: targetRetention,
                userMemoryFactor: userMemoryFactor,
                language: language,
                updatedAt: updatedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String firstName,
                required String lastName,
                required String email,
                required String friendCode,
                Value<int> score = const Value.absent(),
                Value<double> targetRetention = const Value.absent(),
                Value<double> userMemoryFactor = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                friendCode: friendCode,
                score: score,
                targetRetention: targetRetention,
                userMemoryFactor: userMemoryFactor,
                language: language,
                updatedAt: updatedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$DeletedItemsTableCreateCompanionBuilder =
    DeletedItemsCompanion Function({
      required String itemId,
      required DeleteResourceType resourceType,
      Value<bool> needsSync,
      Value<int> rowid,
    });
typedef $$DeletedItemsTableUpdateCompanionBuilder =
    DeletedItemsCompanion Function({
      Value<String> itemId,
      Value<DeleteResourceType> resourceType,
      Value<bool> needsSync,
      Value<int> rowid,
    });

class $$DeletedItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DeletedItemsTable> {
  $$DeletedItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DeleteResourceType, DeleteResourceType, String>
  get resourceType => $composableBuilder(
    column: $table.resourceType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeletedItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeletedItemsTable> {
  $$DeletedItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resourceType => $composableBuilder(
    column: $table.resourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeletedItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeletedItemsTable> {
  $$DeletedItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DeleteResourceType, String>
  get resourceType => $composableBuilder(
    column: $table.resourceType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);
}

class $$DeletedItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeletedItemsTable,
          DeletedItem,
          $$DeletedItemsTableFilterComposer,
          $$DeletedItemsTableOrderingComposer,
          $$DeletedItemsTableAnnotationComposer,
          $$DeletedItemsTableCreateCompanionBuilder,
          $$DeletedItemsTableUpdateCompanionBuilder,
          (
            DeletedItem,
            BaseReferences<_$AppDatabase, $DeletedItemsTable, DeletedItem>,
          ),
          DeletedItem,
          PrefetchHooks Function()
        > {
  $$DeletedItemsTableTableManager(_$AppDatabase db, $DeletedItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeletedItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeletedItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeletedItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<DeleteResourceType> resourceType = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeletedItemsCompanion(
                itemId: itemId,
                resourceType: resourceType,
                needsSync: needsSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required DeleteResourceType resourceType,
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeletedItemsCompanion.insert(
                itemId: itemId,
                resourceType: resourceType,
                needsSync: needsSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeletedItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeletedItemsTable,
      DeletedItem,
      $$DeletedItemsTableFilterComposer,
      $$DeletedItemsTableOrderingComposer,
      $$DeletedItemsTableAnnotationComposer,
      $$DeletedItemsTableCreateCompanionBuilder,
      $$DeletedItemsTableUpdateCompanionBuilder,
      (
        DeletedItem,
        BaseReferences<_$AppDatabase, $DeletedItemsTable, DeletedItem>,
      ),
      DeletedItem,
      PrefetchHooks Function()
    >;
typedef $$BibleBooksTableCreateCompanionBuilder =
    BibleBooksCompanion Function({
      required int id,
      required String name,
      required String translation,
      Value<int> rowid,
    });
typedef $$BibleBooksTableUpdateCompanionBuilder =
    BibleBooksCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> translation,
      Value<int> rowid,
    });

class $$BibleBooksTableFilterComposer
    extends Composer<_$AppDatabase, $BibleBooksTable> {
  $$BibleBooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BibleBooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BibleBooksTable> {
  $$BibleBooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BibleBooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BibleBooksTable> {
  $$BibleBooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );
}

class $$BibleBooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BibleBooksTable,
          BibleBook,
          $$BibleBooksTableFilterComposer,
          $$BibleBooksTableOrderingComposer,
          $$BibleBooksTableAnnotationComposer,
          $$BibleBooksTableCreateCompanionBuilder,
          $$BibleBooksTableUpdateCompanionBuilder,
          (
            BibleBook,
            BaseReferences<_$AppDatabase, $BibleBooksTable, BibleBook>,
          ),
          BibleBook,
          PrefetchHooks Function()
        > {
  $$BibleBooksTableTableManager(_$AppDatabase db, $BibleBooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BibleBooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BibleBooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BibleBooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> translation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BibleBooksCompanion(
                id: id,
                name: name,
                translation: translation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int id,
                required String name,
                required String translation,
                Value<int> rowid = const Value.absent(),
              }) => BibleBooksCompanion.insert(
                id: id,
                name: name,
                translation: translation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BibleBooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BibleBooksTable,
      BibleBook,
      $$BibleBooksTableFilterComposer,
      $$BibleBooksTableOrderingComposer,
      $$BibleBooksTableAnnotationComposer,
      $$BibleBooksTableCreateCompanionBuilder,
      $$BibleBooksTableUpdateCompanionBuilder,
      (BibleBook, BaseReferences<_$AppDatabase, $BibleBooksTable, BibleBook>),
      BibleBook,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalBibleVersesTableTableManager get localBibleVerses =>
      $$LocalBibleVersesTableTableManager(_db, _db.localBibleVerses);
  $$SavedVersesTableTableManager get savedVerses =>
      $$SavedVersesTableTableManager(_db, _db.savedVerses);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$FriendshipsTableTableManager get friendships =>
      $$FriendshipsTableTableManager(_db, _db.friendships);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$DeletedItemsTableTableManager get deletedItems =>
      $$DeletedItemsTableTableManager(_db, _db.deletedItems);
  $$BibleBooksTableTableManager get bibleBooks =>
      $$BibleBooksTableTableManager(_db, _db.bibleBooks);
}
