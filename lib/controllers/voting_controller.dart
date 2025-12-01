import 'dart:async';
import 'package:get/get.dart';
import '../models/food_option.dart';
import '../services/mock_vote_service.dart';

class VotingController extends GetxController {
  final MockVoteService _service = MockVoteService();

  // sample options
  final options = <FoodOption>[
    FoodOption(
      id: 'soto',
      name: 'Soto Miring',
      rating: 4.8,
      distanceMinutes: 5,
      price: 35000,
    ),
    FoodOption(
      id: 'mie',
      name: 'Mie Ayam Bangka',
      rating: 4.7,
      distanceMinutes: 7,
      price: 28000,
    ),
    FoodOption(
      id: 'nasi',
      name: 'Nasi Goreng Kambing',
      rating: 4.3,
      distanceMinutes: 10,
      price: 45000,
    ),
  ].obs;

  final votes = <String, String>{}.obs; // userId -> foodId
  final totalMembers = 6.obs;

  StreamSubscription<Map<String, String>>? _sub;

  @override
  void onInit() {
    super.onInit();
    // subscribe to mock backend
    _sub = _service.votesStream.listen((map) {
      votes.value = Map<String, String>.from(map);
    });
  }

  // perform vote for current user
  void vote({required String userId, required String foodId}) {
    _service.vote(userId, foodId);
  }

  void cancelVote(String userId) {
    _service.cancelVote(userId);
  }

  bool userHasVoted(String userId) => votes.containsKey(userId);

  int get votedCount => votes.length;

  bool get allVoted => votedCount >= totalMembers.value;

  // compute winner (simple plurality)
  FoodOption? get winner {
    if (votes.isEmpty) return null;
    final counts = <String, int>{};
    for (final v in votes.values) {
      counts[v] = (counts[v] ?? 0) + 1;
    }
    final topId = counts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
    return options.firstWhereOrNull((o) => o.id == topId);
  }

  // For debug: simulate others
  void simulateOthers() {
    // simple simulate: fill remaining slots with random picks (deterministic here)
    final ids = options.map((e) => e.id).toList();
    int i = 1;
    while (votes.length < totalMembers.value) {
      final uid = 'user_sim_$i';
      final pick = ids[i % ids.length];
      _service.simulateOtherUserVote(uid, pick);
      i++;
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}

// helper extension for firstWhereOrNull (since collections package is not added)
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
