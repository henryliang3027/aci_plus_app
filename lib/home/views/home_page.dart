import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/home/views/home_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeForm(),
    );
    //   appBar: AppBar(title: Text('Home')),
    //   body: BlocBuilder<HomeBloc, HomeState>(
    //     builder: (context, state) {
    //       if (state.status.isRequestSuccess) {
    //         return Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Center(
    //               child: Text(state.device!.name),
    //             ),
    //             ElevatedButton(
    //               onPressed: () {
    //                 context.read<HomeBloc>().add(const DeviceRefreshed());
    //               },
    //               child: const Text('Restart'),
    //             ),
    //           ],
    //         );
    //       } else if (state.status.isRequestFailure) {
    //         return Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             const Center(
    //               child: Text('Device not found!'),
    //             ),
    //             ElevatedButton(
    //               onPressed: () {
    //                 context.read<HomeBloc>().add(const DeviceRefreshed());
    //               },
    //               child: const Text('Restart'),
    //             ),
    //           ],
    //         );
    //       } else {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //     },
    //   ),
    // );
  }
}
