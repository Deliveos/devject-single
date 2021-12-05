import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/sizes.dart';
import '../cubit/settings_cubit.dart';
import '../models/settings.dart';
import '../utils/screen_size.dart';
import '../widgets/appbar.dart';
import '../widgets/main_bottom_nav_bar.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const String routeName = "SettingsPage";

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SettingsCubit>(context).load();
    return BlocBuilder<SettingsCubit, Settings>(
      builder: (context, settingsState) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: buildAppBar(
            context,
            title: AppLocalizations.of(context)!.settings,
          ),
          body: Column(
            children: <Widget>[
              SizedBox(height: kAppBarHeight + ScreenSize.height(context, 3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.darkTheme,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Switch(
                    value: settingsState.isDarkTheme??  false, 
                    onChanged: (value) async {
                      await BlocProvider.of<SettingsCubit>(context).update(
                        settingsState.copyWith(
                          isDarkTheme: value
                        )
                      );                          
                    }
                  )
                ]
              )
            ]
          ),
          bottomNavigationBar: const MainBottomNavBar(),
        );
      },
    );
  }
}