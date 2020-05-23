import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        "should perform a GET request on a URL with number being the endpoint and with application/json header",
        () {
      setUpMockHttpClientSuccess200();
      dataSource.getConcreteNumberTrivia(tNumber);
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test("should return Number trivia when response code is 200", () async {
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw ServerException when response code is not 200",
        () async {
      setUpMockHttpClientFailure404();
      final call = dataSource.getConcreteNumberTrivia;
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        "should perform a GET request on a URL with random endpoint and with application/json header",
        () {
      setUpMockHttpClientSuccess200();
      dataSource.getRandomNumberTrivia();
      verify(mockHttpClient.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test("should return Number trivia when response code is 200", () async {
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getRandomNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw ServerException when response code is not 200",
        () async {
      setUpMockHttpClientFailure404();
      final call = dataSource.getRandomNumberTrivia;
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
