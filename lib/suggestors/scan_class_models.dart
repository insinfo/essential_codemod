// ignore: deprecated_member_use
import 'package:analyzer/analyzer.dart';
import 'package:codemod/codemod.dart';
import '../type_definictions/core_types.dart';

class ScanClassModels extends GeneralizingAstVisitor with AstVisitingSuggestorMixin {
  String regexMethods =
      r'(?:static\s|private\s|protected\s)?[\s\w]*\s+(?<methodName>\w+)\s*\(\s*(?:(ref\s|\/in\s|out\s)?\s*(?<parameterType>\w+)\s+(?<parameter>\w+)\s*,?\s*)+\)';
  String regexProperties = r'(?:public\s|private\s|protected\s)\s*(?:readonly\s+)?(?<type>\w+)\s+(?<name>\w+)';

  bool isConstruct = false;
  bool isMethod = false;
  static List<ClassProperty> listProperties = [];
  static String className = '';

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

  @override
  visitClassDeclaration(ClassDeclaration node) {
    //print('visitClassDeclaration $node');
    className = node.name.name;
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
