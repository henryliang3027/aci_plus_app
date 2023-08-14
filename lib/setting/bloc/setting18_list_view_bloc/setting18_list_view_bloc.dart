import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_list_view_event.dart';
part 'setting18_list_view_state.dart';

class Setting18ListViewBloc
    extends Bloc<Setting18ListViewEvent, Setting18ListViewState> {
  Setting18ListViewBloc({required DsimRepository dsimRepository})
      : _dsimRepository = dsimRepository,
        super(const Setting18ListViewState()) {
    on<Initialized>(_onInitialized);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final DsimRepository _dsimRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18ListViewState> emit,
  ) async {}

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: false,
      enableSubmission: false,
    ));
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18ListViewState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));
  }
}
