// lib/routes/app_routes.dart
import 'package:get/get.dart';
import '../screens/voting_filter_screen.dart';
import '../screens/voting_choice_screen.dart';
import '../screens/voting_loading_screen.dart';
import '../screens/voting_result_screen.dart';

class AppRoutes {
  // semua nama route yang digunakan di project
  static const votingFilter = '/voting-filter';
  static const votingChoice = '/voting-choice';
  static const votingLoading = '/voting-loading';
  static const votingResult = '/voting-result';

  // daftar halaman GetX
  static final pages = <GetPage>[
    GetPage(name: votingFilter, page: () => VotingFilterScreen()),
    GetPage(name: votingChoice, page: () => VotingChoiceScreen()),
    GetPage(name: votingLoading, page: () => VotingLoadingScreen()),
    GetPage(name: votingResult, page: () => VotingResultScreen()),
  ];
}
