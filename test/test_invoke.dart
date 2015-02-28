import 'dart:async';
import 'dart:mirrors';
import 'package:patch_mirrors/patch_mirrors.dart';
import 'package:unittest/unittest.dart';

final String nl = "\n     ";

void main() {
  test('When I invoke a getter${nl} Then I get the getter value',
    () => when(invokeGetter).then(matchesGetterValue)
  );

  test('When I invoke a setter${nl} Then I get the provided argument',
    () => when(invokeSetter).then(matchesSetterArgument)
  );

  test('When I invoke a method${nl} Then I get the result of the method call',
    () => when(invokeMethod).then(matchesMethodOutput)
  );
}

typedef dynamic Clause();

Future<dynamic> given(Clause clause) => new Future.value(clause());
Future<dynamic> when(Clause clause) => new Future.value(clause());

class SampleClass {

  String get getter => 'getterValue';

  set setter(String value) {}

  String method() => 'methodValue';
}

String invokeGetter() {
  InstanceMirror mirror = reflect(new SampleClass());
  MethodMirror getter = mirror.type.declarations[new Symbol('getter')];

  return invoke(mirror, getter, []);
}

String invokeSetter() {
  InstanceMirror mirror = reflect(new SampleClass());
  MethodMirror setter = mirror.type.declarations[new Symbol('setter=')];

  return invoke(mirror, setter, ['setterValue']);
}

String invokeMethod() {
  InstanceMirror mirror = reflect(new SampleClass());
  MethodMirror method = mirror.type.declarations[new Symbol('method')];

  return invoke(mirror, method, []);
}

void matchesGetterValue(String value) {
  expect(value, equals('getterValue'));
}

void matchesSetterArgument(String value) {
  expect(value, equals('setterValue'));
}

void matchesMethodOutput(String value) {
  expect(value, equals('methodValue'));
}

// vim: set ai et sw=2 syntax=dart :
