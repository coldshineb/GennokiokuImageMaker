import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Util.dart';

class Departure extends StatefulWidget {
  const Departure({super.key});

  @override
  State<Departure> createState() => _DepartureState();
}

class _DepartureState extends State<Departure> {
  TextEditingController commonLineController = TextEditingController();
  TextEditingController commonTerminusController = TextEditingController();
  TextEditingController commonTerminusENController = TextEditingController();
  TextEditingController commonNextController = TextEditingController();
  TextEditingController commonNextENController = TextEditingController();
  TextEditingController commonResultController = TextEditingController();
  TextEditingController commonPartLineController = TextEditingController();
  TextEditingController commonPartTerminusController = TextEditingController();
  TextEditingController commonPartTerminusENController =
      TextEditingController();
  TextEditingController commonPartPartTerminusController =
      TextEditingController();
  TextEditingController commonPartPartTerminusENController =
      TextEditingController();
  TextEditingController commonPartNextController = TextEditingController();
  TextEditingController commonPartNextENController = TextEditingController();
  TextEditingController commonPartResultController = TextEditingController();
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
  TextEditingController commonPartTransferLineController =
      TextEditingController();
  TextEditingController commonPartTransferTerminusController =
      TextEditingController();
  TextEditingController commonPartTransferTerminusENController =
      TextEditingController();
  TextEditingController commonPartTransferPartTerminusController =
      TextEditingController();
  TextEditingController commonPartTransferPartTerminusENController =
      TextEditingController();
  TextEditingController commonPartTransferNextController =
      TextEditingController();
  TextEditingController commonPartTransferNextENController =
      TextEditingController();
  TextEditingController commonPartTransferTransferLineController =
      TextEditingController();
  TextEditingController commonPartTransferTransferLineENController =
      TextEditingController();
  TextEditingController commonPartTransferResultController =
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
                      '出发',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '非环线 全程 一般站',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      '欢迎乘坐原忆轨道交通1号线。本次列车开往鸣希大道方向。下一站，守护中心。\nThis train is bound for 鸣希 avenue, the next station is calicy center.',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.train,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Tooltip(
                            message:
                                '一般线路添加“号线”，如“1号线”“S1号线”\n其它线路保持原样，如“南城环线”',
                            child: TextField(
                              controller: commonLineController,
                              decoration: const InputDecoration(
                                labelText: '线路',
                              ),
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
                          flex: 2,
                          child: TextField(
                            controller: commonTerminusController,
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
                          flex: 2,
                          child: TextField(
                            controller: commonTerminusENController,
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
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: commonNextController,
                            decoration: const InputDecoration(
                              labelText: '下一站（中）',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: commonNextENController,
                            decoration: const InputDecoration(
                              labelText: '下一站（英）',
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
                                  '欢迎乘坐原忆轨道交通${commonLineController.text}。本次列车开往${commonTerminusController.text}方向。下一站，${commonNextController.text}。\nThis train is bound for ${commonTerminusENController.text}, the next station is ${commonNextENController.text}.';
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
                      '出发',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '非环线 小交线 一般站',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      '欢迎乘坐原忆轨道交通18号线。本次列车开往洋红小镇方向。终点站，舫城寨。下一站，天云三路。\nThis train is bound for 洋红小镇, the terminus is 舫城寨, the next station is 天云三 road.',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.train,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Tooltip(
                            message:
                                '一般线路添加“号线”，如“1号线”“S1号线”\n其它线路保持原样，如“南城环线”',
                            child: TextField(
                              controller: commonPartLineController,
                              decoration: const InputDecoration(
                                labelText: '线路',
                              ),
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
                          flex: 2,
                          child: TextField(
                            controller: commonPartTerminusController,
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
                          flex: 2,
                          child: TextField(
                            controller: commonPartTerminusENController,
                            decoration: const InputDecoration(
                              labelText: '终点站（英）',
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
                          flex: 2,
                          child: TextField(
                            controller: commonPartPartTerminusController,
                            decoration: const InputDecoration(
                              labelText: '小交终点站（中）',
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
                          flex: 2,
                          child: TextField(
                            controller: commonPartPartTerminusENController,
                            decoration: const InputDecoration(
                              labelText: '小交终点站（英）',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: commonPartNextController,
                            decoration: const InputDecoration(
                              labelText: '下一站（中）',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: commonPartNextENController,
                            decoration: const InputDecoration(
                              labelText: '下一站（英）',
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
                              commonPartResultController.text =
                                  '欢迎乘坐原忆轨道交通${commonPartLineController.text}。本次列车开往${commonPartTerminusController.text}方向。终点站，${commonPartPartTerminusController.text}。下一站，${commonPartNextController.text}。\nThis train is bound for ${commonPartTerminusENController.text}, the terminus is ${commonPartPartTerminusENController.text}, the next station is ${commonPartNextENController.text}.';
                              Clipboard.setData(
                                ClipboardData(
                                  text: commonPartResultController.text,
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
                            controller: commonPartResultController,
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
                      '出发',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '非环线 全程 换乘站',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      '欢迎乘坐原忆轨道交通2号线。本次列车开往守护北站方向。下一站，守护中心，可换乘1号线。\nThis train is bound for calicy north station, the next station is calicy center, you can transfer to line 1.',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.train,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Tooltip(
                            message:
                                '一般线路添加“号线”，如“1号线”“S1号线”\n其它线路保持原样，如“南城环线”',
                            child: TextField(
                              controller: commonTransferLineController,
                              decoration: const InputDecoration(
                                labelText: '线路',
                              ),
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
                          flex: 2,
                          child: TextField(
                            controller: commonTransferTerminusController,
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
                          flex: 2,
                          child: TextField(
                            controller: commonTransferTerminusENController,
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
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: commonTransferNextController,
                            decoration: const InputDecoration(
                              labelText: '下一站（中）',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: commonTransferNextENController,
                            decoration: const InputDecoration(
                              labelText: '下一站（英）',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.transfer_within_a_station,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Tooltip(
                            message: '多个线路用全角顿号分隔，如“1号线、2号线、南城环线”',
                            child: TextField(
                              controller: commonTransferTransferLineController,
                              decoration: const InputDecoration(
                                labelText: '换乘线路（中）',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.transfer_within_a_station,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Tooltip(
                            message: '多个线路用半角逗号分隔，如“1,2,LS”',
                            child: TextField(
                              controller:
                                  commonTransferTransferLineENController,
                              decoration: const InputDecoration(
                                labelText: '换乘线路（英）',
                              ),
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
                              String transferLineEN = splitTransferLineEN(
                                  commonTransferTransferLineENController);
                              commonTransferResultController.text =
                                  '欢迎乘坐原忆轨道交通${commonTransferLineController.text}。本次列车开往${commonTransferTerminusController.text}方向。下一站，${commonTransferNextController.text}，可换乘${commonTransferTransferLineController.text}。\nThis train is bound for ${commonTransferTerminusENController.text}, the next station is ${commonTransferNextENController.text}, you can transfer to $transferLineEN.';
                              Clipboard.setData(
                                ClipboardData(
                                  text: commonTransferResultController.text,
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
                            controller: commonTransferResultController,
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
                      '出发',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '非环线 小交线 换乘站',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      '欢迎乘坐原忆轨道交通18号线。本次列车开往洋红小镇方向。终点站，舫城寨。下一站，云创立交，可换乘3号线、17号线。\nThis train is bound for 洋红小镇, the terminus is 舫城寨, the next station is 云创 interchange, you can transfer to line 3, line 17.',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.train,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Tooltip(
                            message:
                                '一般线路添加“号线”，如“1号线”“S1号线”\n其它线路保持原样，如“南城环线”',
                            child: TextField(
                              controller: commonPartTransferLineController,
                              decoration: const InputDecoration(
                                labelText: '线路',
                              ),
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
                          flex: 2,
                          child: TextField(
                            controller: commonPartTransferTerminusController,
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
                          flex: 2,
                          child: TextField(
                            controller: commonPartTransferTerminusENController,
                            decoration: const InputDecoration(
                              labelText: '终点站（英）',
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
                          flex: 2,
                          child: TextField(
                            controller:
                                commonPartTransferPartTerminusController,
                            decoration: const InputDecoration(
                              labelText: '小交终点站（中）',
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
                          flex: 2,
                          child: TextField(
                            controller:
                                commonPartTransferPartTerminusENController,
                            decoration: const InputDecoration(
                              labelText: '小交终点站（英）',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: commonPartTransferNextController,
                            decoration: const InputDecoration(
                              labelText: '下一站（中）',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: commonPartTransferNextENController,
                            decoration: const InputDecoration(
                              labelText: '下一站（英）',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.transfer_within_a_station,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Tooltip(
                            message: '多个线路用全角逗号分隔，如“1号线，2号线，南城环线”',
                            child: TextField(
                              controller:
                                  commonPartTransferTransferLineController,
                              decoration: const InputDecoration(
                                labelText: '换乘线路（中）',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.transfer_within_a_station,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Tooltip(
                            message: '多个线路用半角逗号分隔，如“1,2,LS”',
                            child: TextField(
                              controller:
                                  commonPartTransferTransferLineENController,
                              decoration: const InputDecoration(
                                labelText: '换乘线路（英）',
                              ),
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
                              String transferLineEN = splitTransferLineEN(
                                  commonPartTransferTransferLineENController);
                              commonPartTransferResultController.text =
                                  '欢迎乘坐原忆轨道交通${commonPartTransferLineController.text}。本次列车开往${commonPartTransferTerminusController.text}方向。终点站，${commonPartTransferPartTerminusController.text}。下一站，${commonPartTransferNextController.text}，可换乘${commonPartTransferTransferLineController.text}。\nThis train is bound for ${commonPartTransferTerminusENController.text}, the terminus is ${commonPartTransferPartTerminusENController.text}, the next station is ${commonPartTransferNextENController.text}, you can transfer to $transferLineEN.';
                              Clipboard.setData(
                                ClipboardData(
                                  text: commonPartTransferResultController.text,
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
                            controller: commonPartTransferResultController,
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

  String splitTransferLineEN(controller) {
    List<String> transferLinesEN = controller.text.split(',');
    String transferLineEN = '';
    for (int i = 0; i < transferLinesEN.length; i++) {
      transferLineEN += 'line ${transferLinesEN[i]}';
      if (i != transferLinesEN.length - 1) {
        transferLineEN += ', ';
      }
    }
    return transferLineEN;
  }
}
