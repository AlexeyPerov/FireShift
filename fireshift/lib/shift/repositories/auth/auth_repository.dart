import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fireshift/shift/entities/auth.dart';

abstract class AuthRepository {
  Future initialize();

  Future<Either<AppUser, Error>> authenticate(String login, String password);
}