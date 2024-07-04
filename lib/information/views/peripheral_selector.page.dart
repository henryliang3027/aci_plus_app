import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PeripheralSelector extends StatelessWidget {
  const PeripheralSelector({super.key});

  final List<String> bluetoothDevices = const [
    'ACI24050702',
    'ACI240505004',
    'ACI240503006'
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              AppLocalizations.of(context)!.dialogTitleSelectConfig,
              style: TextStyle(
                fontSize: CustomStyle.sizeXL,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: bluetoothDevices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: Icon(Icons.bluetooth, color: Colors.blue),
                        title: Text(
                          bluetoothDevices[index],
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 24, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 20.0,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.dialogMessageOk,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
