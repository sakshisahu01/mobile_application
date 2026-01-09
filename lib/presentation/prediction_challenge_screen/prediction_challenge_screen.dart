import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import 'widgets/challenge_timer_widget.dart';
import 'widgets/confidence_selector_widget.dart';
import 'widgets/market_prediction_widget.dart';
import 'widgets/pop_culture_prediction_widget.dart';

/// Prediction Challenge Screen
/// Presents market and pop-culture prediction interfaces with intuitive mobile input methods
class PredictionChallengeScreen extends StatefulWidget {
  const PredictionChallengeScreen({Key? key}) : super(key: key);

  @override
  State<PredictionChallengeScreen> createState() =>
      _PredictionChallengeScreenState();
}

class _PredictionChallengeScreenState extends State<PredictionChallengeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Market prediction state
  double _marketPrediction = 50000.0;

  // Pop culture prediction state
  String? _selectedPopCultureOption;

  // Confidence level state
  int _confidenceLevel = 2;

  // Timer state
  late Duration _timeRemaining;
  late DateTime _deadline;

  // Mock data for challenges
  final Map<String, dynamic> _marketChallengeData = {
    'assetName': 'Bitcoin',
    'assetSymbol': 'BTC/USD',
    'currentValue': 48750.50,
    'minValue': 40000.0,
    'maxValue': 60000.0,
  };

  final Map<String, dynamic> _popCultureChallengeData = {
    'eventTitle': 'Oscar Best Picture 2026',
    'eventDescription':
        'Which movie will win the Academy Award for Best Picture at the 2026 Oscars ceremony?',
    'mediaUrl':
        'https://images.unsplash.com/photo-1591052303193-983fe0d5876f',
    'mediaType': 'image',
    'options': [
      {'id': 'option1', 'text': 'The Quantum Paradox'},
      {'id': 'option2', 'text': 'Echoes of Tomorrow'},
      {'id': 'option3', 'text': 'The Last Symphony'},
      {'id': 'option4', 'text': 'Beyond the Horizon'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _deadline = DateTime.now().add(Duration(minutes: 15));
    _timeRemaining = Duration(minutes: 12, seconds: 30);
    _marketPrediction = (_marketChallengeData['currentValue'] as num)
        .toDouble();

    // Simulate countdown timer
    Future.delayed(Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer() {
    if (mounted && _timeRemaining.inSeconds > 0) {
      setState(() {
        _timeRemaining = _timeRemaining - Duration(seconds: 1);
      });
      Future.delayed(Duration(seconds: 1), _updateTimer);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleMarketPredictionChanged(double value) {
    setState(() {
      _marketPrediction = value;
    });
  }

  void _handlePopCultureOptionSelected(String optionId) {
    setState(() {
      _selectedPopCultureOption = optionId;
    });
  }

  void _handleConfidenceChanged(int level) {
    setState(() {
      _confidenceLevel = level;
    });
  }

  void _handleSubmitPrediction() {
    final isMarketTab = _tabController.index == 0;

    if (isMarketTab) {
      showDialog(
        context: context,
        builder: (context) => _buildConfirmationDialog(
          title: 'Confirm Market Prediction',
          content:
              'You are predicting ${_marketChallengeData['assetSymbol']} will be at \$${_marketPrediction.toStringAsFixed(2)} with ${_getConfidenceLabel()} confidence.',
        ),
      );
    } else {
      if (_selectedPopCultureOption == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a prediction option'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final selectedOption = (_popCultureChallengeData['options'] as List)
          .firstWhere(
            (opt) =>
                (opt as Map<String, dynamic>)['id'] ==
                _selectedPopCultureOption,
          );

      showDialog(
        context: context,
        builder: (context) => _buildConfirmationDialog(
          title: 'Confirm Pop Culture Prediction',
          content:
              'You are predicting: ${(selectedOption as Map<String, dynamic>)['text']} with ${_getConfidenceLabel()} confidence.',
        ),
      );
    }
  }

  String _getConfidenceLabel() {
    switch (_confidenceLevel) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Medium';
    }
  }

  Widget _buildConfirmationDialog({
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed('/results-screen');
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Challenge'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'info_outline',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('How It Works'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Market Predictions:',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '• Predict the price at challenge end time\n• Use the slider to set your prediction\n• Higher confidence = Higher rewards',
                          style: theme.textTheme.bodySmall,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Pop Culture Predictions:',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '• Select the outcome you predict\n• Review event details carefully\n• Verification happens after event concludes',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'trending_up',
                color: _tabController.index == 0
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              text: 'Market',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'movie',
                color: _tabController.index == 1
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              text: 'Pop Culture',
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChallengeTimerWidget(
                      timeRemaining: _timeRemaining,
                      deadline: _deadline,
                    ),
                    SizedBox(height: 3.h),
                    SizedBox(
                      height: 60.h,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          MarketPredictionWidget(
                            challengeData: _marketChallengeData,
                            currentPrediction: _marketPrediction,
                            onPredictionChanged: _handleMarketPredictionChanged,
                          ),
                          PopCulturePredictionWidget(
                            challengeData: _popCultureChallengeData,
                            selectedOption: _selectedPopCultureOption,
                            onOptionSelected: _handlePopCultureOptionSelected,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    ConfidenceSelectorWidget(
                      selectedConfidence: _confidenceLevel,
                      onConfidenceChanged: _handleConfidenceChanged,
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'lightbulb_outline',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Submit within 5 minutes for 1.5x speed bonus!',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _handleSubmitPrediction,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Submit Prediction',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'send',
                      color: theme.colorScheme.onPrimary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
