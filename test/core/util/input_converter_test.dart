import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter converter;
  setUp(() {
    converter = InputConverter();
  });
  group("stringToUnsignedInt", () {
    test("should return int if input is valid", () {
      final result = converter.stringToUnsignedInteger("1");
      expect(result, equals(Right(1)));
    });

    test("should return a Failure if input is not an integer", () {
      final result = converter.stringToUnsignedInteger("aa");
      expect(result, equals(Left(InvalidInputFailure())));
    });

    test("should return a Failure if input is negative integer", () {
      final result = converter.stringToUnsignedInteger("-1");
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
