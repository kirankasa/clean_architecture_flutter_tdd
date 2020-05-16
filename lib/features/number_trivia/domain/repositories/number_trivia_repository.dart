import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

import 'package:clean_architecture_tdd/core/error/failures.dart';


abstract class NumberTriviaRepository{
  Future<Either<Failure, NumberTrivia>> getConcreteReturnTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}