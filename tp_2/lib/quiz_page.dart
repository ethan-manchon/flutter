import 'dart:async';
import 'package:flutter/material.dart';
import 'models.dart';
import 'question_text.dart';
import 'answer_text.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

final List<Question> questions = [
  Question(
    question: 'Quelle entreprise développe Flutter ?',
    answers: [
      Answer(text: 'Google', isCorrect: true),
      Answer(text: 'Apple', isCorrect: false),
      Answer(text: 'Microsoft', isCorrect: false),
      Answer(text: 'Amazon', isCorrect: false),
    ],
  ),
  Question(
    question: 'Quel langage est utilisé avec Flutter ?',
    answers: [
      Answer(text: 'Kotlin', isCorrect: false),
      Answer(text: 'Dart', isCorrect: true),
      Answer(text: 'Swift', isCorrect: false),
      Answer(text: 'JavaScript', isCorrect: false),
    ],
  ),
      Question(
    question: 'Quelle est la commande pour créer un nouveau projet Flutter ?',
    answers: [
      Answer(text: 'flutter new project', isCorrect: false),
      Answer(text: 'flutter create', isCorrect: true),
      Answer(text: 'flutter init', isCorrect: false),
      Answer(text: 'flutter start', isCorrect: false),
    ],
      ),
  Question(
    question: 'Quel widget Flutter est utilisé pour afficher une liste déroulante ?',
    answers: [
      Answer(text: 'ListView', isCorrect: false),
      Answer(text: 'DropdownButton', isCorrect: true),
      Answer(text: 'GridView', isCorrect: false),
      Answer(text: 'Stack', isCorrect: false),
    ],
  ),
  Question(
    question: 'Quelle méthode est utilisée pour démarrer une application Flutter ?',
    answers: [
      Answer(text: 'runApp()', isCorrect: true),
      Answer(text: 'startApp()', isCorrect: false),
      Answer(text: 'initApp()', isCorrect: false),
      Answer(text: 'launchApp()', isCorrect: false),
    ],
  ),
];

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;
  int selectedAnswerIndex = -1;
  int maxQuestions = questions.length;
  
  static const int maxTime = 100; 
  int timeRemaining = maxTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    timeRemaining = maxTime;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeRemaining > 0) {
          timeRemaining--;
        } else {
          // Temps écoulé - question comptée comme fausse
          _timer?.cancel();
          _onTimeUp();
        }
      });
    });
  }

  void _onTimeUp() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: const Row(
          children: [
            Icon(Icons.timer_off, color: Colors.white),
            SizedBox(width: 12),
            Text('Temps écoulé ! ⏰'),
          ],
        ),
      ),
    );
    answerQuestion(false);
  }

  void answerQuestion(bool isCorrect) {
    _timer?.cancel();
    setState(() {
      if (isCorrect) score++;
      currentQuestion++;
      selectedAnswerIndex = -1;
    });
    // Redémarrer le timer pour la prochaine question
    if (currentQuestion < questions.length) {
      _startTimer();
    }
  }

  void resetQuiz() {
    setState(() {
      currentQuestion = 0;
      score = 0;
      selectedAnswerIndex = -1;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: currentQuestion < questions.length
          ? AppBar(
              title: const Text(
                'Quiz Flutter',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
          child: SafeArea(
            child: currentQuestion >= questions.length
                ? _buildResultScreen()
                : _buildQuestionScreen(),
          ),
        ),
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône animée
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: (score == maxQuestions
                            ? Colors.amber
                            : (score >= maxQuestions / 2
                                ? Colors.green
                                : Colors.red)),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                score == maxQuestions
                    ? Icons.emoji_events
                    : (score >= maxQuestions / 2
                        ? Icons.thumb_up
                        : Icons.thumb_down),
                color: score == maxQuestions
                    ? Colors.amber
                    : (score >= maxQuestions / 2 ? Colors.green : Colors.red),
                size: 80,
              ),
            ),
            const SizedBox(height: 40),

            // Message de résultat
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    score == maxQuestions
                        ? 'Parfait ! 🎉'
                        : (score >= maxQuestions / 2
                            ? 'Bien joué ! 👏'
                            : 'Essaie encore ! 💪'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$score / $maxQuestions',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: score == maxQuestions
                          ? Colors.amber
                          : (score >= maxQuestions / 2
                              ? Colors.greenAccent
                              : Colors.redAccent),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'bonne${score > 1 ? "s" : ""} réponse${score > 1 ? "s" : ""}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // Bouton rejouer avec hover
            _HoverButton(
              onPressed: resetQuiz,
              icon: Icons.replay_rounded,
              label: 'Rejouer',
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final question = questions[currentQuestion];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: timeRemaining / maxTime,
                        strokeWidth: 5,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          timeRemaining <= 5
                              ? Colors.red
                              : (timeRemaining <= 10
                                  ? Colors.orange
                                  : Colors.greenAccent),
                        ),
                      ),
                    ),
                    Text(
                      '$timeRemaining',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: timeRemaining <= 5
                            ? Colors.red
                            : (timeRemaining <= 10
                                ? Colors.orange
                                : Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
          const SizedBox(height: 20),
          // Timer et indicateur de progression
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Question ${currentQuestion + 1} / $maxQuestions',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Question
          QuestionText(questionText: question.question),

          const SizedBox(height: 40),

          // Grille de réponses
          Expanded(
            flex: 2,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8,
              physics: const NeverScrollableScrollPhysics(),
              children: question.answers.asMap().entries.map((entry) {
                final index = entry.key;
                final answer = entry.value;
                final isSelected = selectedAnswerIndex == index;

                return AnswerText(
                  answerText: answer.text,
                  active: isSelected,
                  onPressed: () {
                    setState(() {
                      selectedAnswerIndex = isSelected ? -1 : index;
                    });
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Bouton valider
          _HoverButton(
            onPressed: () {
              if (selectedAnswerIndex == -1) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    content: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.black),
                        SizedBox(width: 12),
                        Text('Sélectionne une réponse !'),
                      ],
                    ),
                  ),
                );
                return;
              }

              final isCorrect = question.answers[selectedAnswerIndex].isCorrect;
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  backgroundColor:
                      isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Text(isCorrect ? 'Bonne réponse ! 🎉' : 'Mauvaise réponse 😕'),
                    ],
                  ),
                ),
              );

              answerQuestion(isCorrect);
            },
            icon: selectedAnswerIndex == -1 ? Icons.block : Icons.check_circle,
            label: 'Valider',
            isPrimary: selectedAnswerIndex != -1,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Widget pour les boutons principaux avec effet hover
class _HoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final bool isPrimary;

  const _HoverButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isPrimary = false,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(_isHovered ? 1.08 : 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? LinearGradient(
                    colors: [
                      Colors.deepPurple.shade400,
                      Colors.deepPurple.shade700,
                    ],
                  )
                : null,
            color: widget.isPrimary ? null : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.isPrimary
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              if (_isHovered || widget.isPrimary)
                BoxShadow(
                  color: widget.isPrimary
                      ? Colors.deepPurple.withOpacity(0.5)
                      : Colors.white.withOpacity(0.2),
                  blurRadius: _isHovered ? 25 : 15,
                  spreadRadius: _isHovered ? 5 : 2,
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
