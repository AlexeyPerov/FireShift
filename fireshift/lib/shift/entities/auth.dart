import 'package:flutter/material.dart';

@immutable
class AppUser {
  const AppUser({
    @required this.uid,
    this.email,
    this.displayName,
  });

  final String uid;
  final String email;
  final String displayName;
}