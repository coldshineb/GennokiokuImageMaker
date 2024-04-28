import 'package:flutter/material.dart';

import '../Util.dart';

mixin class SettingPage {
  //创建开关
  Material createSwitch(BuildContext context, GestureTapCallback onTap,
      String text, String subtext, bool value, ValueChanged<bool> onChanged) {
    return Material(
      color: settingPageMaterialColor(context),
      borderRadius: settingPageBorderRadius(),
      child: InkWell(
          borderRadius: settingPageBorderRadius(),
          onTap: onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: settingPageBorderRadius(),
              ),
              padding: settingPageEdgeInsets(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      subtext != ''
                          ? Text(
                              subtext,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.grey[600]),
                            )
                          : Container(),
                    ],
                  )),
                  Switch(
                    value: value,
                    onChanged: onChanged,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  EdgeInsets settingPageEdgeInsets() => const EdgeInsets.all(10.0);

  BorderRadius settingPageBorderRadius() => BorderRadius.circular(10.0);

  Color? settingPageMaterialColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.pink[50]
        : Util.darkColorScheme().onSecondary;
  }
}
