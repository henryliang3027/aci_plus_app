import 'package:aci_plus_app/advanced/bloc/setting18_config/setting18_config_bloc.dart';
import 'package:aci_plus_app/advanced/view/edit_items_form.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_edit_page.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ConfigForm extends StatelessWidget {
  const Setting18ConfigForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<Setting18ConfigBloc, Setting18ConfigState>(
      listener: (context, state) {},
      child: const _ConfigListView(),
    );
  }
}

class _ConfigListView extends StatelessWidget {
  const _ConfigListView({super.key});

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
            child: Setting18ConfigEditPage(
              selectedPartId: selectedPartId,
            ),
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                showModuleSettingDialog(selectedPartId: partId);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
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
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 26.0,
                    ),
                    child: Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    List<Widget> buildMOTOConfigListView({
      required List<String> partIds,
    }) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 20.0,
          ),
          child: Text(
            'AMT',
            style: TextStyle(
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
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 20.0,
          ),
          child: Text(
            'AMF',
            style: TextStyle(
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

    Widget buildConfigListView({
      required List<String> partIds,
    }) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, EditItemsForm.route());
                },
                child: Icon(Icons.abc)),
            ...buildMOTOConfigListView(partIds: partIds.sublist(0, 2)),
            const SizedBox(
              height: 20,
            ),
            ...buildCCorConfigListView(partIds: partIds.sublist(2)),
          ],
        ),
      );
    }

    return Builder(
      builder: (context) {
        HomeState homeState = context.watch<HomeBloc>().state;
        Setting18ConfigState setting18configState =
            context.read<Setting18ConfigBloc>().state;

        if (homeState.loadingStatus.isRequestInProgress) {
          return Stack(
            children: [
              buildConfigListView(partIds: setting18configState.partIds),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(70, 158, 158, 158),
                ),
                child: const Center(
                  child: SizedBox(
                    width: CustomStyle.diameter,
                    height: CustomStyle.diameter,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          );
        } else {
          return buildConfigListView(partIds: setting18configState.partIds);
        }
      },
    );
  }
}
