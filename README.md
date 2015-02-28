dart:mirrors patch
--------

This library provides implementations for unimplemented or buggy mirror functionality.

It is expected that these issues will be resolved eventually. At that point this library will be useless.

isSubtypeOf
-----------

Test if an instance of a class is a subtype of a given type.

It appears that the dart2js implementation of ClassMirror.isAssignableTo and associated methods is missing. This means that when compiled to javascript previously working code can fail, throwing an UnimplementedError.

This attempts to call the ClassMirror.isAssignableTo method, and if that fails falls back on a manual approach. The manual approach scans the class hierarchy for an exact match.

invoke
------

Invoke a MethodMirror correctly, handling getters and setters.

Unifies invoking MethodMirror instances no matter what they represent.  Setter and getter methods simulate fields and must be invoked using getField and setField. This hides that detail.

MethodMirror instances for setters are even worse, and cannot even be invoked using the approach of:

    methodOwner.setField(method.simpleName, parameters.first);

This is because the simpleName of the setter includes a trailing =. This means that the declaration lookup fails and the method cannot be invoked.

Creating Symbol instances is intentionally hard. It is difficult to extract the \_name of a Symbol and creating them on the fly is the sort of thing that increases code size (mirrors cannot derive the affected methods). Even with all this, it appears to me that the only way to invoke a setter is to parse the original Symbol and create a new one with the correct value.

This method invokes setters in this way, and all other methods in the usual way.

getSymbolValue
--------------

Get the contained String from a Symbol.

Symbols are used throughout the dart:mirrors api. They do not print cleanly, they are immutable, and they are difficult to manipulate. When creating log messages or invoking derived method names the underlying String of the Symbol is highly desirable. This method captures that String from the Symbol.toString() output.

This relies upon the formatting of the Symbol.toString method. Currently a symbol with a \_name of 'bean' renders as 'Symbol("bean")' This gets the content of the double quotes.
