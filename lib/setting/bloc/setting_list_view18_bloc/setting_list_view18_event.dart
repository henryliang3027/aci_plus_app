part of 'setting_list_view18_bloc.dart';

abstract class SettingListView18Event extends Equatable {
  const SettingListView18Event();

  @override
  List<Object> get props => [];
}

class Initialized extends SettingListView18Event {
  const Initialized(this.isLoadData);

  final bool isLoadData;

  @override
  List<Object> get props => [isLoadData];
}
