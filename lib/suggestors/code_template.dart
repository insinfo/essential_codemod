import '../type_definictions/core_types.dart';

class CodeTemplate {
  //static CodeTemplate instance;
  static CodeTemplate getInstance() {
    return CodeTemplate();
  }

  String genToJson(List<ClassProperty> listProperties) {
    final _buffer = StringBuffer();
    _buffer.writeln('  Map<String, dynamic> toJson() {');
    _buffer.writeln('    final Map<String, dynamic> json = Map<String, dynamic>();');
    for (var item in listProperties) {
      //id
      if (item.name.trim() == 'id') {
        _buffer.writeln('    if (id != null) {');
        _buffer.writeln("      json['id'] = id;");
        _buffer.writeln('    }');
      } else if (item.type.contains('DateTime')) {
        _buffer.writeln("    json['${item.name}'] = ${item.name}.toString();");
      } else {
        if (!PropertyTypes.contains(item.type)) {
          if (item.type.contains('List<')) {
             var itemType = item.type.replaceAll('List<', '').replaceAll('>', '');
            _buffer.writeln("    json['${item.name}'] = ${item.name}.map(($itemType f) => f.toJson()).toList();");
          } else {
            _buffer.writeln("    json['${item.name}'] = ${item.name}.toJson();");
          }
        } else {
          _buffer.writeln("    json['${item.name}'] = ${item.name};");
        }
      }
    }
    _buffer.writeln('    return json;');
    _buffer.writeln('  }');
    return _buffer.toString();
  }

  String genFromJson(List<ClassProperty> listProperties, String className) {
    final _buffer = StringBuffer();
    //start method
    _buffer.writeln('  $className.fromJson(Map<String, dynamic> json) {');

    _buffer.writeln('    try {');
    for (var item in listProperties) {
      if (item.type.contains('DateTime')) {
        _buffer.writeln(
            "    ${item.name} = json.containsKey('${item.name}') ? DateTime.tryParse(json['${item.name}']) : null;");
      } else {
        if (!PropertyTypes.contains(item.type)) {
          _buffer.writeln("    if (json.containsKey('${item.name}')) {");
          if (item.type.contains('List<')) {
            _buffer.writeln('      ${item.name} = ${item.type}();');
            _buffer.writeln("       json['${item.name}'].forEach((i) {");
            var itemType = item.type.replaceAll('List<', '').replaceAll('>', '');
            _buffer.writeln('        ${item.name}.add($itemType.fromJson(i));');
            _buffer.writeln('      });');
          } else {
            _buffer.writeln("      ${item.name} = ${item.type}.fromJson(json['${item.name}']);");
          }

          _buffer.writeln('    }');
        } else {
          _buffer.writeln("    ${item.name} = json['${item.name}'];");
        }
      }
    }

    //end try  catch
    _buffer.writeln('    } catch (e) {');
    _buffer.writeln("      print('$className@fromJson: \${e}');");
    _buffer.writeln('    }');
    //and method
    _buffer.writeln('  }');
    return _buffer.toString();
  }
}
