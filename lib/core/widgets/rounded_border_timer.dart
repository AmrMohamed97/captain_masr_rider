import 'dart:ui';

import '../imports/imports.dart';

class RoundedBorderTimer extends StatefulWidget {
  const RoundedBorderTimer({
    super.key,
    required this.child,
    required this.onComplete,
    this.isPaused = false,
    this.totalDuration = const Duration(seconds: 20),
  });

  final Widget child;
  final Function() onComplete;
  final bool isPaused;
  final Duration totalDuration;

  @override
  State<RoundedBorderTimer> createState() => _RoundedBorderTimerState();
}

class _RoundedBorderTimerState extends State<RoundedBorderTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final double borderWidth = 4;
  final double borderRadius = 20;
  final int sides = 4;

  int currentSide = 0;
  List<bool> completed = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.totalDuration ~/ sides,
      vsync: this,
    )
      ..addListener(() {
        if (completed[3] == true) {
          widget.onComplete();
        }

        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            completed[currentSide] = true;
            currentSide = (currentSide + 1) % sides;
          });
          if (!widget.isPaused) {
            _controller.forward(from: 0);
          }
        }
      });

    if (!widget.isPaused) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant RoundedBorderTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPaused != oldWidget.isPaused) {
      if (widget.isPaused) {
        _controller.stop();
      } else {
        if (!_controller.isAnimating && completed[3] == false) {
          _controller.forward();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: RoundedBorderPainter(
          context: context,
          progress: _controller.value,
          currentSide: currentSide,
          completed: completed,
          borderRadius: borderRadius,
          borderWidth: borderWidth,
        ),
        child: widget.child,
      ),
    );
  }
}

class RoundedBorderPainter extends CustomPainter {
  final BuildContext context;
  final double progress;
  final int currentSide;
  final List<bool> completed;
  final double borderRadius;
  final double borderWidth;

  RoundedBorderPainter({
    required this.context,
    required this.progress,
    required this.currentSide,
    required this.completed,
    required this.borderRadius,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint greyPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final Paint redPaint = Paint()
      ..color = Theme.of(context).cardColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path borderPath = Path()..addRRect(rrect);
    canvas.drawPath(borderPath, greyPaint);

    // Extract each side as a subpath
    final List<PathMetric> metrics =
        borderPath.computeMetrics(forceClosed: true).toList();

    if (metrics.isEmpty) return;

    final PathMetric metric = metrics[0];
    final double totalLength = metric.length;
    final double quarter = totalLength / 4;

    // Draw completed sides
    for (int i = 0; i < 4; i++) {
      if (completed[i]) {
        final Path segment = metric.extractPath(i * quarter, (i + 1) * quarter);
        canvas.drawPath(segment, redPaint);
      }
    }

    // Draw current side's animated progress
    final double start = currentSide * quarter;
    final double end = start + quarter * progress;
    final Path segment = metric.extractPath(start, end);
    canvas.drawPath(segment, redPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
