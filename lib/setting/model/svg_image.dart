class SVGImage {
  const SVGImage({
    required this.width,
    required this.height,
    required this.components,
    required this.boxes,
    required this.valueTexts,
    required this.editable,
  });

  final double width;
  final double height;
  final List<Component> components;
  final List<Box> boxes;
  final List<ValueText> valueTexts;
  final bool editable;
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
    required this.moduleName,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final String moduleName;
  final double x;
  final double y;
  final double width;
  final double height;
}

class ValueText {
  const ValueText({
    required this.moduleName,
    required this.x,
    required this.y,
    required this.text,
    required this.color,
  });

  final String moduleName;
  final double x;
  final double y;
  final String text;
  final String color;
}
