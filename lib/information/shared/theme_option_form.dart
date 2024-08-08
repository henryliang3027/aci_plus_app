import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/information/bloc/theme/theme_bloc.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeOptionForm extends StatelessWidget {
  const ThemeOptionForm({super.key});

  final List<String> themeValues = const [
    'light',
    'dark',
    'system',
  ];

  @override
  Widget build(BuildContext context) {
    List<String> themeTexts = [
      AppLocalizations.of(context)!.lightTheme,
      AppLocalizations.of(context)!.darkTheme,
      AppLocalizations.of(context)!.systemTheme,
    ];

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return SizedBox(
          width: 370,
          height: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  AppLocalizations.of(context)!.dialogTitleSelectTheme,
                  style: TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 6.8,
                  ),
                  itemCount: 3,
                  itemBuilder: (BuildContext itemContext, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          elevation: 0.0,
                          foregroundColor: getForegroundColor(
                            context: context,
                            targetValue: state.theme,
                            value: themeValues[index],
                          ),
                          backgroundColor: getBackgroundColor(
                            context: context,
                            targetValue: state.theme,
                            value: themeValues[index],
                          ),
                          side: BorderSide(
                            color: getBorderColor(
                              context: context,
                              targetValue: state.theme,
                              value: themeValues[index],
                            ),
                            width: 1.0,
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        onPressed: () {
                          context
                              .read<ThemeBloc>()
                              .add(ThemeChanged(themeValues[index]));
                        },
                        child: Text(
                          themeTexts[index],
                          style: const TextStyle(
                            fontSize: CustomStyle.sizeXL,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 38.0, 20.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(state.theme);
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
      },
    );
  }
}
