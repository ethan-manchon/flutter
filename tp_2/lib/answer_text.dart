import 'package:flutter/material.dart';

class AnswerText extends StatefulWidget {
  final String answerText;
  final bool active;
  final VoidCallback? onPressed;

  const AnswerText({
    super.key,
    required this.answerText,
    this.active = false,
    this.onPressed,
  });

  @override
  State<AnswerText> createState() => _AnswerTextState();
}

class _AnswerTextState extends State<AnswerText> {
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
          transform: Matrix4.identity()
            ..scale(_isHovered || widget.active ? 1.05 : 1.0),
          decoration: BoxDecoration(
            color: widget.active
                ? Colors.deepPurple.shade400
                : (_isHovered
                    ? Colors.white
                    : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.active
                  ? Colors.white
                  : (_isHovered
                      ? Colors.white
                      : Colors.white),
              width: widget.active ? 2.5 : 1.5,
            ),
            boxShadow: [
              if (widget.active || _isHovered)
                BoxShadow(
                  color: widget.active
                      ? Colors.deepPurple
                      : Colors.white,
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Text(
                widget.answerText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: widget.active ? FontWeight.bold : FontWeight.w500,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}