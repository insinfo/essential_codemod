// ignore: deprecated_member_use
import 'package:analyzer/analyzer.dart';
import 'package:codemod/codemod.dart';
import 'package:source_span/source_span.dart';
import 'scan_class_models.dart';
import 'code_template.dart';
import '../type_definictions/core_types.dart';

class ImplementsJsonSerialization implements Suggestor {
  @override
  bool shouldSkip(String sourceFileContents) {
    return false;
  }

  @override
  Iterable<Patch> generatePatches(SourceFile sourceFile) sync* {
    final contents = sourceFile.getText(0);

    var modelVisitor = ModelClassVisitor();

    var patternStr = modelVisitor.classDeclarationLine;
    final regex = RegExp(
      patternStr,
      multiLine: true,
    );

    final target = StringBuffer();
    target.writeln(patternStr);
    target
        .writeln(CodeTemplate.getInstance().genFromJson(modelVisitor.listProperties, modelVisitor.className));
    target.writeln(CodeTemplate.getInstance().genToJson(modelVisitor.listProperties));

    for (final match in regex.allMatches(contents)) {
      final line = match.group(0);
      //print('isaque group 0 ${match.group(0)}');

      final updated = line.replaceFirst(patternStr, target.toString()) + '\n';
      //print('isaque updated ${updated}');

      yield Patch(
        sourceFile,
        sourceFile.span(match.start, match.end), //match.start, match.end
        updated,
      );
    }
  }
}

class ModelClassVisitor extends GeneralizingAstVisitor {
  //with AstVisitingSuggestorMixin
  bool isConstruct = false;
  bool isMethod = false;
  bool isClassDeclaration = false;
  String classDeclarationLine = '';
  String className = '';
  List<ClassProperty> listProperties = [];
  int offset;
  int end;

  @override
  visitMethodInvocation(MethodInvocation node) {
    final methodName = node.methodName.name;
    final source = node.toSource();
    /*if (node.methodName.name == 'asObservable') {
      yieldPatch(
        node.methodName.offset,
        node.methodName.end,
        'asStream',
      );
    }*/
    //print('visitMethodInvocation $methodName');
    return super.visitMethodInvocation(node);
  }

  @override
  visitArgumentList(ArgumentList node) {
    final propertyName = node.arguments;
    //print('visitArgumentList $propertyName');
    return super.visitArgumentList(node);
  }

  @override
  visitComment(Comment node) {
    //print('visitComment $node');
    return super.visitComment(node);
  }

  @override
  visitAnnotation(Annotation node) {
    //print('visitAnnotation $node');
    return super.visitAnnotation(node);
  }

  @override
  visitAnnotatedNode(AnnotatedNode node) {
    //print('visitAnnotatedNode $node');
    return super.visitAnnotatedNode(node);
  }

  //visita os blocos de fução {}
  @override
  visitBlock(Block node) {
    //print('visitBlock $node');
    return super.visitBlock(node);
  }

  @override
  visitDeclaration(Declaration node) {
    /*if (isClassDeclaration) {
      //yieldPatch(node.offset, node.end, '');
      print(classDeclarationLine);
      print(node.offset);
      print(node.end);
      print(node);
      isClassDeclaration = false;
    }*/
    return super.visitDeclaration(node);
  }

  @override
  visitClassDeclaration(ClassDeclaration node) {
    //listProperties = [];
    print('visitClassDeclaration listProperties $listProperties');

    className = node.name.name;
    var isExistToJson = node.getMethod('toJson');
    isClassDeclaration = true;

    classDeclarationLine = 'class $className';
    if (node.extendsClause != null) {
      classDeclarationLine = '$classDeclarationLine ${node.extendsClause}';
    }
    if (node.withClause != null) {
      classDeclarationLine = '$classDeclarationLine ${node.withClause}';
    }
    if (node.implementsClause != null) {
      classDeclarationLine = '$classDeclarationLine ${node.implementsClause}';
    }

    classDeclarationLine = classDeclarationLine + ' {';

    offset = node.name.offset;
    end = node.name.end;

    /*print('node $node');
    print('className $className');
    print('isExistToJson $isExistToJson');
    print('offset ${node.name.offset}');
    print('end ${node.name.end}');
    print('extendsClause ${node.extendsClause}');
    print('implementsClause ${node.implementsClause}');
    print('withClause ${node.withClause}');*/
    //print('length ${node.length}');
    //print('root ${node.root}');
    //print('parent ${node.parent}');
    //print('findPrevious ${node.findPrevious(node.beginToken)}');

    /*yieldPatch(
        node.name.offset,       
        node.name.end,       
        'test as asdjhasjd',
      );*/
    return super.visitClassDeclaration(node);
  }

  ///get class properties
  @override
  visitClassMember(ClassMember node) {
    //print('visitClassMember $node');
    if (!isConstruct && !isMethod) {
      //remove type anoted
      var name = node.toSource();
      name = name.substring(name.lastIndexOf(RegExp(r'\s+')) + 1);
      name = name.replaceAll(';', '');
      name = name.trim();
      //print('is property ${listProperties}');

      var type = node.toSource().replaceAll('final', '').replaceAll('static', '');
      type = type.substring(0, type.lastIndexOf(RegExp(r'\s+')));
      type = type.trim();
      type = type == '' ? 'dynamic' : type;
      //print("ScanClassModels type: $type:4");

      listProperties.add(ClassProperty(type: type, name: name));

      print('visitClassMember listProperties $listProperties');
    }
    return super.visitClassMember(node);
  }

  @override
  visitConstructorDeclaration(ConstructorDeclaration node) {
    //print('visitConstructorDeclaration $node');
    isConstruct = true;
    return super.visitConstructorDeclaration(node);
  }

  @override
  visitMethodDeclaration(MethodDeclaration node) {
    //print('visitMethodDeclaration $node');
    isMethod = true;
    return super.visitMethodDeclaration(node);
  }
}
