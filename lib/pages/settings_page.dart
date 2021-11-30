import 'package:devject_single/constants/sizes.dart';
import 'package:devject_single/cubit/settings_cubit.dart';
import 'package:devject_single/models/settings.dart';
import 'package:devject_single/utils/screen_size.dart';
import 'package:devject_single/widgets/appbar.dart';
import 'package:devject_single/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const String routeName = "SettingsPage";

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SettingsCubit>(context).load();
    return BlocBuilder<SettingsCubit, Settings?>(
      builder: (context, settingsState) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: buildAppBar(
            context,
            title: Text(
              AppLocalizations.of(context)!.settings,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          body: Background(
            child: Column(
              children: <Widget>[
                SizedBox(height: kAppBarHeight + ScreenSize.height(context, 3)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.useCheckboxToMarkProgress,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Switch(
                      value: settingsState?.useCheckBox ?? false, 
                      onChanged: (value) async {
                        await BlocProvider.of<SettingsCubit>(context).update(
                          settingsState!.copyWith(
                            useCheckBox: value
                          )
                        );                          
                      }
                    )
                  ]
                )
              ]
            )
          )
        );
      },
    );
  }
}