import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:flutter/material.dart';

class NamePlateView extends StatelessWidget {
  const NamePlateView({
    super.key,
    required this.partId,
  });

  final String partId;

  static Route<void> route({
    required String partId,
  }) {
    return MaterialPageRoute(
        builder: (_) => NamePlateView(
              partId: partId,
            ));
  }

  @override
  Widget build(BuildContext context) {
    setFullScreenOrientation();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: _NamePlateInteractor(
        partId: partId,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(
          side: BorderSide.none,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
        child: Icon(
          CustomIcons.cancel,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () {
          setPreferredOrientation();
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _NamePlateInteractor extends StatelessWidget {
  const _NamePlateInteractor({
    super.key,
    required this.partId,
  });

  final String partId;

  @override
  Widget build(BuildContext context) {
    String namePlatePath = namePlateFilePath[partId] ?? '';

    return PopScope(
      onPopInvoked: (bool canPop) async {
        setPreferredOrientation();
      },
      child: InteractiveViewer(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: namePlatePath.isNotEmpty
              ? Image.asset(namePlatePath)
              : const Icon(
                  Icons.warning_rounded,
                  size: 200,
                  color: Color(0xffffc107),
                ),
        ),
      ),
    );
  }
}
