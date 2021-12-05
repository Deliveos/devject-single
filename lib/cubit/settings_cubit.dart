import 'package:bloc/bloc.dart';
import 'package:devject_single/models/settings.dart';
import 'package:devject_single/providers/settings_provider.dart';


class SettingsCubit extends Cubit<Settings> {
  SettingsCubit() : super(Settings.byDefault());

  final SettingProvider _provider = SettingProvider.instance;

  Future<void> load() async {
    if (state == Settings.byDefault()) {
      emit(await _provider.getOne(1));
    }
  }

  Future<void> update(Settings settings) async {
    emit(settings);
    await _provider.update(settings);
  }
}
