import 'package:equatable/equatable.dart';

class StreetIdsQueryResultDto extends Equatable {
  final String name;
  final List<String> ids;

  const StreetIdsQueryResultDto({this.name, this.ids});

  @override
  List<Object> get props => [name, ids];
}
