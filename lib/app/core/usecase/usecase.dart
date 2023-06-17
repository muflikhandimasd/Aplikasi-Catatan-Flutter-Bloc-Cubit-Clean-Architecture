import 'package:dartz/dartz.dart';

import '../../app.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
