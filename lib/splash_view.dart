import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
        centerTitle: true,
        leading: const _DeviceStatus(),
        actions: const [_DeviceRefresh()],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            _ConnectionCard(),
            _BasicCard(),
            _AlarmCard(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(CustomIcons.information),
            label: 'Information',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.chart),
            label: 'Chart',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.about),
            label: 'About',
            tooltip: '',
          ),
        ],
        //if current page is account which is not list in bottom navigation bar, make all items grey color
        //assign a useless 0 as currentIndex for account page
        currentIndex: 2,
        selectedIconTheme: const IconThemeData(size: 36),
        selectedFontSize: 10.0,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).hintColor,
      ),
    );
  }
}

class _DeviceStatus extends StatelessWidget {
  const _DeviceStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: CustomStyle.diameter,
        height: CustomStyle.diameter,
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}

class _DeviceRefresh extends StatelessWidget {
  const _DeviceRefresh({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({super.key});

  Widget getBluetoothName({
    required FormStatus scanStatus,
    required String title,
    required String name,
  }) {
    if (scanStatus == FormStatus.requestInProgress) {
      return const SizedBox(
        width: CustomStyle.diameter,
        height: CustomStyle.diameter,
        child: CircularProgressIndicator(),
      );
    } else if (scanStatus == FormStatus.requestFailure) {
      return const Text(
        'N/A',
        style: TextStyle(
          fontSize: CustomStyle.sizeL,
        ),
      );
    } else {
      return Text(
        name,
        style: const TextStyle(
          fontSize: CustomStyle.sizeL,
        ),
      );
    }
  }

  Widget bluetoothText({
    required FormStatus scanStatus,
    required String title,
    required String name,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
          ),
          getBluetoothName(
            scanStatus: FormStatus.requestInProgress,
            title: title,
            name: name,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.connection,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10.0,
            ),
            itemLinkText(
              title: '',
              content: AppLocalizations.of(context)!.visitWebsite,
            ),
            bluetoothText(
              scanStatus: FormStatus.requestInProgress,
              title: AppLocalizations.of(context)!.bluetooth,
              name: '',
            ),
          ],
        ),
      ),
    );
  }
}

class _BasicCard extends StatelessWidget {
  const _BasicCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.basicInformation,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10.0,
            ),
            itemText(
              loadingStatus: FormStatus.requestInProgress,
              title: AppLocalizations.of(context)!.typeNo,
              content: '',
            ),
            itemText(
              loadingStatus: FormStatus.requestInProgress,
              title: AppLocalizations.of(context)!.partNo,
              content: '',
            ),
            itemText(
              loadingStatus: FormStatus.requestInProgress,
              title: AppLocalizations.of(context)!.serialNumber,
              content: '',
            ),
            itemText(
              loadingStatus: FormStatus.requestInProgress,
              title: AppLocalizations.of(context)!.firmwareVersion,
              content: '',
            ),
            itemText(
              loadingStatus: FormStatus.requestInProgress,
              title: AppLocalizations.of(context)!.logInterval,
              content: '',
            ),
            itemMultipleLineText(
              loadingStatus: FormStatus.requestInProgress,
              title: AppLocalizations.of(context)!.location,
              content: '',
            ),
            itemMultipleLineText(
              loadingStatus: FormStatus.requestInProgress,
              title: AppLocalizations.of(context)!.coordinates,
              content: '',
            ),
            itemText(
              loadingStatus: FormStatus.requestInProgress,
              title: AppLocalizations.of(context)!.mfgDate,
              content: '',
            ),
          ],
        ),
      ),
    );
  }
}

class _AlarmCard extends StatelessWidget {
  const _AlarmCard({super.key});

  Widget alarmItem({
    required IconData iconData,
    required String title,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            iconData,
            color: iconColor,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildAlarmCard({
      required String alarmUSeverity,
      required String alarmTSeverity,
      required String alarmPSeverity,
    }) {
      return Card(
        color: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.alarmIndicator,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              alarmItem(
                iconData: Icons.circle,
                iconColor: CustomStyle.alarmColor[alarmUSeverity],
                title: AppLocalizations.of(context)!.unitStatusAlarm,
              ),
              alarmItem(
                iconData: Icons.circle,
                iconColor: CustomStyle.alarmColor[alarmTSeverity],
                title: AppLocalizations.of(context)!.temperatureAlarm,
              ),
              alarmItem(
                iconData: Icons.circle,
                iconColor: CustomStyle.alarmColor[alarmPSeverity],
                title: AppLocalizations.of(context)!.powerSupplyAlarm,
              ),
            ],
          ),
        ),
      );
    }

    return buildAlarmCard(
      alarmUSeverity: 'default',
      alarmTSeverity: 'default',
      alarmPSeverity: 'default',
    );
  }
}

Widget getContent({
  required FormStatus loadingStatus,
  required String content,
  double fontSize = 16,
}) {
  if (loadingStatus == FormStatus.requestInProgress) {
    return content.isEmpty
        ? const SizedBox(
            width: CustomStyle.diameter,
            height: CustomStyle.diameter,
            child: CircularProgressIndicator(),
          )
        : Text(
            content,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: fontSize,
            ),
          );
  } else if (loadingStatus == FormStatus.requestSuccess) {
    return Text(
      content,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  } else {
    return Text(
      content.isEmpty ? 'N/A' : content,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}

Widget itemText({
  required FormStatus loadingStatus,
  required String title,
  required String content,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: CustomStyle.sizeL,
          ),
        ),
        const SizedBox(
          width: 30.0,
        ),
        Flexible(
          child: getContent(loadingStatus: loadingStatus, content: content),
        ),
      ],
    ),
  );
}

Widget itemMultipleLineText({
  required FormStatus loadingStatus,
  required String title,
  required String content,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: CustomStyle.sizeL,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // const SizedBox(
            //   width: 30,
            // ),
            Flexible(
              child: RichText(
                text: WidgetSpan(
                  child: getContent(
                      loadingStatus: loadingStatus, content: content),
                  // Text(
                  //   content,
                  //   textAlign: TextAlign.right,
                  //   // textDirection: TextDirection.rtl,
                  //   style: TextStyle(
                  //     fontSize: CustomStyle.sizeL,
                  //   ),
                  // ),
                ),
              ),
            )
          ],
        )
      ],
    ),
  );
}

Widget itemLinkText({
  required String title,
  required String content,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: CustomStyle.sizeL,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            visualDensity:
                const VisualDensity(vertical: -4.0, horizontal: -4.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.all(1.0),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
          ),
          onPressed: () async {
            Uri uri = Uri.parse('http://acicomms.com/products/line-amplifier');
            launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    ),
  );
}
