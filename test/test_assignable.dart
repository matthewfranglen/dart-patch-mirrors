import 'dart:async';
import 'dart:mirrors';
import 'package:patch_mirrors/patch_mirrors.dart';
import 'package:unittest/unittest.dart';

final String nl = "\n     ";

void main() {
  List<Object> objects = [
    new SampleClass(),
    new SampleSubClass(),
    new SampleImplementation(),
    new SampleMixinUser(),
    new SampleExtendedMixinuser(),
    new UnrelatedClass(),
  ];

  for (Object instance in objects) {
    for (Object type in objects) {
      bool expected = testSubtypeOf(instance, type);
      String result = expected ? 'Then the assignment test passes' : 'Then the assignment test fails';

      test('When I test assignment of ${instance.runtimeType} to ${type.runtimeType}${nl} ${result}',
        () => when(testPatchedObjectSubtypeOf(instance, type)).then(matchesIsSubtypeOf(instance, type))
      );
    }
  }
}

typedef dynamic Clause();
typedef void Test(bool result);

Future<dynamic> given(Clause clause) => new Future.value(clause());
Future<dynamic> when(Clause clause) => new Future.value(clause());

class SampleClass {}

class SampleSubClass extends SampleClass {}

class SampleImplementation implements SampleClass {}

class SampleMixinUser extends UnrelatedSuperClass with SampleClass {}

class SampleExtendedMixinuser extends UnrelatedSuperClass with UnrelatedMixin, SampleClass {}

class UnrelatedClass {}

class UnrelatedSuperClass {}

class UnrelatedMixin {}

Clause testPatchedObjectSubtypeOf(Object instance, Object target) =>
  () => isSubtypeOf(toClassMirror(instance), toTypeMirror(target), tryClassMirror: false);

bool testSubtypeOf(Object instance, Object target) =>
  toClassMirror(instance).isSubtypeOf(toTypeMirror(target));

Test matchesIsSubtypeOf(Object instance, Object target) =>
  (bool result) {
    bool expected = testSubtypeOf(instance, target);
    expect(result, equals(expected));
  };

ClassMirror toClassMirror(Object object) => reflectClass(object.runtimeType);

TypeMirror toTypeMirror(Object object) => reflectType(object.runtimeType);

// vim: set ai et sw=2 syntax=dart :
