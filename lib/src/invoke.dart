part of patch_mirrors;

/// Invoke a [MethodMirror] correctly, handling getters and setters.
///
/// Unifies invoking [MethodMirror] instances no matter what they represent.
/// Setter and getter methods simulate fields and must be invoked using
/// getField and setField. This hides that detail.
///
/// [MethodMirror] instances for setters are even worse, and cannot even be invoked using the
/// approach of:
///
///     methodOwner.setField(method.simpleName, parameters.first);
///
/// This is because the simpleName of the setter includes a trailing =. This
/// means that the declaration lookup fails and the method cannot be invoked.
///
/// Creating [Symbol] instances is intentionally hard. It is difficult to
/// extract the _name of a [Symbol] and creating them on the fly is the sort of
/// thing that increases code size (mirrors cannot derive the affected
/// methods). Even with all this, it appears to me that the only way to invoke
/// a setter is to parse the original [Symbol] and create a new one with the
/// correct value.
///
/// This method invokes setters in this way, and all other methods in the usual
/// way.
dynamic invoke(InstanceMirror owner, MethodMirror method, List<dynamic> parameters) {
  if (method.isSetter) {
    return _invokeSetter(owner, method, parameters.first);
  }
  if (method.isGetter) {
    return _invokeGetter(owner, method);
  }
  return _invoke(owner, method, parameters);
}

dynamic _invoke(InstanceMirror owner, MethodMirror method, List<dynamic> parameters) =>
  owner.invoke(method.simpleName, parameters).reflectee;

dynamic _invokeGetter(InstanceMirror owner, MethodMirror method) =>
  owner.getField(method.simpleName).reflectee;

dynamic _invokeSetter(InstanceMirror owner, MethodMirror method, dynamic parameter) =>
  owner.setField(_deriveFieldName(method), parameter).reflectee;

// This is a horrible hack that relies upon the formatting of the Symbol.toString()
// It reads the setter name from that, strips the Symbol.toString formatting,
// and then strips the final character. This takes it from a string like:
//   Symbol("bean=")
// to:
//   bean
Symbol _deriveFieldName(MethodMirror method) {
  String rawSetterName = getSymbolValue(method.simpleName);
  String setterName = rawSetterName.substring(0, rawSetterName.length - 1);
  return new Symbol(setterName);
}

// vim: set ai et sw=2 syntax=dart :
