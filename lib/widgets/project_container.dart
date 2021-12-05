import 'dart:io';
import 'package:devject_single/cubit/selected_project_cubit.dart';
import 'package:devject_single/cubit/tasks_cubit.dart';
import 'package:devject_single/models/project.dart';
import 'package:devject_single/pages/project_page.dart';
import 'package:devject_single/providers/projects_provider.dart';
import 'package:devject_single/utils/screen_size.dart';
import 'package:devject_single/widgets/system_info_item.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ProjectContainer extends StatelessWidget {
  const ProjectContainer(this.project, {Key? key}) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMMMMd(Platform.localeName);
    return InkWell(
      onTap: () async {
        BlocProvider.of<SelectedProjectCubit>(context).select(
          await ProjectsProvider.instance.getOne(project.id!)
        );
        await BlocProvider.of<TasksCubit>(context).load(project.id!);
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) =>  BlocProvider.value(
              value: BlocProvider.of<SelectedProjectCubit>(context),
              child: const ProjectPage()
            )
          )
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(20)
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.07),
              offset: Offset.zero,
              spreadRadius: 0
            )
          ]
        ),
        margin: EdgeInsets.symmetric(vertical: ScreenSize.height(context, 1)),
        padding: EdgeInsets.all(ScreenSize.width(context, 5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /*
            * PROJECT NAME
            */
            Row(
              children: [
                Text(
                  project.name,
                  style: Theme.of(context).textTheme.subtitle1!,
                )
              ]
            ),
            SizedBox(height: ScreenSize.height(context, 1)),
            /*
            * DESCRIPTION
            */
            if (project.description != null && project.description!.isNotEmpty)
              Align(
                alignment: Alignment.topLeft,
                child: ExpandableText(
                  project.description!,
                  expandText: '',
                  maxLines: 1,
                  expandOnTextTap: true,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontStyle: FontStyle.italic
                  ),
                  prefixText: AppLocalizations.of(context)!.description + ": ",
                  prefixStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontStyle: FontStyle.normal
                  ),
                  collapseOnTextTap: true,
                ),
              ),
            SizedBox(height: ScreenSize.height(context, 1)),
            /*
            * PROGRESS
            */
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: project.tasksCount != 0 
                        ? project.complitedTaskCount / project.tasksCount
                        : 0,
                      backgroundColor: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.5),
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(width: ScreenSize.width(context, 2)),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: project.complitedTaskCount.toString() + '/',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).primaryColor
                        )
                      ),
                      TextSpan(
                        text: project.tasksCount.toString(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).textTheme.bodyText2!.color
                        )
                      )
                    ]
                  ),
                ),
              ]
            ),
            SizedBox(height: ScreenSize.height(context, 1)),
            Row(
              children: <Widget>[
                SystemInfoItem(
                  iconData: FluentIcons.calendar_ltr_24_regular, 
                  text: project.endDate != null 
                    ? dateFormat.format(project.endDate!)
                    : AppLocalizations.of(context)!.indefinite
                ),
                Icon(
                  FluentIcons.divider_tall_24_regular,
                  color: Theme.of(context).iconTheme.color!.withOpacity(0.3)
                ),
                SystemInfoItem(
                  iconData: FluentIcons.branch_24_regular, 
                  text: project.tasksCount.toString()
                ),
                Icon(
                  FluentIcons.divider_tall_24_regular,
                  color: Theme.of(context).iconTheme.color!.withOpacity(0.3)
                ),
                SystemInfoItem(
                  iconData: FluentIcons.checkmark_24_regular, 
                  text: project.complitedTaskCount.toString()
                ),
              ]
            )
          ]
        )
      ),
    );
  }
}