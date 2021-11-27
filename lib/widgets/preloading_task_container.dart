import 'package:devject_single/utils/size.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'default_sizedbox.dart';

class PreloadingTaskContainer extends StatefulWidget {
  const PreloadingTaskContainer({Key? key}) : super(key: key);

  @override
  _PreloadingTaskContainerState createState() => _PreloadingTaskContainerState();
}

class _PreloadingTaskContainerState extends State<PreloadingTaskContainer> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSize.height(context, 10)),
      padding: EdgeInsets.all(AppSize.width(context, 20)),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              TyperAnimatedText(
                "...", 
                speed: const Duration(milliseconds: 200), 
                textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                  decoration: TextDecoration.underline
                )
              )
            ]
          ),
          const HeightSizedBox(20),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.responsible+": ", 
                style: Theme.of(context).textTheme.bodyText1
              ),
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TyperAnimatedText(
                    "...", 
                    speed: const Duration(milliseconds: 200), 
                    textAlign: TextAlign.start,
                    textStyle: Theme.of(context).textTheme.bodyText2
                  )
                ]
              )
            ]
          ),
          const HeightSizedBox(20),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.start+": ", 
                style: Theme.of(context).textTheme.bodyText1
              ),
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TyperAnimatedText(
                    "...", 
                    speed: const Duration(milliseconds: 200), 
                    textAlign: TextAlign.start,
                    textStyle: Theme.of(context).textTheme.bodyText2
                  )
                ]
              )
            ]
          ),
          const HeightSizedBox(20),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.end+": ", 
                style: Theme.of(context).textTheme.bodyText1
              ),
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TyperAnimatedText(
                    "...", 
                    speed: const Duration(milliseconds: 200), 
                    textAlign: TextAlign.start,
                    textStyle: Theme.of(context).textTheme.bodyText2
                  )
                ]
              )
            ]
          )
        ]
      )
    );
  }
}

