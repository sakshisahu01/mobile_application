import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/answer_option_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/question_card_widget.dart';
import './widgets/timer_header_widget.dart';

/// Quiz Challenge Interface Screen
/// Presents time-sensitive multiple choice and true/false questions
/// with locked back navigation during active sessions
class QuizChallengeInterface extends StatefulWidget {
  const QuizChallengeInterface({Key? key}) : super(key: key);

  @override
  State<QuizChallengeInterface> createState() => _QuizChallengeInterfaceState();
}

class _QuizChallengeInterfaceState extends State<QuizChallengeInterface>
    with TickerProviderStateMixin {
  // Current question index
  int _currentQuestionIndex = 0;

  // Selected answer for current question
  String? _selectedAnswer;

  // Map to store all selected answers
  final Map<int, String> _selectedAnswers = {};

  // Countdown timer
  late AnimationController _timerController;
  int _remainingSeconds = 900; // 15 minutes = 900 seconds

  // Question review mode
  bool _isReviewMode = false;

  // Mock quiz data
  final List<Map<String, dynamic>> _quizQuestions = [
    {
      "id": 1,
      "type": "multiple_choice",
      "question": "What is the primary purpose of Flutter's widget tree?",
      "options": [
        "To manage application state",
        "To describe the user interface structure",
        "To handle network requests",
        "To store user preferences",
      ],
      "correctAnswer": "To describe the user interface structure",
      "difficulty": "medium",
      "points": 100,
    },
    {
      "id": 2,
      "type": "true_false",
      "question":
          "StatefulWidget can maintain mutable state that might change during the widget's lifetime.",
      "options": ["True", "False"],
      "correctAnswer": "True",
      "difficulty": "easy",
      "points": 50,
    },
    {
      "id": 3,
      "type": "multiple_choice",
      "question":
          "Which state management solution is officially recommended by the Flutter team?",
      "options": ["Provider", "BLoC", "Redux", "GetX"],
      "correctAnswer": "Provider",
      "difficulty": "medium",
      "points": 100,
    },
    {
      "id": 4,
      "type": "multiple_choice",
      "question":
          "What does the 'const' keyword do in Flutter widget constructors?",
      "options": [
        "Makes the widget immutable at compile time",
        "Prevents the widget from rebuilding",
        "Improves performance by caching the widget",
        "All of the above",
      ],
      "correctAnswer": "All of the above",
      "difficulty": "hard",
      "points": 150,
    },
    {
      "id": 5,
      "type": "true_false",
      "question":
          "Hot reload in Flutter preserves the application state during development.",
      "options": ["True", "False"],
      "correctAnswer": "True",
      "difficulty": "easy",
      "points": 50,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _remainingSeconds),
    );

    _timerController.addListener(() {
      setState(() {
        _remainingSeconds = (900 * (1 - _timerController.value)).round();

        // Show warning at 1 minute remaining
        if (_remainingSeconds == 60 && !_isReviewMode) {
          _showTimeWarning();
        }

        // Auto-submit when time expires
        if (_remainingSeconds == 0) {
          _autoSubmitQuiz();
        }
      });
    });

    _timerController.forward();
  }

  void _showTimeWarning() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.warningLight,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Time Warning', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        content: Text(
          'Only 1 minute remaining! Please complete your answers.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _autoSubmitQuiz() {
    _timerController.stop();
    _submitQuiz();
  }

  void _submitQuiz() {
    // Calculate score
    int totalScore = 0;
    int correctAnswers = 0;

    for (int i = 0; i < _quizQuestions.length; i++) {
      final question = _quizQuestions[i];
      final userAnswer = _selectedAnswers[i];

      if (userAnswer == question["correctAnswer"]) {
        totalScore += (question["points"] as int);
        correctAnswers++;
      }
    }

    // Navigate to results screen with score data
    Navigator.of(context, rootNavigator: true).pushReplacementNamed(
      '/results-screen',
      arguments: {
        'score': totalScore,
        'correctAnswers': correctAnswers,
        'totalQuestions': _quizQuestions.length,
        'challengeType': 'quiz',
        'timeSpent': 900 - _remainingSeconds,
      },
    );
  }

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _selectedAnswers[_currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = _selectedAnswers[_currentQuestionIndex];
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = _selectedAnswers[_currentQuestionIndex];
      });
    }
  }

  void _goToQuestion(int index) {
    setState(() {
      _currentQuestionIndex = index;
      _selectedAnswer = _selectedAnswers[_currentQuestionIndex];
      _isReviewMode = false;
    });
  }

  void _toggleReviewMode() {
    setState(() {
      _isReviewMode = !_isReviewMode;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentQuestion = _quizQuestions[_currentQuestionIndex];
    final isMultipleChoice = currentQuestion["type"] == "multiple_choice";

    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation during active session
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit Challenge?', style: theme.textTheme.titleLarge),
            content: Text(
              'Are you sure you want to exit? Your progress will be lost.',
              style: theme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushReplacementNamed('/user-dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorLight,
                ),
                child: Text('Exit'),
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
              // Timer Header
              TimerHeaderWidget(
                remainingSeconds: _remainingSeconds,
                currentQuestion: _currentQuestionIndex + 1,
                totalQuestions: _quizQuestions.length,
                onReviewTap: _toggleReviewMode,
              ),

              // Progress Indicator
              ProgressIndicatorWidget(
                currentIndex: _currentQuestionIndex,
                totalQuestions: _quizQuestions.length,
                answeredQuestions: _selectedAnswers.keys.toList(),
                onQuestionTap: _goToQuestion,
              ),

              // Main Content
              Expanded(
                child: _isReviewMode
                    ? _buildReviewMode(theme)
                    : _buildQuestionMode(
                        theme,
                        currentQuestion,
                        isMultipleChoice,
                      ),
              ),

              // Navigation Buttons
              if (!_isReviewMode) _buildNavigationButtons(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionMode(
    ThemeData theme,
    Map<String, dynamic> currentQuestion,
    bool isMultipleChoice,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Card
          QuestionCardWidget(
            questionNumber: _currentQuestionIndex + 1,
            totalQuestions: _quizQuestions.length,
            question: currentQuestion["question"] as String,
            difficulty: currentQuestion["difficulty"] as String,
            points: currentQuestion["points"] as int,
          ),

          SizedBox(height: 3.h),

          // Answer Options
          if (isMultipleChoice)
            ...(currentQuestion["options"] as List<dynamic>).map((option) {
              final optionStr = option as String;
              return Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: AnswerOptionWidget(
                  option: optionStr,
                  isSelected: _selectedAnswer == optionStr,
                  onTap: () => _selectAnswer(optionStr),
                ),
              );
            }).toList()
          else
            Row(
              children: [
                Expanded(
                  child: AnswerOptionWidget(
                    option: "True",
                    isSelected: _selectedAnswer == "True",
                    onTap: () => _selectAnswer("True"),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: AnswerOptionWidget(
                    option: "False",
                    isSelected: _selectedAnswer == "False",
                    onTap: () => _selectAnswer("False"),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildReviewMode(ThemeData theme) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: _quizQuestions.length,
      itemBuilder: (context, index) {
        final question = _quizQuestions[index];
        final isAnswered = _selectedAnswers.containsKey(index);

        return Card(
          margin: EdgeInsets.only(bottom: 2.h),
          child: InkWell(
            onTap: () => _goToQuestion(index),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Question Number Badge
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: isAnswered
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isAnswered
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isAnswered
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Question Preview
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question["question"] as String,
                          style: theme.textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(
                                  question["difficulty"] as String,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                question["difficulty"] as String,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: _getDifficultyColor(
                                    question["difficulty"] as String,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '${question["points"]} pts',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Status Icon
                  CustomIconWidget(
                    iconName: isAnswered
                        ? 'check_circle'
                        : 'radio_button_unchecked',
                    color: isAnswered
                        ? AppTheme.successLight
                        : theme.colorScheme.outline,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationButtons(ThemeData theme) {
    final isLastQuestion = _currentQuestionIndex == _quizQuestions.length - 1;
    final canProceed = _selectedAnswer != null;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous Button
          if (_currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousQuestion,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'arrow_back',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text('Previous'),
                  ],
                ),
              ),
            ),

          if (_currentQuestionIndex > 0) SizedBox(width: 3.w),

          // Next/Submit Button
          Expanded(
            flex: _currentQuestionIndex > 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: canProceed
                  ? (isLastQuestion ? _submitQuiz : _nextQuestion)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isLastQuestion
                    ? AppTheme.successLight
                    : theme.colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isLastQuestion ? 'Submit Quiz' : 'Next Question'),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: isLastQuestion ? 'check' : 'arrow_forward',
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppTheme.successLight;
      case 'medium':
        return AppTheme.warningLight;
      case 'hard':
        return AppTheme.errorLight;
      default:
        return AppTheme.primaryLight;
    }
  }
}
