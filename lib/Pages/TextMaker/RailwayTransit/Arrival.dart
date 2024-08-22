import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Parent/TextMaker/TextMaker.dart';

class Arrival extends StatefulWidget {
  const Arrival({super.key});

  @override
  State<Arrival> createState() => _ArrivalState();
}

class _ArrivalState extends State<Arrival> with TextMaker {
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
                    const Text("常规线路 方向开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '守护商城站到了。请从列车运行方向的左侧车门下车，注意列车与站台之间的空隙。\nWe are now at calicy mall station, please get ready to exit on the left, mind the gap between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                '守护商城站到了。请从列车运行方向的左侧车门下车，注意列车与站台之间的空隙。We are now at calicy mall station, please get ready to exit on the left, mind the gap between the train and the platform.'));
                            copiedSnackbar(context);
                          },
                          style: buttonStyle(context),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("常规线路 两侧开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '常春公园站到了。下车时请注意列车与站台之间的空隙。\nWe are now at 常春公园 station, please mind the gap between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                '常春公园站到了。下车时请注意列车与站台之间的空隙。We are now at 常春公园 station, please mind the gap between the train and the platform.'));
                            copiedSnackbar(context);
                          },
                          style: buttonStyle(context),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("常规线路 终点站 方向开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '终点站，樱花谷站到了。请全体乘客带齐行李物品，从列车运行方向的右侧车门下车，注意列车与站台之间的空隙，谢谢合作。\nWe are now at the terminus, 樱花谷 station, please take all your belongings and exit on the right, mind the gap between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                '终点站，樱花谷站到了。请全体乘客带齐行李物品，从列车运行方向的右侧车门下车，注意列车与站台之间的空隙，谢谢合作。We are now at the terminus, 樱花谷 station, please take all your belongings and exit on the right, mind the gap between the train and the platform.'));
                            copiedSnackbar(context);
                          },
                          style: buttonStyle(context),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("常规线路 终点站 两侧开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '终点站，樱花谷站到了。请全体乘客带齐行李物品下车，注意列车与站台之间的空隙，谢谢合作。\nWe are now at the terminus, 樱花谷 station, please take all your belongings and exit, mind the gap between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                '终点站，樱花谷站到了。请全体乘客带齐行李物品下车，注意列车与站台之间的空隙，谢谢合作。We are now at the terminus, 樱花谷 station, please take all your belongings and exit, mind the gap between the train and the platform.'));
                            copiedSnackbar(context);
                          },
                          style: buttonStyle(context),
                          child: const Text('复制'),
                        )
                      ],
                    ), const SizedBox(height: 10.0),
                    const Text("小交线路 终点站 方向开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '终点站，青玉口站到了。请全体乘客带齐行李物品，从列车运行方向的左侧车门下车，注意列车与站台之间的空隙。前往红糖西城方向的乘客，请下车，等待下一趟列车，谢谢合作。\nWe are now at the terminus, 青玉口 station, please take all your belongings and exit on the left, mind the gap between the train and the platform. Passengers wishing to go to 红糖西 city, please disembark and wait for the next train.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                '终点站，青玉口站到了。请全体乘客带齐行李物品，从列车运行方向的左侧车门下车，注意列车与站台之间的空隙。前往红糖西城方向的乘客，请下车，等待下一趟列车，谢谢合作。We are now at the terminus, 青玉口 station, please take all your belongings and exit on the left, mind the gap between the train and the platform. Passengers wishing to go to 红糖西 city, please disembark and wait for the next train.'));
                            copiedSnackbar(context);
                          },
                          style: buttonStyle(context),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("小交线路 终点站 两侧开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '终点站，舫城寨站到了。请全体乘客带齐行李物品下车，注意列车与站台之间的空隙。前往洋红小镇方向的乘客，请下车，等待下一趟列车，谢谢合作。\nWe are now at the terminus, 舫城寨 station, please take all your belongings and exit, mind the gap between the train and the platform. Passengers wishing to go to 洋红小镇, please disembark and wait for the next train.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                '终点站，舫城寨站到了。请全体乘客带齐行李物品下车，注意列车与站台之间的空隙。前往洋红小镇方向的乘客，请下车，等待下一趟列车，谢谢合作。We are now at the terminus, 舫城寨 station, please take all your belongings and exit, mind the gap between the train and the platform. Passengers wishing to go to 洋红小镇, please disembark and wait for the next train.'));
                            copiedSnackbar(context);
                          },
                          style: buttonStyle(context),
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
                    const Text("常规线路 方向开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '樱花谷北站到了，可换乘S3号线。请从列车运行方向的左侧车门下车，注意列车与站台之间的空隙。\nWe are now at 樱花谷 north station, you can transfer to line s3, please get ready to exit on the left, mind the gap between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                '樱花谷北站到了，可换乘S3号线。请从列车运行方向的左侧车门下车，注意列车与站台之间的空隙。We are now at 樱花谷 north station, you can transfer to line s3, please get ready to exit on the left, mind the gap between the train and the platform.'));
                            copiedSnackbar(context);
                          },
                          style: buttonStyle(context),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("常规线路 两侧开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '守护中心站到了，可换乘1号线。下车时请注意列车与站台之间的空隙。\nWe are now at calicy center station, you can transfer to line 1, please mind the gap between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                '守护中心站到了，可换乘1号线。下车时请注意列车与站台之间的空隙。We are now at calicy center station, you can transfer to line 1, please mind the gap between the train and the platform.'));
                            copiedSnackbar(context);
                          },
                          style: buttonStyle(context),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("常规线路 终点站 方向开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '终点站，樱花谷站到了，可换乘S3号线。请全体乘客带齐行李物品，从列车运行方向的右侧车门下车，注意列车与站台之间的空隙，谢谢合作。\nWe are now at the terminus, 樱花谷 station, you can transfer to line s3, please take all your belongings and exit on the right, mind the gap between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                '终点站，樱花谷站到了，可换乘S3号线。请全体乘客带齐行李物品，从列车运行方向的右侧车门下车，注意列车与站台之间的空隙，谢谢合作。We are now at the terminus, 樱花谷 station, you can transfer to line s3, please take all your belongings and exit on the right, mind the gap between the train and the platform.'));
                            copiedSnackbar(context);
                          },
                          style: buttonStyle(context),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("常规线路 终点站 两侧开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '终点站，樱花谷站到了，可换乘S3号线。请全体乘客带齐行李物品下车，注意列车与站台之间的空隙，谢谢合作。\nWe are now at the terminus, 樱花谷 station, you can transfer to line s3, please take all your belongings and exit, mind the gap between the train and the platform.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                '终点站，樱花谷站到了，可换乘S3号线。请全体乘客带齐行李物品下车，注意列车与站台之间的空隙，谢谢合作。We are now at the terminus, 樱花谷 station, you can transfer to line s3, please take all your belongings and exit, mind the gap between the train and the platform.'));
                            copiedSnackbar(context);
                          },
                          style: buttonStyle(context),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("小交线路 终点站 方向开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '终点站，青玉口站到了，可换乘环山北线、环山南线。请全体乘客带齐行李物品，从列车运行方向的右侧车门下车，注意列车与站台之间的空隙。前往红糖西城方向的乘客，请下车，等待下一趟列车，谢谢合作。\nWe are now at the terminus, 青玉口 station, you can transfer to line MN, line MS, please take all your belongings and exit on the right, mind the gap between the train and the platform. Passengers wishing to go to 红糖西 city, please disembark and wait for the next train.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                '终点站，青玉口站到了，可换乘环山北线、环山南线。请全体乘客带齐行李物品，从列车运行方向的右侧车门下车，注意列车与站台之间的空隙。前往红糖西城方向的乘客，请下车，等待下一趟列车，谢谢合作。We are now at the terminus, 青玉口 station, you can transfer to line MN, line MS, please take all your belongings and exit on the right, mind the gap between the train and the platform. Passengers wishing to go to 红糖西 city, please disembark and wait for the next train.'));
                            copiedSnackbar(context);
                          },
                          style: buttonStyle(context),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text("小交线路 终点站 两侧开门",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '终点站，青玉口站到了，可换乘环山北线、环山南线。请全体乘客带齐行李物品下车，注意列车与站台之间的空隙。前往红糖西城方向的乘客，请下车，等待下一趟列车，谢谢合作。\nWe are now at the terminus, 青玉口 station, you can transfer to line MN, line MS, please take all your belongings and exit, mind the gap between the train and the platform. Passengers wishing to go to 红糖西 city, please disembark and wait for the next train.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                '终点站，青玉口站到了，可换乘环山北线、环山南线。请全体乘客带齐行李物品下车，注意列车与站台之间的空隙。前往红糖西城方向的乘客，请下车，等待下一趟列车，谢谢合作。We are now at the terminus, 青玉口 station, you can transfer to line MN, line MS, please take all your belongings and exit, mind the gap between the train and the platform. Passengers wishing to go to 红糖西 city, please disembark and wait for the next train.'));
                            copiedSnackbar(context);
                          },
                          style: buttonStyle(context),
                          child: const Text('复制'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
