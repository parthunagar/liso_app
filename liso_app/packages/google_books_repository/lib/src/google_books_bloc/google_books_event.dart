import 'package:equatable/equatable.dart';

abstract class GbooksSearchEvent extends Equatable {
  const GbooksSearchEvent();
}

class TextChanged extends GbooksSearchEvent {
  const TextChanged({required this.text});

  final String text;

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'TextChanged { text: $text }';
}
