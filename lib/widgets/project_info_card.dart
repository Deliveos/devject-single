import 'dart:io';
import 'package:devject_single/pages/edit_project_page.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../constants/sizes.dart';
import '../models/project.dart';
import '../utils/screen_size.dart';


class ProjectInfoCard extends StatelessWidget {
  const ProjectInfoCard({
    Key? key,
    required this.project
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
  final DateFormat dateFormat = DateFormat.yMEd(Platform.localeName);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenSize.width(context, 5),
        vertical: ScreenSize.height(context, 1)
      ),
      padding: EdgeInsets.all(
        ScreenSize.width(context, 5)
      ),
      width: ScreenSize.width(context, 100),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(kCardBorderRadius)
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
      child: Column(
        children: <Widget>[
          SizedBox(
            height: ScreenSize.height(context, 1)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.dates,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              if (project.startDate != null || project.endDate != null)
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        if (project.startDate != null)
                          Text(
                            dateFormat.format(project.startDate!),
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        else
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => EditProjectPage(project)
                                )
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  FluentIcons.calendar_add_20_regular
                                ),
                                Text(
                                  AppLocalizations.of(context)!.startDate,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                    Text(
                      '-',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Row(
                      children: <Widget>[
                        if (project.endDate != null)
                          Text(
                            dateFormat.format(project.endDate!),
                            style: Theme.of(context).textTheme.bodyText1, 
                          )
                        else
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => EditProjectPage(project)
                                )
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                const Icon(FluentIcons.calendar_add_20_regular),
                                Text(
                                  AppLocalizations.of(context)!.endDate,
                                  style: Theme.of(context).textTheme.bodyText2
                                ),
                              ],
                            ),
                          )
                      ],
                    )
                  ],
                )
              else
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => EditProjectPage(project)
                      )
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      const Icon(FluentIcons.calendar_add_20_regular),
                      Text(
                        AppLocalizations.of(context)!.indefinite,
                        style: Theme.of(context).textTheme.bodyText2
                      ),
                    ],
                  ),
                )
            ]
          ),
          /* 
           * DESCRIPTION 
          */
          if (project.description != null && project.description!.isNotEmpty)
          ...[
            SizedBox(
              height: ScreenSize.height(context, 1)
            ),
            const Divider(),
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
          ],
          if (project.tasksCount != 0)
          ...[
            const Divider(),
            SizedBox(
              height: ScreenSize.height(context, 1)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularPercentIndicator(
                  radius: 150,
                  lineWidth: 12,
                  backgroundColor: Theme.of(context).textTheme.bodyText2!.color!,
                  progressColor: Theme.of(context).primaryColor,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  center: RichText(
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
                  percent: project.tasksCount != 0 
                    ? project.complitedTaskCount / project.tasksCount
                    : 0,
                )
              ],
            )
          ]
        ]
      ),
    );
  }
  
}