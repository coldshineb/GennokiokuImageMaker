import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Util.dart';

mixin class SettingPage {
  //创建标题
  Text createHeading(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  //创建开关设置项
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

  //创建整数编辑设置项
  Material createChangeIntDialog(
      BuildContext context,
      String text,
      String subtext,
      String hintText,
      String currentText,
      ValueChanged<String> onChanged,
      VoidCallback onPressed) {
    return Material(
      color: settingPageMaterialColor(context),
      borderRadius: settingPageBorderRadius(),
      child: InkWell(
        borderRadius: settingPageBorderRadius(),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(text),
                  content: TextField(
                    decoration: InputDecoration(
                      hintText: hintText,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    controller: TextEditingController(text: currentText),
                    onChanged: onChanged,
                  ),
                  actions: [
                    TextButton(
                      onPressed: onPressed,
                      child: const Text('确定'),
                    ),
                  ],
                );
              });
        },
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
                        Text(
                          subtext,
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[600]),
                        ),
                      ],
                    )),
                    Container(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        currentText,
                        style:
                            const TextStyle(fontSize: 18.0, color: Colors.grey),
                      ),
                    )
                  ],
                ))),
      ),
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
