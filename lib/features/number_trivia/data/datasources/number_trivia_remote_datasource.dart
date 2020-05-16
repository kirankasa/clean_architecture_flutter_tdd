import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTrivia> getConcreteReturnTrivia(int number);
  Future<NumberTrivia> getRandomNumberTrivia();
}
