import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(this.id, this.mainLibraryId);

  final String id;
  final int mainLibraryId;

  @override
  List<Object> get props => [id, mainLibraryId];

  static const empty = User('-', 2);
}
