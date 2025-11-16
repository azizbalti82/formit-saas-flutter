import 'package:flutter/material.dart';
import 'package:canvas_kit/canvas_kit.dart';
import 'package:flutter/scheduler.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../backend/models/form/screen.dart';
import '../services/themeService.dart';

class InteractiveCanvas extends StatefulWidget {
  final List<Screen> screens;
  final theme t;
  final bool isAutoConnect;
  final Function(Offset position, String itemMovedId, bool isEnding)
  onScreenMoved;

  const InteractiveCanvas({
    super.key,
    required this.isAutoConnect,
    required this.screens,
    required this.t,
    required this.onScreenMoved,
  });

  @override
  _InteractiveCanvasState createState() => _InteractiveCanvasState();
}

class _InteractiveCanvasState extends State<InteractiveCanvas> {
  late final CanvasKitController _controller;
  final Map<String, ValueNotifier<Offset>> _positionNotifiers = {};
  late List<Screen> screens;
  bool _initialized = false;

  // Connection dragging state
  String? _draggingFromScreenId;
  Offset? _dragEndPosition;

  @override
  void initState() {
    super.initState();
    _controller = CanvasKitController();
    screens = widget.screens;
  }

  @override
  void didUpdateWidget(InteractiveCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.screens != widget.screens) {
      setState(() {
        screens = widget.screens;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var notifier in _positionNotifiers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  void _onConnectionTap(String fromScreenId, String toScreenId) {
    print("Connection tapped: $fromScreenId -> $toScreenId");
    // TODO: Show connection parameters dialog
  }

  void _startDraggingConnection(String screenId) {
    setState(() {
      _draggingFromScreenId = screenId;
      _dragEndPosition = null;
    });
  }

  void _updateDraggingConnection(Offset globalPosition) {
    // Convert global to local canvas position
    final RenderBox? canvasBox = context.findRenderObject() as RenderBox?;
    if (canvasBox != null) {
      final localPos = canvasBox.globalToLocal(globalPosition);
      setState(() {
        _dragEndPosition = localPos;
      });
    }
  }

  void _endDraggingConnection(String? targetScreenId, theme t) {
    if (_draggingFromScreenId != null &&
        targetScreenId != null &&
        _draggingFromScreenId != targetScreenId) {
      // Find the source screen and add the connection
      final screen = screens.firstWhere((s) => s.id == _draggingFromScreenId);

      // Check if connection already exists
      final alreadyConnected = screen.workflow.connects.any(
        (c) => c.screenId == targetScreenId,
      );

      if (!alreadyConnected) {
        screen.workflow.connects.add(Connect(screenId: targetScreenId));
        print("Connected ${_draggingFromScreenId} to $targetScreenId");
      }
    }

    setState(() {
      _draggingFromScreenId = null;
      _dragEndPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && screens != widget.screens) {
          setState(() {
            screens = widget.screens;
          });
        }
      });
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            // Clicked on empty space - cancel dragging
            if (_draggingFromScreenId != null) {
              _endDraggingConnection(null,widget.t);
            }
          },
          child: MouseRegion(
            onHover: (event) {
              // Update drag line to follow cursor
              if (_draggingFromScreenId != null) {
                _updateDraggingConnection(event.position);
              }
            },
            child: Stack(
              children: [
                CanvasKit(
                  controller: _controller,
                  foregroundLayers: _connectsBuilder(widget.t),
                  backgroundBuilder: (transform) => Container(
                    color: widget.t.accentColor.withOpacity(0),
                    child: CustomPaint(
                      painter: _GridPainter(transform, t: widget.t),
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                    ),
                  ),
                  children: screens.map((screen) {
                    return CanvasItem(
                      id: screen.id,
                      worldPosition: screen.workflow.position,
                      draggable: true,
                      onWorldMoved: (pos) {
                        screen.workflow.position = pos;
                        widget.onScreenMoved(pos, screen.id, screen.isEnding);
                        setState(() {});
                      },
                      child: _buildScreenNode(screen, widget.t),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildScreenNode(Screen screen, theme t) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main node container
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            color: screen.isEnding ? Colors.green : t.accentColor,
            border: (t.brightness == Brightness.dark)
                ? Border.all(color: t.bgColor, width: 2)
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                screen.isEnding
                    ? HugeIconsSolid.flag03
                    : HugeIconsSolid.changeScreenMode,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  screen.id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Left connection point (input - receives connections)
        Positioned(
          left: -12,
          top: 44 - 12,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // If we're dragging, connect to this screen
              if (_draggingFromScreenId != null) {
                _endDraggingConnection(screen.id,widget.t);
              }
            },
            child: Container(
              width: 40, // Larger hit area
              height: 40,
              alignment: Alignment.center,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: screen.isEnding ? Colors.green : t.accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Right connection point (output - drag from here)
        // Only show for non-ending screens
        if (!screen.isEnding)
          Positioned(
            right: -12,
            top: 44 - 12,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (_draggingFromScreenId == null) {
                  // Start dragging
                  _startDraggingConnection(screen.id);
                } else if (_draggingFromScreenId == screen.id) {
                  // Clicked same screen - cancel
                  _endDraggingConnection(null,widget.t);
                } else {
                  // Clicked different screen - connect
                  _endDraggingConnection(screen.id,widget.t);
                }
              },
              child: Container(
                width: 40, // Larger hit area
                height: 40,
                alignment: Alignment.center,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: t.accentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Icon(Icons.add_rounded, color: Colors.white, size: 14),
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<CustomPainter Function(Matrix4 transform)> _connectsBuilder(theme t) {
    List<CustomPainter Function(Matrix4 transform)> connections = [];

    // Add auto-connections if enabled
    if (widget.isAutoConnect && screens.isNotEmpty) {
      print("Building connections for ${screens.length} screens");

      for (int i = 0; i < screens.length - 1; i++) {
        final currentScreen = screens[i];
        final nextScreen = screens[i + 1];

        connections.add((transform) {
          return ConnectionPainter(
            transform,
            [currentScreen.workflow.position, nextScreen.workflow.position],
            widget.t.textColor,
            () => _onConnectionTap(currentScreen.id, nextScreen.id),
            widget.t
          );
        });
      }
    }

    // Add manual connections based on connects list
    for (var screen in screens) {
      for (var connect in screen.workflow.connects) {
        final targetScreen = screens.firstWhere(
          (s) => s.id == connect.screenId,
          orElse: () => screen,
        );

        if (targetScreen != screen) {
          connections.add((transform) {
            return ConnectionPainter(
              transform,
              [screen.workflow.position, targetScreen.workflow.position],
              widget.t.textColor,
              () => _onConnectionTap(screen.id, targetScreen.id,),
              t
            );
          });
        }
      }
    }

    // Add temporary dragging connection
    if (_draggingFromScreenId != null && _dragEndPosition != null) {
      final dragScreen = screens.firstWhere(
        (s) => s.id == _draggingFromScreenId,
      );
      connections.add((transform) {
        return DraggingConnectionPainter(
          transform,
          dragScreen.workflow.position,
          _dragEndPosition!,
          widget.t.textColor.withOpacity(0.5),
        );
      });
    }

    return connections;
  }
}

class ConnectionPainter extends CustomPainter {
  final Matrix4 transform;
  final List<Offset> points;
  final Color color;
  final VoidCallback? onTap;
  static const double nodeWidth = 150;
  static const double nodeHeight = 100;
  final theme th;

  ConnectionPainter(this.transform, this.points, this.color, this.onTap,this.th);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      final startPos = points[i];
      final endPos = points[i + 1];

      final startEdgeWorld = Offset(
        startPos.dx + nodeWidth,
        startPos.dy + nodeHeight / 2,
      );

      final endEdgeWorld = Offset(endPos.dx, endPos.dy + nodeHeight / 2);

      final start = _worldToScreen(startEdgeWorld);
      final end = _worldToScreen(endEdgeWorld);

      final distance = (end.dx - start.dx).abs();
      final controlPointOffset = distance * 0.5;

      final controlPoint1 = Offset(start.dx + controlPointOffset, start.dy);
      final controlPoint2 = Offset(end.dx - controlPointOffset, end.dy);

      final path = Path();
      path.moveTo(start.dx, start.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        end.dx,
        end.dy,
      );

      canvas.drawPath(path, paint);
      // ---- draw settings icon circle on the curve ----
      final t = 0.5; // midpoint of the curve
      Offset bezierPoint(Offset p0, Offset p1, Offset p2, Offset p3, double t) {
        final u = 1 - t;
        return p0 * (u * u * u) +
            p1 * (3 * u * u * t) +
            p2 * (3 * u * t * t) +
            p3 * (t * t * t);
      }

      final center = bezierPoint(start, controlPoint1, controlPoint2, end, t);

      // circle background
      final circlePaint = Paint()..color = th.bgColor;
      canvas.drawCircle(center, 12, circlePaint);


      // draw a gear/settings icon as text (simplest way)
      // draw a gear/settings icon as text (simplest way)
      final icon = HugeIconsSolid.settings01; // Any IconData you want
      final textPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: 20, // size of the icon
            fontFamily: icon.fontFamily,
            package: icon.fontPackage, // important for material icons
            color: th.textColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
    }
  }

  Offset _worldToScreen(Offset worldPoint) {
    final vector = Vector3(worldPoint.dx, worldPoint.dy, 0);
    vector.applyMatrix4(transform);
    return Offset(vector.x, vector.y);
  }

  @override
  bool shouldRepaint(ConnectionPainter old) =>
      old.transform != transform || old.points != points || old.color != color;
}
class DraggingConnectionPainter extends CustomPainter {
  final Matrix4 transform;
  final Offset startWorldPos;
  final Offset endScreenPos;
  final Color color;
  static const double nodeWidth = 150;
  static const double nodeHeight = 100;

  DraggingConnectionPainter(
    this.transform,
    this.startWorldPos,
    this.endScreenPos,
    this.color,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Start from right edge of source node
    final startEdgeWorld = Offset(
      startWorldPos.dx + nodeWidth,
      startWorldPos.dy + nodeHeight / 2,
    );

    final start = _worldToScreen(startEdgeWorld);
    final end = endScreenPos; // Already in screen coordinates

    final distance = (end.dx - start.dx).abs();
    final controlPointOffset = distance * 0.5;

    final controlPoint1 = Offset(start.dx + controlPointOffset, start.dy);
    final controlPoint2 = Offset(end.dx - controlPointOffset, end.dy);

    final path = Path();
    path.moveTo(start.dx, start.dy);
    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      end.dx,
      end.dy,
    );

    canvas.drawPath(path, paint);
  }

  Offset _worldToScreen(Offset worldPoint) {
    final vector = Vector3(worldPoint.dx, worldPoint.dy, 0);
    vector.applyMatrix4(transform);
    return Offset(vector.x, vector.y);
  }

  @override
  bool shouldRepaint(DraggingConnectionPainter old) =>
      old.transform != transform ||
      old.startWorldPos != startWorldPos ||
      old.endScreenPos != endScreenPos;
}
class _GridPainter extends CustomPainter {
  final Matrix4 transform;
  final theme t;

  _GridPainter(this.transform, {required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (t.brightness == Brightness.light)
          ? t.textColor.withOpacity(0.04)
          : t.textColor.withOpacity(0.2)
      ..strokeWidth = 1;

    for (double x = -2000; x <= 2000; x += 30) {
      final start = _worldToScreen(Offset(x, -2000));
      final end = _worldToScreen(Offset(x, 2000));
      if (start.dx >= -100 && start.dx <= size.width + 100) {
        canvas.drawLine(start, end, paint);
      }
    }

    for (double y = -2000; y <= 2000; y += 30) {
      final start = _worldToScreen(Offset(-2000, y));
      final end = _worldToScreen(Offset(2000, y));
      if (start.dy >= -100 && start.dy <= size.height + 100) {
        canvas.drawLine(start, end, paint);
      }
    }
  }

  Offset _worldToScreen(Offset worldPoint) {
    final vector = Vector3(worldPoint.dx, worldPoint.dy, 0);
    vector.applyMatrix4(transform);
    return Offset(vector.x, vector.y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
