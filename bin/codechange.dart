import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:args/args.dart';
import 'package:codemod/codemod.dart';
import 'package:essential_codemod/suggestors/scan_class_models.dart';
import 'package:essential_codemod/suggestors/implements_json_serialization.dart';

bool isFileSelected(String filePath) {
  //print('isFileSelected $filePath');
  return path.extension(filePath) == '.dart';
}

void main(List<String> args) {
  /*String patternStr = 'class Pessoa {';
  final regex = RegExp(
    patternStr,
    multiLine: true,
  );
  var contents = '''
    class Pessoa {
  var semTipo;
  String nome;
  String telefone;
  int idade;
  DateTime nascimento;
  final dynamic test;
  Pessoa(this.test);
  int calcIdade(int nasc) {
    return 1;
  }
  calc() {}
}
     ''';
  for (final match in regex.allMatches(contents)) {
    final line = match.group(0);
    print("isaque group 0 ${match.group(0)}");
    final updated = line.replaceFirst(patternStr, 'Isaque') + '\n';
    print("isaque updated ${updated}");
  }*/

  const recursive = 'recursive';
  const modelsDir = 'modelsdir';
  const help = 'help';

  final parser = ArgParser()
    ..addFlag(
      recursive,
      help: 'Apply updates to Dart files in the current directory recursive',
      defaultsTo: false,
    )
    ..addFlag(
      modelsDir,
      help: 'Set directory of models class files',
      defaultsTo: false,
    )
    ..addFlag(
      help,
      abbr: 'h',
      help: 'Prints the help menu',
      defaultsTo: false,
      negatable: false,
    );

  final parsed = parser.parse(args);

  if (parsed[help]) {
    print('''This script will update code''');
    return print(parser.usage);
  }

  final useModelsDir = parsed[modelsDir];
  //print(useModelsDir);
  var currentDir = '${Directory.current.path}';

  var visitor = ModelClassVisitor();
  var jsonSeriali = ImplementsJsonSerialization();
  jsonSeriali.modelVisitor = visitor;

  exitCode = runInteractiveCodemodSequence(
    FileQuery.dir(
      path: currentDir,
      pathFilter: isFileSelected,
      recursive: parsed[recursive],
    ),
    [visitor, jsonSeriali],
    args: args
        .where((name) => !name.contains(help) && !name.contains(useModelsDir) && !name.contains(recursive))
        .toList(),
  );
}
