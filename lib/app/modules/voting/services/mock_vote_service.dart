import 'dart:async';

class MockVoteService {
  // singleton
  static final MockVoteService _instance = MockVoteService._internal();
  factory MockVoteService() => _instance;
  MockVoteService._internal();

  final _controller = StreamController<Map<String, String>>.broadcast();
  final Map<String, String> _votes = {}; // userId -> foodId

  Stream<Map<String, String>> get votesStream => _controller.stream;

  Map<String, String> get currentVotes => Map.unmodifiable(_votes);

  // Simulate a user voting
  void vote(String userId, String foodId) {
    _votes[userId] = foodId;
    _controller.add(Map.unmodifiable(_votes));
  }

  // Remove vote (cancel)
  void cancelVote(String userId) {
    _votes.remove(userId);
    _controller.add(Map.unmodifiable(_votes));
  }

  // For testing: simulate other users voting (randomly)
  void simulateOtherUserVote(String userId, String foodId) {
    vote(userId, foodId);
  }

  void dispose() {
    _controller.close();
  }
}
