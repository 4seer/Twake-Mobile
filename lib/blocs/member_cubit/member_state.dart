import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:twake/models/member.dart';

abstract class MemberState extends Equatable {
  const MemberState();
}

class MemberInitial extends MemberState {
  @override
  List<Object> get props => [];
}

class MembersLoaded extends MemberState {
  final List<Member> members;

  MembersLoaded({@required this.members});

  @override
  List<Object> get props => [members];
}

class MembersUpdated extends MemberState {
  final String channelId;
  final List<String> members;

  MembersUpdated({@required this.channelId, @required this.members});

  @override
  List<Object> get props => [channelId, members];
}