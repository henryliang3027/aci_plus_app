import 'package:aci_plus_app/advanced/bloc/setting18_dongle/setting18_dongle_bloc.dart';
import 'package:aci_plus_app/advanced/view/qr_code_generator_page.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18DongleForm extends StatelessWidget {
  const Setting18DongleForm({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> showGeneratedQRCodeDialog({
      required String encodedData,
      required String description,
    }) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;

          return Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: width * 0.01,
            ),
            child: QRCodeGeneratorPage(
              encodedData: encodedData,
              description: description,
            ),
          );
        },
      );
    }

    return BlocListener<Setting18DongleBloc, Setting18DongleState>(
      listener: (context, state) {
        // if (state.encodeStaus == FormStatus.requestSuccess) {
        //   showGeneratedQRCodeDialog(encodedData: state.encodedData);
        // }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.deviceSetting),
          centerTitle: true,
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              _QRDataScanner(),
              _DeviceListView(),
            ],
          ),
        ),
      ),
    );
  }
}

class _QRDataScanner extends StatelessWidget {
  const _QRDataScanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18DongleBloc, Setting18DongleState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Card(
            color: Theme.of(context).colorScheme.onPrimary,
            surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: index % 2 == 0
                //     ? const Color.fromARGB(255, 197, 204, 246)
                //     : const Color.fromARGB(255, 222, 227, 255),
              ),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26.0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.scanQRCode,
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeXL,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.qr_code_scanner_sharp,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DeviceListView extends StatelessWidget {
  const _DeviceListView();

  @override
  Widget build(BuildContext context) {
    Future<void> showModuleSettingDialog({
      required String selectedPartId,
    }) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;

          return Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: width * 0.01,
            ),
            child: const Text('123'),
            // Setting18ConfigEditPage(
            //   selectedPartId: selectedPartId,
            // ),
          );
        },
      );
    }

    Widget configCard({
      required String partId,
    }) {
      return Card(
        // margin: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: index % 2 == 0
            //     ? const Color.fromARGB(255, 197, 204, 246)
            //     : const Color.fromARGB(255, 222, 227, 255),
          ),
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26.0,
                  ),
                  child: Text(
                    partIdMap[partId]!,
                    style: const TextStyle(
                      fontSize: CustomStyle.size36,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          // context
                          //     .read<Setting18DongleBloc>()
                          //     .add(QRDataGenerated(partId));
                        },
                        icon: const Icon(
                          Icons.qr_code_2,
                          size: 26,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModuleSettingDialog(selectedPartId: partId);
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<Widget> buildDSIMConfigListView({
      required List<String> partIds,
    }) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 20.0,
          ),
          child: Text(
            partIdMap[partIds[0]]!,
            style: const TextStyle(
              fontSize: CustomStyle.sizeXL,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        for (String partId in partIds) ...[
          configCard(partId: partId),
        ],
      ];
    }

    List<Widget> buildMOTOConfigListView({
      required List<String> partIds,
    }) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 20.0,
          ),
          child: Text(
            partIdMap[partIds[0]]!.split(' ')[0],
            style: const TextStyle(
              fontSize: CustomStyle.sizeXL,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        for (String partId in partIds) ...[
          configCard(partId: partId),
        ],
      ];
    }

    List<Widget> buildCCorConfigListView({
      required List<String> partIds,
    }) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 20.0,
          ),
          child: Text(
            partIdMap[partIds[0]]!.split(' ')[0],
            style: const TextStyle(
              fontSize: CustomStyle.sizeXL,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        for (String partId in partIds) ...[
          configCard(partId: partId),
        ],
      ];
    }

    return BlocBuilder<Setting18DongleBloc, Setting18DongleState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...buildDSIMConfigListView(partIds: state.partIds.sublist(0, 1)),
            const SizedBox(
              height: 20,
            ),
            ...buildMOTOConfigListView(partIds: state.partIds.sublist(1, 3)),
            const SizedBox(
              height: 20,
            ),
            ...buildCCorConfigListView(partIds: state.partIds.sublist(3)),
          ],
        );
      },
    );
  }
}
