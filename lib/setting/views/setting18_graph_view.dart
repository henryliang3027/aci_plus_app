import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xml/xml.dart';

class Setting18GraphView extends StatelessWidget {
  const Setting18GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    setFullScreenOrientation();
    return Scaffold(
      body: const _GraphInteractor(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(
          side: BorderSide.none,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
        child: Icon(
          Icons.list,
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

class _GraphInteractor extends StatelessWidget {
  const _GraphInteractor({super.key});

  Future<void> showResultDialog({
    required BuildContext context,
    required String message,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;
        // var height = MediaQuery.of(context).size.height;

        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: width * 0.1,
          ),
          title: const Text("Setting"),
          content: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: ListBody(
                children: [Text(message)],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true); // pop dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double centerX = MediaQuery.of(context).size.width / 2;
    double centerY = MediaQuery.of(context).size.height / 2;
    return WillPopScope(
      onWillPop: () async {
        setPreferredOrientation();
        return true;
      },
      child: InteractiveViewer(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            const Center(
              child: Image(
                image: AssetImage('assets/circuits/MB_1.8G.png'),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: centerX - 175,
              top: centerY - 199,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Container(
                    width: 68,
                    height: 62,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.blue)),
                  ),
                  onTap: () {
                    showResultDialog(context: context, message: 'Button 1');
                  },
                ),
              ),
            ),
            Positioned(
              left: 352,
              top: 18,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Container(
                    width: 68,
                    height: 62,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.blue)),
                  ),
                  onTap: () {
                    showResultDialog(context: context, message: 'Button 2');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<String>> loadSvgImage({required String svgImage}) async {
  List<String> maps = [];
  String generalString = await rootBundle.loadString(svgImage);

  XmlDocument document = XmlDocument.parse(generalString);

  final paths = document.findAllElements('path');

  for (var element in paths) {
    String partPath = element.getAttribute('d').toString();
    maps.add(partPath);
  }

  return maps;
}
