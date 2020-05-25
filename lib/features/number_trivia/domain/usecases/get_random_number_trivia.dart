import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository numberTriviaRepository;

  GetRandomNumberTrivia({@required this.numberTriviaRepository});

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}
