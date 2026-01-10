import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final TextEditingController _searchCtl = TextEditingController();
  List<Map<String, dynamic>> _all = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _loading = false;

  // UI state
  int _selectedPeriod = 0; // 0: Daily, 1: Weekly, 2: Monthly

  // Current user placeholder (used to highlight "You Currently Rank" card)
  int _currentUserRank = 9;
  int _currentUserScore = 34;

  @override
  void initState() {
    super.initState();
    _loadSample();
    _searchCtl.addListener(_applyFilter);
  }

  void _loadSample() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 300));
    _all = List.generate(30, (i) => {
      'rank': i + 1,
      'name': 'Player ${i + 1}',
      'score': (1500 - i * 27),
    });
    _applyFilter();
    setState(() => _loading = false);
  }

  void _applyFilter() {
    final q = _searchCtl.text.toLowerCase();
    if (q.isEmpty) {
      _filtered = List.from(_all);
    } else {
      _filtered = _all.where((p) => (p['name'] as String).toLowerCase().contains(q)).toList();
    }
    setState(() {});
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    _loadSample();
  }

  Widget _topMedal(int rank) {
    switch (rank) {
      case 1:
        return Icon(Icons.emoji_events, color: Colors.amber[700], size: 20);
      case 2:
        return Icon(Icons.emoji_events, color: Colors.grey[400], size: 20);
      case 3:
        return Icon(Icons.emoji_events, color: Colors.brown[400], size: 20);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final top3 = _filtered.take(3).toList();
    final rest = _filtered.skip(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2FF),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Purple header with title and segmented control
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF9B59FF), Color(0xFF7A39FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.maybePop(context),
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                ),
                                Text('Results', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                                const SizedBox(width: 44),
                              ],
                            ),

                            SizedBox(height: 1.h),

                            Container(
                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text('Leaderboard', style: theme.textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                            ),

                            SizedBox(height: 1.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (i) {
                                final labels = ['Daily', 'Weekly', 'Monthly'];
                                final selected = _selectedPeriod == i;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedPeriod = i),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: selected ? Colors.white : Colors.white.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(labels[i], style: theme.textTheme.bodyMedium?.copyWith(color: selected ? Color(0xFF6D2DFF) : Colors.white)),
                                  ),
                                );
                              }),
                            ),

                            SizedBox(height: 2.h),

                            // Top 3 avatars (center larger with crown)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(3, (i) {
                                if (i >= top3.length) return const SizedBox.shrink();
                                final p = top3[i];
                                final rank = p['rank'] as int;
                                final isFirst = rank == 1;
                                final avatarSize = isFirst ? 68.0 : 48.0;
                                return Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        if (isFirst)
                                          Positioned(
                                            top: -10,
                                            child: Icon(Icons.emoji_events, color: Colors.yellow[700], size: 28),
                                          ),
                                        CircleAvatar(
                                          radius: avatarSize / 2,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: (avatarSize / 2) - 4,
                                            backgroundColor: Colors.grey.shade200,
                                            child: Text('${p['rank']}', style: theme.textTheme.titleSmall),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.8.h),
                                    Text(p['name'] as String, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white)),
                                    SizedBox(height: 0.6.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                                      child: Text('${p['score']} pts', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white)),
                                    )
                                  ],
                                );
                              }),
                            ),

                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Search + stats row
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchCtl,
                              decoration: InputDecoration(
                                hintText: 'Search players',
                                prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${_filtered.length}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                              Text('players', style: theme.textTheme.bodySmall),
                            ],
                          )
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Highlighted "You Currently Rank" card (if present)
                      if (_filtered.any((p) => p['rank'] == _currentUserRank))
                        Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F2FF),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(radius: 20, backgroundColor: theme.colorScheme.primaryContainer, child: Text('9', style: theme.textTheme.bodySmall)),
                              SizedBox(width: 3.w),
                              Expanded(child: Text('You Currently Rank', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
                              Container(padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10), decoration: BoxDecoration(color: Color(0xFFF2F0FF), borderRadius: BorderRadius.circular(12)), child: Text('34', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)))
                            ],
                          ),
                        ),

                      // Player list
                      _loading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: rest.map((item) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                  decoration: BoxDecoration(color: const Color(0xFFF8F4FF), borderRadius: BorderRadius.circular(14)),
                                  child: Row(
                                    children: [
                                      CircleAvatar(radius: 18, backgroundColor: theme.colorScheme.primaryContainer, child: Text('${item['rank']}', style: theme.textTheme.bodySmall)),
                                      SizedBox(width: 3.w),
                                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['name'] as String, style: theme.textTheme.bodyMedium), SizedBox(height: 4), Text('Rank ${item['rank']}', style: theme.textTheme.bodySmall)])),
                                      Container(padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12), decoration: BoxDecoration(color: const Color(0xFFEDE2FF), borderRadius: BorderRadius.circular(20)), child: Text('${item['score']}', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)))
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),

                      SizedBox(height: 2.h),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
