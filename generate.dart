import 'dart:io';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

Future main() async {
  const analyzerConfig = '''
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: true
  errors:
    flutter_style_todos: ignore
''';
  final body = (await http.get(
    'https://raw.githubusercontent.com/dart-lang/linter/gh-pages/lints/options/options.html',
  ))
      .body;
  final document = parse(body);
  final removedRules = [
    'always_specify_types',
    'always_use_package_imports',
    'avoid_annotating_with_dynamic',
    'avoid_as',
    'avoid_classes_with_only_static_members',
    'avoid_positional_boolean_parameters',
    'avoid_print',
    'lines_longer_than_80_chars',
    'omit_local_variable_types',
    'prefer_double_quotes',
    'prefer_relative_imports',
    'unnecessary_final',
    'unnecessary_null_checks',
  ].map((line) => '    - $line').toList();
  final linterConfig = document
      .getElementsByTagName('code')[0]
      .text
      .split('\n')
      .where((line) => !removedRules.contains(line))
      .join('\n');
  File('analysis_options.yaml')
      .writeAsStringSync('$linterConfig\n$analyzerConfig');
}
