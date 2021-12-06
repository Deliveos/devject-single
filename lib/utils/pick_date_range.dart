import 'package:flutter/material.dart';


Future pickDateRange(
  BuildContext context,
  {
    required DateTime firstDate,
    required DateTime lastDate,
    void Function(DateTimeRange?)? callback
  }
  ) async {
    final newDateRange = await showDateRangePicker(
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
      lastDate: lastDate
    );
    if (callback != null) {
      callback(newDateRange);
    }
  }