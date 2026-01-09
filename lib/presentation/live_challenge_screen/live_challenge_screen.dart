import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/challenge_timer_widget.dart';
import './widgets/challenge_type_badge_widget.dart';
import './widgets/prediction_content_widget.dart';
import './widgets/quiz_content_widget.dart';
import './widgets/speed_multiplier_widget.dart';
import './widgets/submission_button_widget.dart';
import './widgets/video_recording_widget.dart';

/// Live Challenge Screen - Immersive 15-minute challenge experience
/// with real-time countdown timer and WebSocket synchronization
class LiveChallengeScreen extends StatefulWidget {
  const LiveChallengeScreen({Key? key}) : super(key: key);

  @override
  State<LiveChallengeScreen> createState() => _LiveChallengeScreenState();
}

class _LiveChallengeScreenState extends State<LiveChallengeScreen>
    with TickerProviderStateMixin {
  // Challenge state
  late Timer _countdownTimer;
  int _remainingSeconds = 900; // 15 minutes = 900 seconds
  bool _isSubmitting = false;
  bool _hasSubmitted = false;
  String _selectedChallengeType = 'Quiz'; // Quiz, Video, Prediction

  // Quiz state
  int _currentQuestionIndex = 0;
  Map<int, String> _quizAnswers = {};

  // Video state
  String? _recordedVideoPath;

  // Prediction state
  double _predictionValue = 50.0;

  // Speed multiplier tracking
  bool _isSpeedBonusActive = true;

  // Animation controllers
  late AnimationController _timerAnimationController;
  late AnimationController _pulseAnimationController;

  @override
  void initState() {
    super.initState();
    _initializeChallenge();
    _startCountdown();
    _setupAnimations();
  }

  void _initializeChallenge() {
    // Simulate challenge type selection (60% quiz, 25% video, 15% prediction)
    final random = DateTime.now().millisecond % 100;
    if (random < 60) {
      _selectedChallengeType = 'Quiz';
    } else if (random < 85) {
      _selectedChallengeType = 'Video';
    } else {
      _selectedChallengeType = 'Prediction';
    }
  }

  void _setupAnimations() {
    _timerAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 900),
    )..forward();

    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;

          // Deactivate speed bonus after 5 minutes
          if (_remainingSeconds == 600) {
            _isSpeedBonusActive = false;
          }

          // Auto-submit when time runs out
          if (_remainingSeconds == 0) {
            _handleTimeExpired();
          }
        }
      });
    });
  }

  void _handleTimeExpired() {
    _countdownTimer.cancel();
    if (!_hasSubmitted) {
      _showTimeExpiredDialog();
    }
  }

  void _showTimeExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Time\'s Up!'),
        content: Text(
          'The challenge time has expired. Your progress will be submitted automatically.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _submitChallenge();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitChallenge() async {
    if (_hasSubmitted) return;

    setState(() {
      _isSubmitting = true;
    });

    // Show confirmation dialog
    final confirmed = await _showSubmissionConfirmation();

    if (confirmed == true) {
      // Simulate submission delay
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _hasSubmitted = true;
        _isSubmitting = false;
      });

      _countdownTimer.cancel();

      // Navigate to results screen
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(
          '/results-screen',
          arguments: {
            'challengeType': _selectedChallengeType,
            'timeSpent': 900 - _remainingSeconds,
            'speedBonusEarned': _isSpeedBonusActive,
            'answers': _selectedChallengeType == 'Quiz' ? _quizAnswers : null,
            'videoPath': _selectedChallengeType == 'Video'
                ? _recordedVideoPath
                : null,
            'predictionValue': _selectedChallengeType == 'Prediction'
                ? _predictionValue
                : null,
          },
        );
      }
    } else {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<bool?> _showSubmissionConfirmation() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Submit Challenge?'),
        content: Text(
          'Are you sure you want to submit your challenge? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _handleQuizAnswer(int questionIndex, String answer) {
    setState(() {
      _quizAnswers[questionIndex] = answer;
    });
  }

  void _handleVideoRecorded(String videoPath) {
    setState(() {
      _recordedVideoPath = videoPath;
    });
  }

  void _handlePredictionChange(double value) {
    setState(() {
      _predictionValue = value;
    });
  }

  bool _canSubmit() {
    if (_hasSubmitted) return false;

    switch (_selectedChallengeType) {
      case 'Quiz':
        return _quizAnswers.length >= 3; // At least 3 questions answered
      case 'Video':
        return _recordedVideoPath != null;
      case 'Prediction':
        return true; // Always can submit prediction
      default:
        return false;
    }
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _timerAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (_hasSubmitted) return true;

        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit Challenge?'),
            content: Text(
              'If you exit now, your progress will be lost and you won\'t earn any rewards.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Exit',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          ),
        );

        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top section - Timer and challenge info
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Close button and challenge type badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: theme.colorScheme.onSurface,
                            size: 24,
                          ),
                          onPressed: () async {
                            final shouldExit = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Exit Challenge?'),
                                content: Text(
                                  'If you exit now, your progress will be lost.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('Stay'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text('Exit'),
                                  ),
                                ],
                              ),
                            );

                            if (shouldExit == true && mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        ChallengeTypeBadgeWidget(
                          challengeType: _selectedChallengeType,
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Countdown timer
                    ChallengeTimerWidget(
                      remainingSeconds: _remainingSeconds,
                      totalSeconds: 900,
                      animationController: _timerAnimationController,
                    ),

                    SizedBox(height: 2.h),

                    // Speed multiplier indicator
                    if (_isSpeedBonusActive)
                      SpeedMultiplierWidget(
                        pulseAnimation: _pulseAnimationController,
                      ),
                  ],
                ),
              ),

              // Main content area
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: _buildChallengeContent(theme),
                ),
              ),

              // Bottom section - Submission button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SubmissionButtonWidget(
                  canSubmit: _canSubmit(),
                  isSubmitting: _isSubmitting,
                  hasSubmitted: _hasSubmitted,
                  onSubmit: _submitChallenge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeContent(ThemeData theme) {
    switch (_selectedChallengeType) {
      case 'Quiz':
        return QuizContentWidget(
          currentQuestionIndex: _currentQuestionIndex,
          selectedAnswers: _quizAnswers,
          onAnswerSelected: _handleQuizAnswer,
          onNextQuestion: () {
            setState(() {
              _currentQuestionIndex++;
            });
          },
          onPreviousQuestion: () {
            setState(() {
              if (_currentQuestionIndex > 0) {
                _currentQuestionIndex--;
              }
            });
          },
        );

      case 'Video':
        return VideoRecordingWidget(
          onVideoRecorded: _handleVideoRecorded,
          recordedVideoPath: _recordedVideoPath,
        );

      case 'Prediction':
        return PredictionContentWidget(
          predictionValue: _predictionValue,
          onPredictionChanged: _handlePredictionChange,
        );

      default:
        return Center(
          child: Text(
            'Unknown challenge type',
            style: theme.textTheme.bodyLarge,
          ),
        );
    }
  }
}
