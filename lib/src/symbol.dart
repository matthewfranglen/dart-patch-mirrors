part of patch_mirrors;

/// Get the contained [String] from a [Symbol].
///
/// Symbols are used throughout the dart:mirrors api. They do not print
/// cleanly, they are immutable, and they are difficult to manipulate.
/// When creating log messages or invoking derived method names the underlying
/// [String] of the [Symbol] is highly desirable. This method captures that
/// [String] from the [Symbol.toString()] output.
///
/// This relies upon the formatting of the Symbol.toString method.
/// Currently a symbol with a _name of 'bean' renders as 'Symbol("bean")'
/// This gets the content of the double quotes.
String getSymbolValue(Symbol symbol) =>
  symbol.toString().split('"')[1];

// vim: set ai et sw=2 syntax=dart :
