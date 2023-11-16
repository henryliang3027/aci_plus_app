class Component {
  const Component({
    required this.color,
    required this.path,
  });

  final String color;
  final String path;
}

class Box {
  const Box({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final double x;
  final double y;
  final double width;
  final double height;
}
