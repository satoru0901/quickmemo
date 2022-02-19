import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  const CustomFlatButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.borderRadius = 6.0,
      this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 15)})
      : super(key: key);
  final void Function() onPressed;
  final String label;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder<bool>(
        valueListenable: ValueNotifier(false),
        builder: (context, loading, child) {
          return TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(padding),
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius)),
              ),
              overlayColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColorDark),
              foregroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: onPressed,
            child: Text(label),
          );
        },
      ),
    );
  }
}
