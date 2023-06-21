import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_filex/open_filex.dart';

class ChartForm extends StatelessWidget {
  const ChartForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.dataExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)
                      .dialogMaessageDataExportSuccessful,
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context).open,
                  onPressed: () async {
                    OpenResult result = await OpenFilex.open(
                      state.dataExportPath,
                      type: 'application/vnd.ms-excel',
                      uti: 'com.microsoft.excel.xls',
                    );

                    print(result.message);
                  },
                ),
              ),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).monitoringChart,
          ),
          centerTitle: true,
          actions: const [
            _PopupMenu(),
          ],
        ),
        body: const Center(
            child: Icon(
          Icons.chat_rounded,
        )),
      ),
    );
  }
}

enum Menu { share, export }

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state.eventRecordsLoadingStatus == FormStatus.requestInProgress) {
        return const Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      } else {
        return PopupMenuButton<Menu>(
          icon: const Icon(
            Icons.more_vert_outlined,
            color: Colors.white,
          ),
          tooltip: '',
          onSelected: (Menu item) async {
            switch (item) {
              case Menu.share:
                // context
                //     .read<HomeBloc>()
                //     .add(const ForwardOutlinesDeletedModeEnabled());
                break;
              case Menu.export:
                context.read<HomeBloc>().add(const DataExported());
                break;
              default:
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
            PopupMenuItem<Menu>(
              value: Menu.share,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.share,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(AppLocalizations.of(context).share),
                ],
              ),
            ),
            PopupMenuItem<Menu>(
              value: Menu.export,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.download,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(AppLocalizations.of(context).export),
                ],
              ),
            ),
          ],
        );
      }
    });
  }
}
