import 'package:devject_single/cubit/curret_tasks_cubit.dart';
import 'package:devject_single/cubit/projects_cubit.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/utils/screen_size.dart';
import 'package:devject_single/widgets/appbar.dart';
import 'package:devject_single/widgets/current_task_container.dart';
import 'package:devject_single/widgets/main_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = 'HomePage';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurretTasksCubit, List<Task>>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            await context.read<CurretTasksCubit>().load();
          },
          child: Scaffold(
            appBar: buildAppBar(
              context,
              title: AppLocalizations.of(context)!.currentTasks
            ),
            body: buildBody(context),
            bottomNavigationBar: const MainBottomNavBar(),
          ),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    context.read<ProjectsCubit>().load();
    context.read<CurretTasksCubit>().load();
    final currentTasksCubit = context.read<CurretTasksCubit>();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.width(context, 5)
      ),
      child: Column(
        children: [
          currentTasksCubit.state.isNotEmpty 
          ? Expanded(
            flex: 4,
            child: ListView.builder(
              itemCount: currentTasksCubit.state.length,
              itemBuilder: (context, index) => 
                CurrentTaskContainer(currentTasksCubit.state[index])
            )
          )
          : Expanded(
            child: SizedBox(
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.noCurrentTasks,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ),
            ),
          )
        ]
      ),
    );
  }
}