import 'package:aci_plus_app/chart/bloc/chart18/chart18_bloc.dart';
import 'package:aci_plus_app/chart/view/chart18_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chart18Page extends StatelessWidget {
  const Chart18Page({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Chart18Bloc(
        // 直接傳 context 是為了可以即時取得 app 目前的語言, 即使在 app 開啟時切換語言, 匯出資料時也可以即時翻譯對應的語言
        context: context,
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
      ),
      child: Chart18Form(
        pageController: pageController,
      ),
    );
  }
}
