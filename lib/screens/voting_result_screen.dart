import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/voting_controller.dart';

class VotingResultScreen extends StatelessWidget {
  VotingResultScreen({super.key});
  final VotingController c = Get.find<VotingController>();

  Map<String, int> _countVotes(Map<String, String> votes) {
    final map = <String, int>{};
    votes.values.forEach((v) => map[v] = (map[v] ?? 0) + 1);
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Voting")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final counts = _countVotes(c.votes);
          final total = c.votedCount == 0
              ? 1
              : c.votedCount; // avoid zero divide
          // determine winner
          final winner = c.winner;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Waktunya Makan!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Pemenangnya adalah:"),
              const SizedBox(height: 16),
              if (winner != null)
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFDFF0FF),
                      border: Border.all(color: const Color(0xFF0A73FF)),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          winner.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "⭐ ${winner.rating} | ${winner.distanceMinutes} min jalan | Rp ${winner.price}",
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A73FF),
                          ),
                          child: const Text("Yuk, Berangkat!"),
                        ),
                      ],
                    ),
                  ),
                )
              else
                const Center(child: Text("Belum ada suara.")),
              const SizedBox(height: 28),
              const Text(
                "Rincian suara:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // list breakdown
              ...c.options.map((o) {
                final count = counts[o.id] ?? 0;
                final percent = (count / total) * 100;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(o.name), Text("$count suara")],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: percent / 100,
                        minHeight: 12,
                      ),
                    ],
                  ),
                );
              }).toList(),
              const Spacer(),
              Center(
                child: Text(
                  "${c.votedCount} dari ${c.totalMembers.value} bergabung",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
