import 'dart:io';
import 'package:devject_single/cubit/selected_task_cubit.dart';
import 'package:devject_single/cubit/tasks_cubit.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/pages/task_page.dart';
import 'package:devject_single/utils/screen_size.dart';
import 'package:devject_single/widgets/backdrop_filter_container.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TaskContainer extends StatelessWidget {
  const TaskContainer(this.task, {Key? key}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMMMMd(Platform.localeName);
    return BackdropFilterContaiter(
      margin: EdgeInsets.symmetric(vertical: ScreenSize.height(context, 1)),
      padding: EdgeInsets.all(ScreenSize.width(context, 5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text:  task.name,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.bold
              ),
              recognizer: TapGestureRecognizer()..onTap = () async {
                BlocProvider.of<SelectedTaskCubit>(context).select(task);
                await BlocProvider.of<TasksCubit>(context).load(
                  task.projectId, 
                  parentId: task.id
                );
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: BlocProvider.of<SelectedTaskCubit>(context),
                      child: BlocProvider.value(
                        value: BlocProvider.of<TasksCubit>(context),
                        child: const TaskPage(),
                      ),
                    )
                  )
                );
              }
            )
          ),
          SizedBox(height: ScreenSize.height(context, 1)),
          if(task.startDate != null && task.endDate != null) 
            ...[
              Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.start + ": ",
                        style: Theme.of(context).textTheme.bodyText2
                      ),
                      TextSpan(
                        text: dateFormat.format(task.startDate!),
                        style: Theme.of(context).textTheme.bodyText1
                      ),
                    ]
                  )
                ),
              ),
              SizedBox(height: ScreenSize.height(context, 1)),
              Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.end + ": ",
                        style: Theme.of(context).textTheme.bodyText2
                      ),
                      TextSpan(
                        text: dateFormat.format(task.endDate!),
                        style: Theme.of(context).textTheme.bodyText1
                      ),
                    ]
                  )
                ),
              ),
              SizedBox(height: ScreenSize.height(context, 1))
            ]
          else
            Text(
              AppLocalizations.of(context)!.timeToExecute + ": " +
              AppLocalizations.of(context)!.indefinite.toLowerCase(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          if (task.description != null && task.description!.isNotEmpty)
            ExpandablePanel(
              theme: ExpandableThemeData(
                iconColor: Theme.of(context).textTheme.bodyText2!.color,
                iconPadding: const EdgeInsets.all(0)
              ),
              header: Text(
                AppLocalizations.of(context)!.description,
                style: Theme.of(context).textTheme.bodyText2
              ),
              collapsed: Text(
                task.description!,
                style: Theme.of(context).textTheme.bodyText1!
                .copyWith(fontStyle: FontStyle.italic)
                ,
                softWrap: true, 
                maxLines: 1, 
                overflow: TextOverflow.ellipsis
              ),
              expanded: Text(
                task.description!, 
                style: Theme.of(context).textTheme.bodyText1!
                .copyWith(fontStyle: FontStyle.italic),
                softWrap: true
              ),
            ),
          SizedBox(height: ScreenSize.height(context, 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: task.progress.toDouble() / 100,
                    backgroundColor: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.5),
                    valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                  ),
                ),
              ),
              SizedBox(width: ScreenSize.width(context, 2)),
              Text(
                task.progress.toString() + "%",
                style: Theme.of(context).textTheme.bodyText1
              )
            ]
          )
        ]
      )
    );
  }
}