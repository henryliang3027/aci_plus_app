import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_config/setting18_config_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_config_edit_page.dart';
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

    Widget buildConfigListView({
      required Setting18ConfigState setting18configState,
    }) {
      return ListView.separated(
        itemCount: setting18configState.partIds.length,
        separatorBuilder: (context, index) => const SizedBox(),
        itemBuilder: (context, index) {
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
                    showModuleSettingDialog(
                        selectedPartId: setting18configState.partIds[index]);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26.0,
                        ),
                        child: Text(
                          partIdMap[setting18configState.partIds[index]]!,
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
        },
      );
    }

    return Builder(
      builder: (context) {
        HomeState homeState = context.watch<HomeBloc>().state;
        Setting18ConfigState setting18configState =
            context.read<Setting18ConfigBloc>().state;

        if (homeState.loadingStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (homeState.loadingStatus.isRequestSuccess) {
          return buildConfigListView(
            setting18configState: setting18configState,
          );
        } else {
          return buildConfigListView(
            setting18configState: setting18configState,
          );
        }
      },
    );
  }
}
