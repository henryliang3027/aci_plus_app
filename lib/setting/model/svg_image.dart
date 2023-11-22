class SVGImage {
  const SVGImage({
    required this.width,
    required this.height,
    required this.components,
    required this.boxes,
  });

  final double width;
  final double height;
  final List<Component> components;
  final List<Box> boxes;
}

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
    required this.moduleId,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final int moduleId;
  final double x;
  final double y;
  final double width;
  final double height;
}
