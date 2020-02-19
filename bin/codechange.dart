import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:args/args.dart';
import 'package:codemod/codemod.dart';
import 'package:essential_codemod/modifiers/scan_class_models.dart';
import 'package:essential_codemod/modifiers/implements_json_serialization.dart';
import 'package:essential_codemod/helpers/file_manager.dart';
import 'package:source_span/source_span.dart';

import 'package:analyzer/analyzer.dart';
import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

void main(List<String> args) {
  var currentDir = '${Directory.current.path}';
  /*const recursive = 'recursive';
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
  

  var visitor = ModelClassVisitor();
  var jsonSeriali = ImplementsJsonSerialization();
  jsonSeriali.modelVisitor = visitor;

  exitCode = runInteractiveCodemodSequence(
    FileQuery.dir(
      path: currentDir,
      pathFilter: isFileSelected,
      recursive: parsed[recursive],
    ),
    [jsonSeriali],
    args: args
        .where((name) => !name.contains(help) && !name.contains(useModelsDir) && !name.contains(recursive))
        .toList(),
  );*/
  var fileManager = FileManager();
  //otem a lista de arquivos .dart do diretorio
  var files = fileManager.dirContentsSync(currentDir, extensionFilter: '.dart');
  if (files != null) {
    //inteirar sobre cada arquivo = Iteração de List<FileSystemEntity>
    for (var file in files) {
      //obtem o caminho do arquivo
      var path = file.uri.toFilePath();
      final sourceText = File(path).readAsStringSync();
      final sourceFile = SourceFile.fromString(sourceText, url: file.uri);
      //print('SourceText: ${sourceFile.getText(0)}');

      var visitor = ModelClassVisitor();
      final compilationUnit = parseCompilationUnit(sourceFile.getText(0));
      compilationUnit.accept(visitor);

      //print('File Properties: ${visitor.listProperties}');

      var jsonSeriali = ImplementsJsonSerialization(visitor);
      var patches = jsonSeriali.generatePatches(sourceFile);
      //print('patches: ${patches}');

      fileManager.applyPatchesAndSave(sourceFile, patches);

      print('Process file: ${path}');
    }
  }
}
