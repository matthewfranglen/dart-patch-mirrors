part of patch_mirrors;

/// Test if an instance of a class is a subtype of a given type.
///
/// It appears that the dart2js implementation of [ClassMirror.isAssignableTo]
/// and [ClassMirror.isSubtypeOf] is missing. This means that when compiled to
/// javascript previously working code can fail, throwing an
/// [UnimplementedError].
///
/// This attempts to call the [ClassMirror.isSubtypeOf] method, and if that
/// fails falls back on a manual approach. The manual approach scans the class
/// hierarchy for an exact match.
bool isSubtypeOf(ClassMirror instance, TypeMirror target, {bool tryClassMirror: true}) {
  if (tryClassMirror) {
    try {
      return instance.isSubtypeOf(target);
    }
    catch (exception) {}
  }
  return _isAssignableTo(instance, target);
}

bool _isAssignableTo(ClassMirror instance, TypeMirror target) =>
  _isTypeMatch(instance, target)
  || _isSuperClassMatch(instance, target)
  || _isSuperInterfaceMatch(instance, target);

bool _isTypeMatch(ClassMirror instance, TypeMirror target) =>
  target.qualifiedName == instance.originalDeclaration.qualifiedName;

bool _isSuperClassMatch(ClassMirror instance, TypeMirror target) =>
  instance.superclass != null && _isAssignableTo(instance.superclass, target);

bool _isSuperInterfaceMatch(ClassMirror instance, TypeMirror target) =>
  instance.superinterfaces.any(_isAssignableToFilter(target));

_AssignableFilter _isAssignableToFilter(TypeMirror target) =>
  (ClassMirror instance) => _isAssignableTo(instance, target);

typedef bool _AssignableFilter(ClassMirror instance);

// vim: set ai et sw=2 syntax=dart :
