import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    this.enabled = true,
    Key? key,
    this.text,
    this.icon,
    this.onTap,
    this.color,
    this.textColor,
    this.iconLeft = false,
    this.iconImage,
    this.padding, 
    this.fontSize, 
    this.width,
    this.borderRadius,
    required this.child
  }) : super(key: key);

  final double? width;
  final bool enabled;
  final Widget child;
  final String? text;
  final IconData? icon;
  final void Function()? onTap;
  final Color? color;
  final Color? textColor;
  final bool? iconLeft;
  final Image? iconImage;
  final EdgeInsets? padding;
  final double? fontSize;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(30),
        side: BorderSide.none,
      ),
      color: enabled 
        ? color ?? Colors.transparent
        : Colors.grey,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: enabled ? onTap : () {},
        child: Container(
          height: 50,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColorLight,
                Theme.of(context).primaryColorDark
              ]
            )
            ),
          child: Center(child: child),
        )
      ),
    );
  }
}
