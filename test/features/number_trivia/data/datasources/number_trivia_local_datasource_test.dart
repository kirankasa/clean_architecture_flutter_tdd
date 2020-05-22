import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSource =
        NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group("getLastNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test("should return NumberTriviaModel when there is one in cache",
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
      final result = await numberTriviaLocalDataSource.getLastNumberTrivia();
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));

      expect(result, tNumberTriviaModel);
    });

    test("should throw a CacheException when there is no cached data", () {
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      final call = numberTriviaLocalDataSource.getLastNumberTrivia;
      expect(() => call(), throwsA(isInstanceOf<CacheException>()));
    });
  });

  group("cacheNumberTrivia", () {
    final tNumberTrivia = NumberTriviaModel(number: 1, text: "Test Text");

    test("should call shared preference to cache dat", () {
      numberTriviaLocalDataSource.cacheNumberTrivia(tNumberTrivia);

      final expectedJsonString = json.encode(tNumberTrivia.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
