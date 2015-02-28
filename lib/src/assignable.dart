part of patch_mirrors;

/// Test if an instance of a class can be assigned to a variable of a given type.
///
/// It appears that the dart2js implementation of [ClassMirror.isAssignableTo]
/// and associated methods is missing. This means that when compiled to
/// javascript previously working code can fail, throwing an
/// [UnimplementedError].
///
/// This attempts to call the [ClassMirror.isAssignableTo] method, and if that
/// fails falls back on a manual approach. The manual approach scans the class
/// hierarchy for an exact match.
bool isAssignableTo(TypeMirror target, ClassMirror instance, {bool tryClassMirror: true}) {
  if (tryClassMirror) {
    try {
      return instance.isAssignableTo(target);
    }
    catch (exception) {}
  }
  return _isAssignableTo(target, instance);
}

bool _isAssignableTo(TypeMirror target, ClassMirror instance) =>
  _isTypeMatch(target, instance)
  || _isSuperClassMatch(target, instance)
  || _isSuperInterfaceMatch(target, instance);

bool _isTypeMatch(TypeMirror target, ClassMirror instance) =>
  target.qualifiedName == instance.originalDeclaration.qualifiedName;

bool _isSuperClassMatch(TypeMirror target, ClassMirror instance) =>
  instance.superclass != null && _isAssignableTo(target, instance.superclass);

bool _isSuperInterfaceMatch(TypeMirror target, ClassMirror instance) =>
  instance.superinterfaces.any(_isAssignableToFilter(target));

_AssignableFilter _isAssignableToFilter(TypeMirror target) =>
  (ClassMirror instance) => _isAssignableTo(target, instance);

typedef bool _AssignableFilter(ClassMirror instance);

// vim: set ai et sw=2 syntax=dart :
