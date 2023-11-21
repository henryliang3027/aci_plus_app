import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_graph_module_bloc/setting18_graph_module_bloc.dart';
import 'package:aci_plus_app/setting/model/setting_wisgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18GraphModuleForm extends StatelessWidget {
  const Setting18GraphModuleForm({
    super.key,
    required this.moduleId,
  });

  final int moduleId;

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.watch<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    String inputAttenuation =
        homeState.characteristicData[DataKey.inputAttenuation] ?? '';
    String inputEqualizer =
        homeState.characteristicData[DataKey.inputEqualizer] ?? '';
    String inputAttenuation2 =
        homeState.characteristicData[DataKey.inputAttenuation2] ?? '';
    String inputAttenuation3 =
        homeState.characteristicData[DataKey.inputAttenuation3] ?? '';
    String inputAttenuation4 =
        homeState.characteristicData[DataKey.inputAttenuation4] ?? '';
    String outputAttenuation =
        homeState.characteristicData[DataKey.outputAttenuation] ?? '';
    String outputEqualizer =
        homeState.characteristicData[DataKey.outputEqualizer] ?? '';
    String ingressSetting2 =
        homeState.characteristicData[DataKey.ingressSetting2] ?? '';
    String ingressSetting3 =
        homeState.characteristicData[DataKey.ingressSetting3] ?? '';
    String ingressSetting4 =
        homeState.characteristicData[DataKey.ingressSetting4] ?? '';
    String tgcCableLength =
        homeState.characteristicData[DataKey.tgcCableLength] ?? '';
    String dsVVA2 = homeState.characteristicData[DataKey.dsVVA2] ?? '';
    String dsSlope2 = homeState.characteristicData[DataKey.dsSlope2] ?? '';
    String dsVVA3 = homeState.characteristicData[DataKey.dsVVA3] ?? '';
    String dsVVA4 = homeState.characteristicData[DataKey.dsVVA4] ?? '';
    String usTGC = homeState.characteristicData[DataKey.usTGC] ?? '';

    context.read<Setting18GraphModuleBloc>().add(Initialized(
          fwdInputAttenuation: inputAttenuation,
          fwdInputEQ: inputEqualizer,
          rtnInputAttenuation2: inputAttenuation2,
          rtnInputAttenuation3: inputAttenuation3,
          rtnInputAttenuation4: inputAttenuation4,
          rtnOutputLevelAttenuation: outputAttenuation,
          rtnOutputEQ: outputEqualizer,
          rtnIngressSetting2: ingressSetting2,
          rtnIngressSetting3: ingressSetting3,
          rtnIngressSetting4: ingressSetting4,
          tgcCableLength: tgcCableLength,
          dsVVA2: dsVVA2,
          dsSlope2: dsSlope2,
          dsVVA3: dsVVA3,
          dsVVA4: dsVVA4,
          usTGC: usTGC,
        ));

    List<Widget> getSettingWidgetByModuleId() {
      switch (moduleId) {
        case 1:
          return [const _FwdInputAttenuation()];

        case 2:
          return [const _FwdInputEQ()];
        case 3:
          return [const _FwdInputEQ()];
        case 4:
          return [const _FwdInputEQ()];
        case 5:
          return [const _FwdInputEQ()];
        case 6:
          return [const _FwdInputEQ()];
        case 7:
          return [const _FwdInputEQ()];
        case 8:
          return [const _FwdInputEQ()];
        case 9:
          return [const _FwdInputEQ()];
        default:
          return [];
      }
    }

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.inputAttenuation.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputAttenuationSetting;
      } else if (item == DataKey.inputEqualizer.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardInputEqualizerSetting;
      } else if (item == DataKey.inputAttenuation2.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation2Setting;
      } else if (item == DataKey.inputAttenuation3.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation3Setting;
      } else if (item == DataKey.inputAttenuation4.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnInputAttenuation4Setting;
      } else if (item == DataKey.outputAttenuation.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnOutputAttenuationSetting;
      } else if (item == DataKey.outputEqualizer.name) {
        return AppLocalizations.of(context)!
            .dialogMessageReturnOutputEqualizerSetting;
      } else if (item == DataKey.ingressSetting2.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress2Setting;
      } else if (item == DataKey.ingressSetting3.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress3Setting;
      } else if (item == DataKey.ingressSetting4.name) {
        return AppLocalizations.of(context)!.dialogMessageReturnIngress4Setting;
      } else if (item == DataKey.tgcCableLength.name) {
        return AppLocalizations.of(context)!.dialogMessageTGCCableLengthSetting;
      } else if (item == DataKey.dsVVA2.name) {
        return AppLocalizations.of(context)!.dialogMessageDSVVA2Setting;
      } else if (item == DataKey.dsSlope2.name) {
        return AppLocalizations.of(context)!.dialogMessageDSSlope2Setting;
      } else if (item == DataKey.dsVVA3.name) {
        return AppLocalizations.of(context)!.dialogMessageDSVVA3Setting;
      } else if (item == DataKey.dsVVA4.name) {
        return AppLocalizations.of(context)!.dialogMessageDSVVA4Setting;
      } else if (item == DataKey.usTGC.name) {
        return AppLocalizations.of(context)!.dialogMessageUSTGCSetting;
      } else {
        return '';
      }
    }

    Color getResultValueColor(String resultValue) {
      return resultValue == 'true' ? Colors.green : Colors.red;
    }

    List<Widget> getMessageRows(List<String> settingResultList) {
      List<Widget> rows = [];
      for (String settingResult in settingResultList) {
        String item = settingResult.split(',')[0];
        String value = settingResult.split(',')[1];
        Color valueColor = getResultValueColor(value);

        rows.add(Padding(
          padding: const EdgeInsets.only(
            bottom: 14.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  formatResultItem(item),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  formatResultValue(value),
                  style: TextStyle(
                    fontSize: 16,
                    color: valueColor,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ));
      }
      return rows;
    }

    return BlocListener<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await showInProgressDialog(context);
        } else if (state.submissionStatus.isSubmissionSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          List<Widget> rows = getMessageRows(state.settingResult);
          showResultDialog(
            context: context,
            messageRows: rows,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...getSettingWidgetByModuleId(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [_SettingFloatingActionButton()],
            ),
          ],
        ),
      ),
    );
  }
}

double _getValue(String value) {
  if (value.isNotEmpty) {
    return double.parse(value);
  } else {
    return 0.0;
  }
}

class _FwdInputAttenuation extends StatelessWidget {
  const _FwdInputAttenuation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: true,
          title:
              '${AppLocalizations.of(context)!.fwdInputAttenuation}: ${state.fwdInputAttenuation} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.fwdInputAttenuation),
          onChanged: (fwdInputAttenuation) {
            context.read<Setting18GraphModuleBloc>().add(
                FwdInputAttenuationChanged(
                    fwdInputAttenuation.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18GraphModuleBloc>()
              .add(const FwdInputAttenuationDecreased()),
          onIncreased: () => context
              .read<Setting18GraphModuleBloc>()
              .add(const FwdInputAttenuationIncreased()),
        );
      },
    );
  }
}

class _FwdInputEQ extends StatelessWidget {
  const _FwdInputEQ({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18GraphModuleBloc, Setting18GraphModuleState>(
      builder: (context, state) {
        return controlParameterSlider(
          context: context,
          editMode: true,
          title:
              '${AppLocalizations.of(context)!.fwdInputEQ}: ${state.fwdInputEQ} dB',
          minValue: 0.0,
          maxValue: 15.0,
          currentValue: _getValue(state.fwdInputEQ),
          onChanged: (fwdInputEQ) {
            context
                .read<Setting18GraphModuleBloc>()
                .add(FwdInputEQChanged(fwdInputEQ.toStringAsFixed(1)));
          },
          onDecreased: () => context
              .read<Setting18GraphModuleBloc>()
              .add(const FwdInputEQDecreased()),
          onIncreased: () => context
              .read<Setting18GraphModuleBloc>()
              .add(const FwdInputEQIncreased()),
        );
      },
    );
  }
}

class _SettingFloatingActionButton extends StatelessWidget {
  const _SettingFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    Widget getEditTools({
      required bool enableSubmission,
    }) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            shape: const CircleBorder(
              side: BorderSide.none,
            ),
            backgroundColor:
                Theme.of(context).colorScheme.primary.withAlpha(200),
            child: Icon(
              CustomIcons.cancel,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              // 重新載入初始設定值
              // context
              //     .read<SettingListViewBloc>()
              //     .add(const Initialized(true));
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          FloatingActionButton(
            shape: const CircleBorder(
              side: BorderSide.none,
            ),
            backgroundColor: enableSubmission
                ? Theme.of(context).colorScheme.primary.withAlpha(200)
                : Colors.grey.withAlpha(200),
            onPressed: enableSubmission
                ? () {
                    context
                        .read<Setting18GraphModuleBloc>()
                        .add(const SettingSubmitted());
                  }
                : null,
            child: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      );
    }

    bool getEditable(FormStatus loadingStatus) {
      if (loadingStatus.isRequestSuccess) {
        return true;
      } else if (loadingStatus.isRequestFailure) {
        return false;
      } else {
        return false;
      }
    }

    // 同時 watch homeState 和 settingListViewState的變化
    // homeState 失去藍芽連線時會變更為不可編輯
    // settingListViewState 管理編輯模式或是觀看模式
    return Builder(builder: (context) {
      final HomeState homeState = context.watch<HomeBloc>().state;
      final Setting18GraphModuleState setting18graphModuleState =
          context.watch<Setting18GraphModuleBloc>().state;

      bool editable = getEditable(homeState.loadingStatus);
      return editable
          ? getEditTools(
              enableSubmission: setting18graphModuleState.enableSubmission,
            )
          : Container();
    });
  }
}
