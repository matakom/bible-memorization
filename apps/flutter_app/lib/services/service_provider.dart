import 'package:flutter_riverpod/flutter_riverpod.dart';

// Interfaces
import '../services/srs/srs_types.dart';

// Implementations
import '../services/srs/algorithms/sm2_algorithm.dart';
import '../services/srs/algorithms/hlr_algorithm.dart';

/// TODO: MAKING SYSTEM FOR MAKING SURE TO USE HLR TOO
final srsServiceProvider = Provider<SrsAlgorithm>((ref) {
  return Sm2Algorithm();
  
});