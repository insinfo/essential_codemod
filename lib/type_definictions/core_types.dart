const PropertyTypes = ['String', 'num', 'int', 'double', 'DateTime ', 'bool', 'List', 'var', 'dynamic'];

class ClassProperty {
  String type;
  String name;
  ClassProperty({this.type, this.name});

  @override
  String toString() {   
    return '{type: $type, name: $name }';
  }
}
