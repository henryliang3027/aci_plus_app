import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/pulsator.dart';
import 'package:aci_plus_app/core/setup_wizard_dialog.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/alarm_description_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeBottomNavigationBar18 extends StatelessWidget {
  const HomeBottomNavigationBar18({
    Key? key,
    required this.selectedIndex,
    required this.pageController,
    required this.onTap,
    this.enableTap = true,
  }) : super(key: key);

  final int selectedIndex;
  final PageController pageController;
  final ValueChanged<int> onTap;
  final bool enableTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10, // Adds shadow and elevation

      margin: const EdgeInsets.all(0), // Optional padding around the card
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.zero,
        ),
      ),
      color: Theme.of(context).bottomAppBarTheme.color,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).bottomAppBarTheme.color,
            ),
            child: const Indicator(),
          ),
          BottomNavigationBar(
            elevation: 0,
            // backgroundColor: Theme.of(context).bottomAppBarTheme.color,
            backgroundColor: Colors.transparent,

            type: BottomNavigationBarType.fixed,

            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.setting),
                label: 'Setting',
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.status),
                label: 'Status',
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.home),
                label: 'Information',
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.chart),
                label: 'Chart',
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.advanced),
                label: 'About',
                tooltip: '',
              ),
            ],
            //unselected icon size CustomStyle.size24
            currentIndex: selectedIndex,
            selectedIconTheme: const IconThemeData(size: CustomStyle.size36),
            selectedFontSize: 0.0,
            selectedItemColor:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            onTap: enableTap ? onTap : null,
          ),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // alarmState (alarm mask) == '0' 代表 enable
    // alarmState (alarm mask) == '1' 代表 disable
    Alarm getSeverity(String alarmState, String alarmSeverity) {
      if (alarmState == '0') {
        if (alarmSeverity == Alarm.success.name) {
          return Alarm.success;
        } else if (alarmSeverity == Alarm.danger.name) {
          return Alarm.danger;
        } else {
          //  Alarm.medium
          return Alarm.success;
        }
      } else {
        // alarmState == '1'
        return Alarm.success;
      }
    }

    // alarmState (alarm mask) == '0' 代表 enable
    // alarmState (alarm mask) == '1' 代表 disable
    List<int> getAmpUnitStatusAlarmSeverityIndexList({
      required String temperatureAlarmState,
      required String voltageAlarmState,
      required String voltageRippleAlarmState,
      required String rfOutputPowerAlarmState,
      required String rfOutputPilotLowFrequencyAlarmState,
      required String rfOutputPilotHighFrequencyAlarmState,
      required String temperatureAlarmSeverity,
      required String voltageAlarmSeverity,
      required String voltageRippleAlarmSeverity,
      required String rfOutputPowerAlarmSeverity,
      required String rfOutputPilotLowFrequencyAlarmSeverity,
      required String rfOutputPilotHighFrequencyAlarmSeverity,
    }) {
      List<Alarm> severityList = [
        getSeverity(temperatureAlarmState, temperatureAlarmSeverity),
        getSeverity(voltageAlarmState, voltageAlarmSeverity),
        getSeverity(voltageRippleAlarmState, voltageRippleAlarmSeverity),
        getSeverity(rfOutputPowerAlarmState, rfOutputPowerAlarmSeverity),
        getSeverity(rfOutputPilotLowFrequencyAlarmState,
            rfOutputPilotLowFrequencyAlarmSeverity),
        getSeverity(rfOutputPilotHighFrequencyAlarmState,
            rfOutputPilotHighFrequencyAlarmSeverity),
      ];

      // create a list contain index in severityList which is Alarm.danger
      List<int> severityIndexList = [];
      for (int i = 0; i < severityList.length; i++) {
        if (severityList[i] == Alarm.danger) {
          severityIndexList.add(i);
        }
      }

      return severityIndexList;
    }

    // alarmState (alarm mask) == '0' 代表 enable
    // alarmState (alarm mask) == '1' 代表 disable
    List<int> getNodeUnitStatusAlarmSeverityIndexList({
      required String temperatureAlarmState,
      required String voltageAlarmState,
      required String rfOutputPower1AlarmState,
      required String rfOutputPower3AlarmState,
      required String rfOutputPower4AlarmState,
      required String rfOutputPower6AlarmState,
      required String temperatureAlarmSeverity,
      required String voltageAlarmSeverity,
      required String rfOutputPower1AlarmSeverity,
      required String rfOutputPower3AlarmSeverity,
      required String rfOutputPower4AlarmSeverity,
      required String rfOutputPower6AlarmSeverity,
    }) {
      List<Alarm> severityList = [
        getSeverity(temperatureAlarmState, temperatureAlarmSeverity),
        getSeverity(voltageAlarmState, voltageAlarmSeverity),
        getSeverity(rfOutputPower1AlarmState, rfOutputPower1AlarmSeverity),
        getSeverity(rfOutputPower3AlarmState, rfOutputPower3AlarmSeverity),
        getSeverity(rfOutputPower4AlarmState, rfOutputPower4AlarmSeverity),
        getSeverity(rfOutputPower6AlarmState, rfOutputPower6AlarmSeverity),
      ];

      // create a list contain index in severityList which is Alarm.danger
      List<int> severityIndexList = [];
      for (int i = 0; i < severityList.length; i++) {
        if (severityList[i] == Alarm.danger) {
          severityIndexList.add(i);
        }
      }

      return severityIndexList;
    }

    Future<void> showAlarmDescriptionDialog({
      required List<int> severityIndexList,
      required ACIDeviceType aciDeviceType,
    }) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              width: 380,
              child: Dialog(
                insetPadding: const EdgeInsets.all(0),
                child: AlarmDescriptionPage(
                  severityIndexList: severityIndexList,
                  aciDeviceType: aciDeviceType,
                ),
              ),
            ),
          );
        },
      );
    }

    Widget getSetupWizardButton({bool enabled = true}) {
      return IconButton(
        visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
        onPressed: enabled
            ? () {
                showSetupWizardDialog(
                  context: context,
                  functionDescriptionType:
                      SetupWizardProperty.functionDescriptionType,
                  aciDeviceType: ACIDeviceType.amp1P8G,
                );
              }
            : null,
        icon: Icon(
          CustomIcons.information,
          color: enabled ? Theme.of(context).colorScheme.primary : Colors.grey,
          size: 30,
        ),
      );
    }

    bool getPulsatorEnabled({
      required Alarm alarm,
    }) {
      return alarm == Alarm.success ? false : true;
    }

    Widget getPulsator({
      required Color color,
      required List<int> severityIndexList,
      required ACIDeviceType aciDeviceType,
      required IconData iconData,
      required bool enableTap,
    }) {
      return Pulsator(
        enableTap: enableTap,
        onTap: () {
          showAlarmDescriptionDialog(
            severityIndexList: severityIndexList,
            aciDeviceType: aciDeviceType,
          );
        },
        iconData: iconData,
        size: 30, // Circle size
        color: color,
        duration: const Duration(
          seconds: 2,
        ), //  animationEnabled = false 時 Ripple duration 可以忽略
        rippleCount: enableTap ? 1 : 0,
        // animationEnabled = false 時關閉動畫
        // title: name,
      );
    }

    Widget getAmpIndicator({
      required List<int> ampSeverityIndexList,
      required Alarm ampUnitStatusAlarmSeverity,
      required Alarm ampTemperatureStatusAlarmSeverity,
      required Alarm ampVoltageStatusAlarmSeverity,
    }) {
      Color unitStatusAlarmcolor =
          CustomStyle.alarmColor[ampUnitStatusAlarmSeverity.name]!;
      Color temperatureStatusAlarmColor =
          CustomStyle.alarmColor[ampTemperatureStatusAlarmSeverity.name]!;
      Color voltageStatusAlarmcolor =
          CustomStyle.alarmColor[ampVoltageStatusAlarmSeverity.name]!;
      bool enableUnitStatusAlarmPulsator =
          getPulsatorEnabled(alarm: ampUnitStatusAlarmSeverity);
      bool enableTemperatureStatusAlarmPulsator =
          getPulsatorEnabled(alarm: ampTemperatureStatusAlarmSeverity);
      bool enableVoltageStatusAlarmPulsator =
          getPulsatorEnabled(alarm: ampVoltageStatusAlarmSeverity);

      ACIDeviceType aciDeviceType = ACIDeviceType.amp1P8G;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getPulsator(
              color: unitStatusAlarmcolor,
              severityIndexList: ampSeverityIndexList,
              aciDeviceType: aciDeviceType,
              iconData: CustomIcons.device,
              enableTap: enableUnitStatusAlarmPulsator,
            ),
            getPulsator(
              color: temperatureStatusAlarmColor,
              severityIndexList: ampSeverityIndexList.contains(0) ? [0] : [],
              aciDeviceType: aciDeviceType,
              iconData: CustomIcons.temperature,
              enableTap: enableTemperatureStatusAlarmPulsator,
            ),
            getPulsator(
              color: voltageStatusAlarmcolor,
              severityIndexList: ampSeverityIndexList.contains(1) ? [1] : [],
              aciDeviceType: aciDeviceType,
              iconData: CustomIcons.power,
              enableTap: enableVoltageStatusAlarmPulsator,
            ),
            Container(
              width: 44,
              height: 22,
              decoration: const BoxDecoration(color: Colors.transparent),
            ),
            getSetupWizardButton(),
          ],
        ),
      );
    }

    Widget getNodeIndicator({
      required List<int> nodeSeverityIndexList,
      required Alarm nodeUnitStatusAlarmSeverity,
      required Alarm nodeTemperatureStatusAlarmSeverity,
      required Alarm nodeVoltageStatusAlarmSeverity,
    }) {
      Color unitStatusAlarmcolor =
          CustomStyle.alarmColor[nodeUnitStatusAlarmSeverity.name]!;
      Color temperatureStatusAlarmColor =
          CustomStyle.alarmColor[nodeTemperatureStatusAlarmSeverity.name]!;
      Color voltageStatusAlarmcolor =
          CustomStyle.alarmColor[nodeVoltageStatusAlarmSeverity.name]!;
      bool enableUnitStatusAlarmPulsator =
          getPulsatorEnabled(alarm: nodeUnitStatusAlarmSeverity);
      bool enableTemperatureStatusAlarmPulsator =
          getPulsatorEnabled(alarm: nodeTemperatureStatusAlarmSeverity);
      bool enableVoltageStatusAlarmPulsator =
          getPulsatorEnabled(alarm: nodeVoltageStatusAlarmSeverity);

      ACIDeviceType aciDeviceType = ACIDeviceType.ampCCorNode1P8G;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getPulsator(
              color: unitStatusAlarmcolor,
              severityIndexList: nodeSeverityIndexList,
              aciDeviceType: aciDeviceType,
              iconData: CustomIcons.device,
              enableTap: enableUnitStatusAlarmPulsator,
            ),
            getPulsator(
              color: temperatureStatusAlarmColor,
              severityIndexList: nodeSeverityIndexList.contains(0) ? [0] : [],
              aciDeviceType: aciDeviceType,
              iconData: CustomIcons.temperature,
              enableTap: enableTemperatureStatusAlarmPulsator,
            ),
            getPulsator(
              color: voltageStatusAlarmcolor,
              severityIndexList: nodeSeverityIndexList.contains(1) ? [1] : [],
              aciDeviceType: aciDeviceType,
              iconData: CustomIcons.power,
              enableTap: enableVoltageStatusAlarmPulsator,
            ),
            Container(
              width: 44,
              height: 22,
              decoration: const BoxDecoration(color: Colors.transparent),
            ),
            getSetupWizardButton(),
          ],
        ),
      );
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadingStatus.isRequestSuccess) {
          // 由於不考慮 device 的 splitOptionAlarmSeverity
          // 因此 unitStatusAlarmSeverity 不直接讀取 device 的 unitStatusAlarmSeverity
          // 依照 device 是 amp 或 node 來決定, amp 則使用 getAmpUnitStatusAlarmSeverity
          // node 則使用 getNodeUnitStatusAlarmSeverity
          // String unitStatusAlarmSeverity =
          //     state.characteristicData[DataKey.unitStatusAlarmSeverity] ?? '';
          // String splitOptionAlarmSeverity =
          //     state.characteristicData[DataKey.splitOptionAlarmSeverity] ?? '';

          String temperatureAlarmSeverity =
              state.characteristicData[DataKey.temperatureAlarmSeverity] ?? '';

          String voltageAlarmSeverity =
              state.characteristicData[DataKey.voltageAlarmSeverity] ?? '';

          String voltageRippleAlarmSeverity =
              state.characteristicData[DataKey.voltageRippleAlarmSeverity] ??
                  '';

          String outputPowerAlarmSeverity =
              state.characteristicData[DataKey.outputPowerAlarmSeverity] ?? '';

          String rfOutputPilotLowFrequencyAlarmSeverity =
              state.characteristicData[
                      DataKey.rfOutputPilotLowFrequencyAlarmSeverity] ??
                  '';

          String rfOutputPilotHighFrequencyAlarmSeverity =
              state.characteristicData[
                      DataKey.rfOutputPilotHighFrequencyAlarmSeverity] ??
                  '';

          // Node
          String rfOutputPower1AlarmSeverity =
              state.characteristicData[DataKey.rfOutputPower1AlarmSeverity] ??
                  '';
          String rfOutputPower3AlarmSeverity =
              state.characteristicData[DataKey.rfOutputPower3AlarmSeverity] ??
                  '';

          String rfOutputPower4AlarmSeverity =
              state.characteristicData[DataKey.rfOutputPower4AlarmSeverity] ??
                  '';

          String rfOutputPower6AlarmSeverity =
              state.characteristicData[DataKey.rfOutputPower6AlarmSeverity] ??
                  '';

          String temperatureAlarmState =
              state.characteristicData[DataKey.temperatureAlarmState] ?? '1';

          String voltageAlarmState =
              state.characteristicData[DataKey.voltageAlarmState] ?? '1';

          String voltageRippleAlarmState =
              state.characteristicData[DataKey.voltageRippleAlarmState] ?? '1';

          String rfOutputPowerAlarmState =
              state.characteristicData[DataKey.rfOutputPowerAlarmState] ?? '1';

          String rfOutputPilotLowFrequencyAlarmState = state.characteristicData[
                  DataKey.rfOutputPilotLowFrequencyAlarmState] ??
              '1';

          String rfOutputPilotHighFrequencyAlarmState =
              state.characteristicData[
                      DataKey.rfOutputPilotHighFrequencyAlarmState] ??
                  '1';

          // Node
          String rfOutputPower1AlarmState =
              state.characteristicData[DataKey.rfOutputPower1AlarmState] ?? '1';
          String rfOutputPower3AlarmState =
              state.characteristicData[DataKey.rfOutputPower3AlarmState] ?? '1';
          String rfOutputPower4AlarmState =
              state.characteristicData[DataKey.rfOutputPower4AlarmState] ?? '1';
          String rfOutputPower6AlarmState =
              state.characteristicData[DataKey.rfOutputPower6AlarmState] ?? '1';

          List<int> ampUnitStatusAlarmSeverityIndexList =
              getAmpUnitStatusAlarmSeverityIndexList(
            temperatureAlarmState: temperatureAlarmState,
            voltageAlarmState: voltageAlarmState,
            voltageRippleAlarmState: voltageRippleAlarmState,
            rfOutputPowerAlarmState: rfOutputPowerAlarmState,
            rfOutputPilotLowFrequencyAlarmState:
                rfOutputPilotLowFrequencyAlarmState,
            rfOutputPilotHighFrequencyAlarmState:
                rfOutputPilotHighFrequencyAlarmState,
            temperatureAlarmSeverity: temperatureAlarmSeverity,
            voltageAlarmSeverity: voltageAlarmSeverity,
            voltageRippleAlarmSeverity: voltageRippleAlarmSeverity,
            rfOutputPowerAlarmSeverity: outputPowerAlarmSeverity,
            rfOutputPilotLowFrequencyAlarmSeverity:
                rfOutputPilotLowFrequencyAlarmSeverity,
            rfOutputPilotHighFrequencyAlarmSeverity:
                rfOutputPilotHighFrequencyAlarmSeverity,
          );

          List<int> nodeUnitStatusAlarmSeverityIndexList =
              getNodeUnitStatusAlarmSeverityIndexList(
            temperatureAlarmState: temperatureAlarmState,
            voltageAlarmState: voltageAlarmState,
            rfOutputPower1AlarmState: rfOutputPower1AlarmState,
            rfOutputPower3AlarmState: rfOutputPower3AlarmState,
            rfOutputPower4AlarmState: rfOutputPower4AlarmState,
            rfOutputPower6AlarmState: rfOutputPower6AlarmState,
            temperatureAlarmSeverity: temperatureAlarmSeverity,
            voltageAlarmSeverity: voltageAlarmSeverity,
            rfOutputPower1AlarmSeverity: rfOutputPower1AlarmSeverity,
            rfOutputPower3AlarmSeverity: rfOutputPower3AlarmSeverity,
            rfOutputPower4AlarmSeverity: rfOutputPower4AlarmSeverity,
            rfOutputPower6AlarmSeverity: rfOutputPower6AlarmSeverity,
          );

          Alarm ampUnitStatusAlarmSeverity =
              ampUnitStatusAlarmSeverityIndexList.isNotEmpty
                  ? Alarm.danger
                  : Alarm.success;

          Alarm nodeUnitStatusAlarmSeverity =
              nodeUnitStatusAlarmSeverityIndexList.isNotEmpty
                  ? Alarm.danger
                  : Alarm.success;

          Alarm finalTemperatureAlarmSeverity =
              getSeverity(temperatureAlarmState, temperatureAlarmSeverity);

          Alarm finalVoltageAlarmSeverity =
              getSeverity(voltageAlarmState, voltageAlarmSeverity);

          return state.aciDeviceType == ACIDeviceType.amp1P8G
              ? getAmpIndicator(
                  ampSeverityIndexList: ampUnitStatusAlarmSeverityIndexList,
                  ampUnitStatusAlarmSeverity: ampUnitStatusAlarmSeverity,
                  ampTemperatureStatusAlarmSeverity:
                      finalTemperatureAlarmSeverity,
                  ampVoltageStatusAlarmSeverity: finalVoltageAlarmSeverity,
                )
              : getNodeIndicator(
                  nodeSeverityIndexList: nodeUnitStatusAlarmSeverityIndexList,
                  nodeUnitStatusAlarmSeverity: nodeUnitStatusAlarmSeverity,
                  nodeTemperatureStatusAlarmSeverity:
                      finalTemperatureAlarmSeverity,
                  nodeVoltageStatusAlarmSeverity: finalVoltageAlarmSeverity,
                );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getPulsator(
                  color: const Color(0xff6c757d),
                  severityIndexList: [],
                  aciDeviceType: state.aciDeviceType,
                  iconData: CustomIcons.device,
                  enableTap: false,
                ),
                getPulsator(
                  color: const Color(0xff6c757d),
                  severityIndexList: [],
                  aciDeviceType: state.aciDeviceType,
                  iconData: CustomIcons.temperature,
                  enableTap: false,
                ),
                getPulsator(
                  color: const Color(0xff6c757d),
                  severityIndexList: [],
                  aciDeviceType: state.aciDeviceType,
                  iconData: CustomIcons.power,
                  enableTap: false,
                ),
                Container(
                  width: 44,
                  height: 22,
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
                getSetupWizardButton(),
              ],
            ),
          );
        }
      },
    );
  }
}
