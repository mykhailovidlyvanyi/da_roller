//lib/widgets/dice/dice_3d.dart

import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart' show rootBundle;
import 'package:material_ui/material_ui.dart';

import '../../models/dice_skin.dart';
import '../../services/dice_service.dart';

class Dice3D extends StatefulWidget {
  final DiceSkin skin;
  final double size;
  final DiceService diceService;
  final VoidCallback? onRollStart;
  final ValueChanged<int>? onRollComplete;

  const Dice3D({
    super.key,
    this.skin = DiceSkin.classic,
    this.size = 220,
    required this.diceService,
    this.onRollStart,
    this.onRollComplete,
  });

  @override
  Dice3DState createState() => Dice3DState();
}

class Dice3DState extends State<Dice3D> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  ui.Image? _oneFaceImage;
  String? _loadedImagePath;

  double _currentX = 0;
  double _currentY = 0;

  double _fromX = 0;
  double _fromY = 0;

  double _toX = 0;
  double _toY = 0;

  bool _isRolling = false;

  static const double _tau = pi * 2;

  bool get isRolling => _isRolling;

  double get _rotationX {
    final t = Curves.easeOutCubic.transform(_controller.value);
    return _fromX + (_toX - _fromX) * t;
  }

  double get _rotationY {
    final t = Curves.easeOutCubic.transform(_controller.value);
    return _fromY + (_toY - _fromY) * t;
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentX = _toX;
        _currentY = _toY;
        _isRolling = false;
      }
    });

    _loadOneFaceImage();
  }

  @override
  void didUpdateWidget(covariant Dice3D oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.skin.oneFaceImage != widget.skin.oneFaceImage) {
      _loadOneFaceImage();
    }
  }

  Future<void> _loadOneFaceImage() async {
    final imagePath = widget.skin.oneFaceImage;

    if (imagePath == null) {
      _loadedImagePath = null;

      _oneFaceImage?.dispose();
      _oneFaceImage = null;

      if (mounted) setState(() {});
      return;
    }

    if (_loadedImagePath == imagePath) return;

    _loadedImagePath = imagePath;

    _oneFaceImage?.dispose();
    _oneFaceImage = null;

    try {
      final data = await rootBundle.load(imagePath);

      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      codec.dispose();

      if (!mounted || widget.skin.oneFaceImage != imagePath) {
        frame.image.dispose();
        return;
      }

      setState(() {
        _oneFaceImage = frame.image;
      });
    } catch (error) {
      debugPrint('[Dice3D] Failed to load image $imagePath: $error');
    }
  }

  double _rotationDelta(double current, double target) {
    final difference = (target - current) % _tau;
    final positiveDifference = (difference + _tau) % _tau;

    return positiveDifference + _tau * 3;
  }

  void roll() {
    if (_isRolling) return;

    final result = widget.diceService.roll();

    double targetX = 0;
    double targetY = 0;

    switch (result) {
      case 1:
        break;
      case 2:
        targetX = pi / 2;
        break;
      case 3:
        targetY = -pi / 2;
        break;
      case 4:
        targetY = pi / 2;
        break;
      case 5:
        targetX = -pi / 2;
        break;
      case 6:
        targetY = pi;
        break;
    }

    _fromX = _currentX;
    _fromY = _currentY;

    _toX = _currentX + _rotationDelta(_currentX, targetX);
    _toY = _currentY + _rotationDelta(_currentY, targetY);

    _isRolling = true;

    widget.onRollStart?.call();

    _controller.forward(from: 0).then((_) {
      if (!mounted) return;
      widget.onRollComplete?.call(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 1.6,
      height: widget.size * 1.6,
      child: Center(
        child: CustomPaint(
          size: Size.square(widget.size),
          painter: _DicePainter(
            skin: widget.skin,
            rotationX: _rotationX,
            rotationY: _rotationY,
            oneFaceImage: _oneFaceImage,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _oneFaceImage?.dispose();
    super.dispose();
  }
}

class _Vector3 {
  final double x;
  final double y;
  final double z;

  const _Vector3(this.x, this.y, this.z);

  _Vector3 operator +(_Vector3 other) =>
      _Vector3(x + other.x, y + other.y, z + other.z);

  _Vector3 operator -(_Vector3 other) =>
      _Vector3(x - other.x, y - other.y, z - other.z);

  _Vector3 operator *(double value) =>
      _Vector3(x * value, y * value, z * value);
}

class _DiceFaceData {
  final int value;
  final _Vector3 center;
  final _Vector3 right;
  final _Vector3 up;
  final _Vector3 normal;

  const _DiceFaceData({
    required this.value,
    required this.center,
    required this.right,
    required this.up,
    required this.normal,
  });
}

class _DicePainter extends CustomPainter {
  final DiceSkin skin;
  final double rotationX;
  final double rotationY;
  final ui.Image? oneFaceImage;

  _DicePainter({
    required this.skin,
    required this.rotationX,
    required this.rotationY,
    required this.oneFaceImage,
  });

  static const double _cameraDistance = 5;
  static const double _cubeHalfSize = 0.85;

  static const List<_DiceFaceData> _faces = [
    _DiceFaceData(
      value: 1,
      center: _Vector3(0, 0, 1),
      right: _Vector3(1, 0, 0),
      up: _Vector3(0, 1, 0),
      normal: _Vector3(0, 0, 1),
    ),
    _DiceFaceData(
      value: 6,
      center: _Vector3(0, 0, -1),
      right: _Vector3(-1, 0, 0),
      up: _Vector3(0, 1, 0),
      normal: _Vector3(0, 0, -1),
    ),
    _DiceFaceData(
      value: 3,
      center: _Vector3(1, 0, 0),
      right: _Vector3(0, 0, -1),
      up: _Vector3(0, 1, 0),
      normal: _Vector3(1, 0, 0),
    ),
    _DiceFaceData(
      value: 4,
      center: _Vector3(-1, 0, 0),
      right: _Vector3(0, 0, 1),
      up: _Vector3(0, 1, 0),
      normal: _Vector3(-1, 0, 0),
    ),
    _DiceFaceData(
      value: 2,
      center: _Vector3(0, 1, 0),
      right: _Vector3(1, 0, 0),
      up: _Vector3(0, 0, -1),
      normal: _Vector3(0, 1, 0),
    ),
    _DiceFaceData(
      value: 5,
      center: _Vector3(0, -1, 0),
      right: _Vector3(1, 0, 0),
      up: _Vector3(0, 0, 1),
      normal: _Vector3(0, -1, 0),
    ),
  ];

  static const Map<int, List<Offset>> _pipPositions = {
    1: [Offset(0.5, 0.5)],
    2: [Offset(0.25, 0.25), Offset(0.75, 0.75)],
    3: [Offset(0.25, 0.25), Offset(0.5, 0.5), Offset(0.75, 0.75)],
    4: [
      Offset(0.25, 0.25),
      Offset(0.75, 0.25),
      Offset(0.25, 0.75),
      Offset(0.75, 0.75),
    ],
    5: [
      Offset(0.25, 0.25),
      Offset(0.75, 0.25),
      Offset(0.5, 0.5),
      Offset(0.25, 0.75),
      Offset(0.75, 0.75),
    ],
    6: [
      Offset(0.25, 0.2),
      Offset(0.75, 0.2),
      Offset(0.25, 0.5),
      Offset(0.75, 0.5),
      Offset(0.25, 0.8),
      Offset(0.75, 0.8),
    ],
  };

  _Vector3 _rotate(_Vector3 point) {
    final cosX = cos(rotationX);
    final sinX = sin(rotationX);

    final y1 = point.y * cosX - point.z * sinX;
    final z1 = point.y * sinX + point.z * cosX;

    final cosY = cos(rotationY);
    final sinY = sin(rotationY);

    final x2 = point.x * cosY + z1 * sinY;
    final z2 = -point.x * sinY + z1 * cosY;

    return _Vector3(x2, y1, z2);
  }

  Offset _project(_Vector3 point, Size size) {
    final rotated = _rotate(point);

    final perspective = _cameraDistance / (_cameraDistance - rotated.z);

    final scale = size.width * 0.42;

    return Offset(
      size.width / 2 + rotated.x * scale * perspective,
      size.height / 2 - rotated.y * scale * perspective,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final visibleFaces =
        _faces
            .map((face) {
              final rotatedNormal = _rotate(face.normal);
              final rotatedCenter = _rotate(face.center);

              return (
                face: face,
                normal: rotatedNormal,
                depth: rotatedCenter.z,
              );
            })
            .where((item) => item.normal.z > 0.001)
            .toList()
          ..sort((a, b) => a.depth.compareTo(b.depth));

    for (final item in visibleFaces) {
      _paintFace(canvas, size, item.face);
    }
  }

  void _paintFace(Canvas canvas, Size size, _DiceFaceData face) {
    final center = face.center * _cubeHalfSize;
    final right = face.right * _cubeHalfSize;
    final up = face.up * _cubeHalfSize;

    final corners = [
      center - right - up,
      center + right - up,
      center + right + up,
      center - right + up,
    ];

    final outerPath = Path()
      ..moveTo(_project(corners[0], size).dx, _project(corners[0], size).dy);

    for (var i = 1; i < corners.length; i++) {
      final point = _project(corners[i], size);
      outerPath.lineTo(point.dx, point.dy);
    }

    outerPath.close();

    canvas.drawPath(
      outerPath,
      Paint()
        ..color = skin.edgeColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true,
    );

    final innerPath = _buildRoundedFacePath(
      size: size,
      center: center,
      right: right,
      up: up,
      inset: 0.93,
      cornerRadius: 0.10,
    );

    canvas.drawPath(
      innerPath,
      Paint()
        ..color = skin.faceColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true,
    );

    if (face.value == 1 && skin.oneFaceImage != null && oneFaceImage != null) {
      _paintFaceImage(
        canvas,
        size,
        center,
        right,
        up,
        innerPath,
        oneFaceImage!,
      );
    } else {
      _paintPips(canvas, size, face, center, right, up);
    }
  }

  void _paintFaceImage(
    Canvas canvas,
    Size size,
    _Vector3 center,
    _Vector3 right,
    _Vector3 up,
    Path clipPath,
    ui.Image image,
  ) {
    // Image width remains 58% of the face.
    const maxImageScale = 0.58;
    final aspectRatio = image.width / image.height;

    final maxWidth = _cubeHalfSize * maxImageScale * 2;
    final maxHeight = _cubeHalfSize * maxImageScale * 2;

    final imageWidth = aspectRatio >= 1 ? maxWidth : maxHeight * aspectRatio;

    final imageHeight = imageWidth / aspectRatio;

    final halfWidth = imageWidth / 2;
    final halfHeight = imageHeight / 2;

    final imageCorners = [
      center - right * halfWidth - up * halfHeight,
      center + right * halfWidth - up * halfHeight,
      center + right * halfWidth + up * halfHeight,
      center - right * halfWidth + up * halfHeight,
    ];

    final positions = imageCorners
        .map((point) => _project(point, size))
        .toList();

    final textureCoordinates = [
      Offset(0, image.height.toDouble()),
      Offset(image.width.toDouble(), image.height.toDouble()),
      Offset(image.width.toDouble(), 0),
      Offset(0, 0),
    ];

    final vertices = ui.Vertices(
      ui.VertexMode.triangles,
      positions,
      textureCoordinates: textureCoordinates,
      indices: [0, 1, 2, 0, 2, 3],
    );

    final shader = ui.ImageShader(
      image,
      ui.TileMode.clamp,
      ui.TileMode.clamp,
      Float64List.fromList([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]),
    );

    canvas.save();
    canvas.clipPath(clipPath);

    canvas.drawVertices(
      vertices,
      BlendMode.srcOver,
      Paint()
        ..shader = shader
        ..isAntiAlias = true,
    );

    canvas.restore();

    vertices.dispose();
    shader.dispose();
  }

  Path _buildRoundedFacePath({
    required Size size,
    required _Vector3 center,
    required _Vector3 right,
    required _Vector3 up,
    required double inset,
    required double cornerRadius,
  }) {
    final half = _cubeHalfSize * inset;
    final radius = half * cornerRadius;

    Offset project(double x, double y) {
      final point = center + right * x + up * y;
      return _project(point, size);
    }

    final topLeft = project(-half, half);
    final topRight = project(half, half);
    final bottomRight = project(half, -half);
    final bottomLeft = project(-half, -half);

    final path = Path();

    path.moveTo(
      project(-half + radius, half).dx,
      project(-half + radius, half).dy,
    );

    path.lineTo(
      project(half - radius, half).dx,
      project(half - radius, half).dy,
    );

    path.quadraticBezierTo(
      topRight.dx,
      topRight.dy,
      project(half, half - radius).dx,
      project(half, half - radius).dy,
    );

    path.lineTo(
      project(half, -half + radius).dx,
      project(half, -half + radius).dy,
    );

    path.quadraticBezierTo(
      bottomRight.dx,
      bottomRight.dy,
      project(half - radius, -half).dx,
      project(half - radius, -half).dy,
    );

    path.lineTo(
      project(-half + radius, -half).dx,
      project(-half + radius, -half).dy,
    );

    path.quadraticBezierTo(
      bottomLeft.dx,
      bottomLeft.dy,
      project(-half, -half + radius).dx,
      project(-half, -half + radius).dy,
    );

    path.lineTo(
      project(-half, half - radius).dx,
      project(-half, half - radius).dy,
    );

    path.quadraticBezierTo(
      topLeft.dx,
      topLeft.dy,
      project(-half + radius, half).dx,
      project(-half + radius, half).dy,
    );

    path.close();
    return path;
  }

  void _paintPips(
    Canvas canvas,
    Size size,
    _DiceFaceData face,
    _Vector3 center,
    _Vector3 right,
    _Vector3 up,
  ) {
    final positions = _pipPositions[face.value]!;

    final pipPaint = Paint()
      ..color = skin.pipColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final radius = size.width * 0.050;

    for (final position in positions) {
      final horizontal = (position.dx - 0.5) * 2;
      final vertical = (0.5 - position.dy) * 2;

      final point =
          center +
          right * (horizontal * _cubeHalfSize * 0.93) +
          up * (vertical * _cubeHalfSize * 0.93);

      canvas.drawCircle(_project(point, size), radius, pipPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DicePainter oldDelegate) {
    return oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.skin != skin ||
        oldDelegate.oneFaceImage != oneFaceImage;
  }
}
