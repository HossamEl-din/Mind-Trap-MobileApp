import 'package:grad/widgets/Contest/contest_model.dart';
abstract class ContestEvent {}

class LoadContests extends ContestEvent {}

class FilterByPlatform extends ContestEvent {
  final ContestPlatform? platform; 
  FilterByPlatform(this.platform);
}

class TickTimer extends ContestEvent {}

class RegisterForContest extends ContestEvent {
  final String contestId;
  RegisterForContest(this.contestId);
}

class RemindForContest extends ContestEvent {
  final String contestId;
  RemindForContest(this.contestId);
}
