import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Util.dart';

class BroadcastText extends StatefulWidget {
  const BroadcastText({super.key});

  @override
  State<BroadcastText> createState() => _BroadcastTextState();
}

class _BroadcastTextState extends State<BroadcastText> {
  TextEditingController commonStationController = TextEditingController();
  TextEditingController commonStationENController = TextEditingController();
  TextEditingController commonResultController = TextEditingController();
  TextEditingController loopInnerStationController = TextEditingController();
  TextEditingController loopInnerStationENController = TextEditingController();
  TextEditingController loopInnerResultController = TextEditingController();
  TextEditingController loopOuterStationController = TextEditingController();
  TextEditingController loopOuterStationENController = TextEditingController();
  TextEditingController loopOuterResultController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '进站',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '非环线',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      '开往郁水街方向的列车即将进站，请按照地面标识指引排队候车，先下后上，注意列车与站台之间的空隙。\nThe train bound for 郁水 street is arriving, please line up by the signs on the ground, and give a way to alighting passengers, please mind the gap between the train and the platform.',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.last_page,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: commonStationController,
                            decoration: const InputDecoration(
                              labelText: '终点站（中）',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.last_page,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: commonStationENController,
                            decoration: const InputDecoration(
                              labelText: '终点站（英）',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              commonResultController.text =
                                  '开往${commonStationController.text}方向的列车即将进站，请按照地面标识指引排队候车，先下后上，注意列车与站台之间的空隙。\nThe train bound for ${commonStationENController.text} is arriving, please line up by the signs on the ground, and give a way to alighting passengers, please mind the gap between the train and the platform.';
                              Clipboard.setData(
                                ClipboardData(
                                  text: commonResultController.text,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                margin: EdgeInsets.all(10.0),
                                behavior: SnackBarBehavior.floating,
                                content: Text("已生成并复制到剪贴板"),
                              ));
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.pink[50]
                                      : Util.darkColorScheme().onSecondary),
                            ),
                            child: const Text('生成'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.text_format,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: commonResultController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: '文本',
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '进站',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '环线（内）',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      '内环运行经赤羽站的列车即将进站，请按照地面标识指引排队候车，先下后上，注意列车与站台之间的空隙。\nThe train running in inner ring via 赤羽 station is arriving, please line up by the signs on the ground, and give a way to alighting passengers, please mind the step between the train and the platform.',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.last_page,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: loopInnerStationController,
                            decoration: const InputDecoration(
                              labelText: '终点站（中）',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.last_page,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: loopInnerStationENController,
                            decoration: const InputDecoration(
                              labelText: '终点站（英）',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              loopInnerResultController.text =
                                  '内环运行经${loopInnerStationController.text}站的列车即将进站，请按照地面标识指引排队候车，先下后上，注意列车与站台之间的空隙。\nThe train running in inner ring via ${loopInnerStationENController.text} station is arriving, please line up by the signs on the ground, and give a way to alighting passengers, please mind the step between the train and the platform.';
                              Clipboard.setData(
                                ClipboardData(
                                  text: loopInnerResultController.text,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                margin: EdgeInsets.all(10.0),
                                behavior: SnackBarBehavior.floating,
                                content: Text("已生成并复制到剪贴板"),
                              ));
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.pink[50]
                                      : Util.darkColorScheme().onSecondary),
                            ),
                            child: const Text('生成'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.text_format,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: loopInnerResultController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: '文本',
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '进站',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '环线（外）',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      '外环运行经赤羽站的列车即将进站，请按照地面标识指引排队候车，先下后上，注意列车与站台之间的空隙。\nThe train running in outer ring via 赤羽 station is arriving, please line up by the signs on the ground, and give a way to alighting passengers, please mind the step between the train and the platform.',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.last_page,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: loopOuterStationController,
                            decoration: const InputDecoration(
                              labelText: '终点站（中）',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.last_page,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: loopOuterStationENController,
                            decoration: const InputDecoration(
                              labelText: '终点站（英）',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              loopOuterResultController.text =
                                  '外环运行经${loopOuterStationController.text}站的列车即将进站，请按照地面标识指引排队候车，先下后上，注意列车与站台之间的空隙。\nThe train running in outer ring via ${loopOuterStationENController.text} station is arriving, please line up by the signs on the ground, and give a way to alighting passengers, please mind the step between the train and the platform.';
                              Clipboard.setData(
                                ClipboardData(
                                  text: loopOuterResultController.text,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                margin: EdgeInsets.all(10.0),
                                behavior: SnackBarBehavior.floating,
                                content: Text("已生成并复制到剪贴板"),
                              ));
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.pink[50]
                                      : Util.darkColorScheme().onSecondary),
                            ),
                            child: const Text('生成'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.text_format,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: loopOuterResultController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: '文本',
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
