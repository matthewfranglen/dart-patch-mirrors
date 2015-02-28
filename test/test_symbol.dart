import 'dart:async';
import 'dart:mirrors';
import 'package:patch_mirrors/patch_mirrors.dart';
import 'package:unittest/unittest.dart';

final String nl = "\n     ";

void main() {
  test('Given a generated Symbol${nl} When I call getSymbolValue${nl} Then the returned String matches the argument to the Symbol constructor',
    () => given(aGeneratedSymbol).then(getSymbolValue).then(matchesGeneratedConstructorArgument)
  );

  test('Given an existing Symbol${nl} When I call getSymbolValue${nl} Then the returned String matches the known name of the Symbol',
    () => given(anExistingSymbol).then(getSymbolValue).then(matchesExistingSymbolName)
  );
}

typedef dynamic Clause();

Future<dynamic> given(Clause clause) => new Future.value(clause());
Future<dynamic> when(Clause clause) => new Future.value(clause());

Symbol aGeneratedSymbol() => new Symbol('generated');

Symbol anExistingSymbol() => reflectClass(Object).simpleName;

void matchesGeneratedConstructorArgument(String value) {
  expect(value, equals('generated'));
}

void matchesExistingSymbolName(String value) {
  expect(value, equals('Object'));
}

// vim: set ai et sw=2 syntax=dart :
