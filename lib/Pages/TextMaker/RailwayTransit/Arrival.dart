import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Util.dart';

class Arrival extends StatefulWidget {
  const Arrival({super.key});

  @override
  State<Arrival> createState() => _ArrivalState();
}

class _ArrivalState extends State<Arrival> {
  TextEditingController commonLineController = TextEditingController();
  TextEditingController commonTerminusController = TextEditingController();
  TextEditingController commonTerminusENController = TextEditingController();
  TextEditingController commonNextController = TextEditingController();
  TextEditingController commonNextENController = TextEditingController();
  TextEditingController commonResultController = TextEditingController();
  bool isPartRouteCommon = false;
  TextEditingController commonPartTerminusController = TextEditingController();
  TextEditingController commonPartTerminusENController =
      TextEditingController();
  TextEditingController commonTransferLineController = TextEditingController();
  TextEditingController commonTransferTerminusController =
      TextEditingController();
  TextEditingController commonTransferTerminusENController =
      TextEditingController();
  TextEditingController commonTransferNextController = TextEditingController();
  TextEditingController commonTransferNextENController =
      TextEditingController();
  TextEditingController commonTransferTransferLineController =
      TextEditingController();
  TextEditingController commonTransferTransferLineENController =
      TextEditingController();
  TextEditingController commonTransferResultController =
      TextEditingController();
  bool isPartRouteTransfer = false;
  TextEditingController commonTransferPartTerminusController =
      TextEditingController();
  TextEditingController commonTransferPartTerminusENController =
      TextEditingController();

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
                      '到站',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '一般站',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text("方向开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '守护商城站到了。请从列车运行方向的左侧车门下车，注意列车与站台之间的空隙。\nWe are now at calicy mall station, please get ready to exit on the left, mind the step between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                    '守护商城站到了。请从列车运行方向的左侧车门下车，注意列车与站台之间的空隙。We are now at calicy mall station, please get ready to exit on the left, mind the step between the train and the platform.'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              margin: EdgeInsets.all(10.0),
                              behavior: SnackBarBehavior.floating,
                              content: Text("已复制到剪贴板"),
                            ));
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.pink[50]
                                    : Util.darkColorScheme().onSecondary),
                          ),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("两侧开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '常春公园站到了。下车时请注意列车与站台之间的空隙。\nWe are now at 常春公园 station, please mind the step between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                    '常春公园站到了。下车时请注意列车与站台之间的空隙。We are now at 常春公园 station, please mind the step between the train and the platform.'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              margin: EdgeInsets.all(10.0),
                              behavior: SnackBarBehavior.floating,
                              content: Text("已复制到剪贴板"),
                            ));
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.pink[50]
                                    : Util.darkColorScheme().onSecondary),
                          ),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("终点站 方向开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '终点站，樱花谷站到了。请全体乘客带齐行李物品，从列车运行方向的右侧车门下车，注意列车与站台之间的空隙，谢谢合作。\nWe are now at the terminus, 樱花谷 station, please take all your belongings and exit on the right, mind the step between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                    '终点站，樱花谷站到了。请全体乘客带齐行李物品，从列车运行方向的右侧车门下车，注意列车与站台之间的空隙，谢谢合作。We are now at the terminus, 樱花谷 station, please take all your belongings and exit on the right, mind the step between the train and the platform.'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              margin: EdgeInsets.all(10.0),
                              behavior: SnackBarBehavior.floating,
                              content: Text("已复制到剪贴板"),
                            ));
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.pink[50]
                                    : Util.darkColorScheme().onSecondary),
                          ),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("终点站 两侧开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '终点站，樱花谷站到了。请全体乘客带齐行李物品下车，注意列车与站台之间的空隙，谢谢合作。\nWe are now at the terminus, 樱花谷 station, please take all your belongings and exit, mind the step between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                    '终点站，樱花谷站到了。请全体乘客带齐行李物品下车，注意列车与站台之间的空隙，谢谢合作。We are now at the terminus, 樱花谷 station, please take all your belongings and exit, mind the step between the train and the platform.'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              margin: EdgeInsets.all(10.0),
                              behavior: SnackBarBehavior.floating,
                              content: Text("已复制到剪贴板"),
                            ));
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.pink[50]
                                    : Util.darkColorScheme().onSecondary),
                          ),
                          child: const Text('复制'),
                        )
                      ],
                    ),
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
                      '到站',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '换乘站',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text("方向开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '樱花谷北站到了，可换乘S3号线。请从列车运行方向的左侧车门下车，注意列车与站台之间的空隙。\nWe are now at 樱花谷 north station, you can transfer to line s3, please get ready to exit on the left, mind the step between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                    '樱花谷北站到了，可换乘S3号线。请从列车运行方向的左侧车门下车，注意列车与站台之间的空隙。We are now at 樱花谷 north station, you can transfer to line s3, please get ready to exit on the left, mind the step between the train and the platform.'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              margin: EdgeInsets.all(10.0),
                              behavior: SnackBarBehavior.floating,
                              content: Text("已复制到剪贴板"),
                            ));
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.pink[50]
                                    : Util.darkColorScheme().onSecondary),
                          ),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("两侧开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '守护中心站到了，可换乘1号线。下车时请注意列车与站台之间的空隙。\nWe are now at calicy center station, you can transfer to line 1, please mind the step between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                    '守护中心站到了，可换乘1号线。下车时请注意列车与站台之间的空隙。We are now at calicy center station, you can transfer to line 1, please mind the step between the train and the platform.'));
                                ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              margin: EdgeInsets.all(10.0),
                              behavior: SnackBarBehavior.floating,
                              content: Text("已复制到剪贴板"),
                            ));
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.pink[50]
                                    : Util.darkColorScheme().onSecondary),
                          ),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("终点站 方向开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '终点站，樱花谷站到了，可换乘S3号线。请全体乘客带齐行李物品，从列车运行方向的右侧车门下车，注意列车与站台之间的空隙，谢谢合作。\nWe are now at the terminus, 樱花谷 station, you can transfer to line s3, please take all your belongings and exit on the right, mind the step between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                    '终点站，樱花谷站到了，可换乘S3号线。请全体乘客带齐行李物品，从列车运行方向的右侧车门下车，注意列车与站台之间的空隙，谢谢合作。We are now at the terminus, 樱花谷 station, you can transfer to line s3, please take all your belongings and exit on the right, mind the step between the train and the platform.'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              margin: EdgeInsets.all(10.0),
                              behavior: SnackBarBehavior.floating,
                              content: Text("已复制到剪贴板"),
                            ));
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.pink[50]
                                    : Util.darkColorScheme().onSecondary),
                          ),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("终点站 两侧开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '终点站，樱花谷站到了，可换乘S3号线。请全体乘客带齐行李物品下车，注意列车与站台之间的空隙，谢谢合作。\nWe are now at the terminus, 樱花谷 station, you can transfer to line s3, please take all your belongings and exit, mind the step between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                    '终点站，樱花谷站到了，可换乘S3号线。请全体乘客带齐行李物品下车，注意列车与站台之间的空隙，谢谢合作。We are now at the terminus, 樱花谷 station, you can transfer to line s3, please take all your belongings and exit, mind the step between the train and the platform.'));
                                ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              margin: EdgeInsets.all(10.0),
                              behavior: SnackBarBehavior.floating,
                              content: Text("已复制到剪贴板"),
                            ));
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.pink[50]
                                    : Util.darkColorScheme().onSecondary),
                          ),
                          child: const Text('复制'),
                        )
                      ],
                    ),
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
