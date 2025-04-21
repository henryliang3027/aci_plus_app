import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/home/bloc/alarm_description/alarm_description_bloc.dart';
import 'package:aci_plus_app/home/views/alarm_description_form.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmDescriptionPage extends StatelessWidget {
  const AlarmDescriptionPage({
    super.key,
    required this.dataKey,
  });
  final DataKey dataKey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlarmDescriptionBloc(
        dataKey: dataKey,
        aciDeviceRepository:
            RepositoryProvider.of<ACIDeviceRepository>(context),
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
        amp18CCorNodeRepository:
            RepositoryProvider.of<Amp18CCorNodeRepository>(context),
        unitRepository: RepositoryProvider.of<UnitRepository>(context),
      ),
      child: const AlarmDescriptionForm(),
    );
  }
}
