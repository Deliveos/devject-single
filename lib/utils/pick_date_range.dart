import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Future pickDateRange(
  BuildContext context,
  {
    required DateTime firstDate,
    required DateTime lastDate,
    void Function(DateTimeRange?)? callback
  }
  ) async {
    final newDateRange = await showDateRangePicker(
      cancelText: AppLocalizations.of(context)!.done,
      builder: (context, Widget? child) => Theme(
        data: Theme.of(context).copyWith(
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
            backgroundColor: Theme.of(context).backgroundColor,
            iconTheme: Theme.of(context)
            .appBarTheme
            .iconTheme!
            .copyWith(color: Colors.white)
          ),
        ),
        child: child!,
      ),
      context: context,
      firstDate: firstDate,
      //BlocProvider.of<SelectedTaskCubit>(context).state?.startDate ??
      //BlocProvider.of<SelectedProjectCubit>(context).state!.startDate!,
      lastDate: lastDate
      //BlocProvider.of<SelectedTaskCubit>(context).state?.endDate ??
      //BlocProvider.of<SelectedProjectCubit>(context).state!.endDate!
    );
    if (callback != null) {
      callback(newDateRange);
    }
  }