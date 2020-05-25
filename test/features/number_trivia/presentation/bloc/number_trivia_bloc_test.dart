import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {
}

class MockRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  GetConcreteNumberTrivia mockConcreteNumberTrivia;
  GetRandomNumberTrivia mockRandomNumberTrivia;
  InputConverter mockInputConverter;
  setUp(() {
    mockConcreteNumberTrivia = MockConcreteNumberTrivia();
    mockRandomNumberTrivia = MockRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concreteNumberTrivia: mockConcreteNumberTrivia,
        randomNumberTrivia: mockRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test("initial state should be empty", () {
    expect(bloc.initialState, Empty());
  });

  group("getTriviaForConcreteNumber", () {
    final tNumberString = "1";
    final tNumber = 1;
    final tNumberTrivia = NumberTrivia(text: "Test Text", number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumber));

    test(
        "should call mockInputConverter to validate and convert the string to unsigned integer",
        () async {
      setUpMockInputConverterSuccess();
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test("should emit [Error] when input is invalid", () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      expectLater(
          bloc.state,
          emitsInOrder(
              [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)]));
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test("should get data from concrete use case ", () async {
      setUpMockInputConverterSuccess();
      when(mockConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockConcreteNumberTrivia(any));
      verify(mockConcreteNumberTrivia(Params(number: tNumber)));
    });

    test("should emit [Loading, Loaded] when data is gotten successfully ",
        () async {
      setUpMockInputConverterSuccess();
      when(mockConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      expectLater(bloc.state,
          emitsInOrder([Empty(), Loading(), Loaded(trivia: tNumberTrivia)]));
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        "should emit [Loading, Error] when there is failure in retrieving data",
        () async {
      setUpMockInputConverterSuccess();
      when(mockConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      expectLater(
          bloc.state,
          emitsInOrder(
              [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)]));
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        "should emit [Loading, Error] when there is failure in retrieving cached data",
        () async {
      setUpMockInputConverterSuccess();
      when(mockConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      expectLater(
          bloc.state,
          emitsInOrder(
              [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE)]));
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group("getTriviaForRandomNumber", () {
    final tNumberTrivia = NumberTrivia(text: "Test Text", number: 1);

    test("should get data from random use case ", () async {
      when(mockRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      bloc.dispatch(GetTriviaForRandomNumber());
      await untilCalled(mockRandomNumberTrivia(any));
      verify(mockRandomNumberTrivia(NoParams()));
    });

    test("should emit [Loading, Loaded] when data is gotten successfully ",
        () async {
      when(mockRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      expectLater(bloc.state,
          emitsInOrder([Empty(), Loading(), Loaded(trivia: tNumberTrivia)]));
      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test(
        "should emit [Loading, Error] when there is failure in retrieving data",
        () async {
      when(mockRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      expectLater(
          bloc.state,
          emitsInOrder(
              [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)]));
      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test(
        "should emit [Loading, Error] when there is failure in retrieving cached data",
        () async {
      when(mockRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      expectLater(
          bloc.state,
          emitsInOrder(
              [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE)]));
      bloc.dispatch(GetTriviaForRandomNumber());
    });
  });
}
