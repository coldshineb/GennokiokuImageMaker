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
                      '出发',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '非环线 一般站',
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
                        const SizedBox(width: 10.0),
                        Checkbox(
                            value: isPartRouteCommon,
                            onChanged: (bool? value) {
                              setState(() {
                                isPartRouteCommon = value!;
                              });
                            }),
                        const Text("小交线"),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.last_page,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            enabled: isPartRouteCommon,
                            controller: commonPartTerminusController,
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
                            enabled: isPartRouteCommon,
                            controller: commonPartTerminusENController,
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
                                  '欢迎乘坐原忆轨道交通${commonLineController.text}。本次列车开往${commonTerminusController.text}方向。${isPartRouteCommon ? "终点站，${commonPartTerminusController.text}。" : ""}下一站，${commonNextController.text}。\nThis train is bound for ${commonTerminusENController.text},${isPartRouteCommon ? " the terminus is ${commonPartTerminusENController.text}," : ""} the next station is ${commonNextENController.text}.';
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
                      '非环线 换乘站',
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
                        const SizedBox(width: 10.0),
                        Checkbox(
                            value: isPartRouteTransfer,
                            onChanged: (bool? value) {
                              setState(() {
                                isPartRouteTransfer = value!;
                              });
                            }),
                        const Text("小交线"),
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.last_page,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            enabled: isPartRouteTransfer,
                            controller: commonTransferPartTerminusController,
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
                            enabled: isPartRouteTransfer,
                            controller: commonTransferPartTerminusENController,
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
                                  '欢迎乘坐原忆轨道交通${commonTransferLineController.text}。本次列车开往${commonTransferTerminusController.text}方向。${isPartRouteTransfer ? "终点站，${commonTransferPartTerminusController.text}。" : ""}下一站，${commonTransferNextController.text}，可换乘${commonTransferTransferLineController.text}。\nThis train is bound for ${commonTransferTerminusENController.text},${isPartRouteTransfer ? " the terminus is ${commonTransferPartTerminusENController.text}," : ""} the next station is ${commonTransferNextENController.text}, you can transfer to $transferLineEN.';
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
                      '非环线 一般终点站',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text("常规线路",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '欢迎乘坐原忆轨道交通4号线。本次列车开往红糖西城方向。下一站，终点站，红糖西城，请全体乘客带齐行李物品，做好下车准备。\nThis train is bound for 红糖西 city, the next station is the terminus, 红糖西 city, please take all your belongings and get ready to exit.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                    '欢迎乘坐原忆轨道交通4号线。本次列车开往红糖西城方向。下一站，终点站，红糖西城，请全体乘客带齐行李物品，做好下车准备。This train is bound for 红糖西 city, the next station is the terminus, 红糖西 city, please take all your belongings and get ready to exit.'));
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
                    const Text("小交线路",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '欢迎乘坐原忆轨道交通18号线。本次列车开往洋红小镇方向。终点站，舫城寨。下一站，终点站，舫城寨，请全体乘客带齐行李物品，做好下车准备。\nThis train is bound for 洋红小镇, the terminus is 舫城寨, the next station is the terminus, 舫城寨, please take all your belongings and get ready to exit.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                    '欢迎乘坐原忆轨道交通18号线。本次列车开往洋红小镇方向。终点站，舫城寨。下一站，终点站，舫城寨，请全体乘客带齐行李物品，做好下车准备。This train is bound for 洋红小镇, the terminus is 舫城寨, the next station is the terminus, 舫城寨, please take all your belongings and get ready to exit.'));
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
                      '出发',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '非环线 换乘终点站',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text("常规线路",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '欢迎乘坐原忆轨道交通16号线。本次列车开往黄川枢纽中心方向。下一站，终点站，黄川枢纽中心，可换乘17号线，请全体乘客带齐行李物品，做好下车准备。\nThis train is bound for 黄川 hub, the next station is the terminus, 黄川 hub, you can transfer to line 17, please take all your belongings and get ready to exit.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                    '欢迎乘坐原忆轨道交通16号线。本次列车开往黄川枢纽中心方向。下一站，终点站，黄川枢纽中心，可换乘17号线，请全体乘客带齐行李物品，做好下车准备。This train is bound for 黄川 hub, the next station is the terminus, 黄川 hub, you can transfer to line 17, please take all your belongings and get ready to exit.'));
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
                    const Text("小交线路",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '欢迎乘坐原忆轨道交通3号线。本次列车开往草风佳地方向。终点站，嘉橙体育中心。下一站，终点站，嘉橙体育中心，可换乘21号线，请全体乘客带齐行李物品，做好下车准备。\nThis train is bound for 草风佳地, the terminus is 嘉橙体育中心, the next station is the terminus, 嘉橙体育中心, you can transfer to line 21, please take all your belongings and get ready to exit.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text:
                                    '欢迎乘坐原忆轨道交通3号线。本次列车开往草风佳地方向。终点站，嘉橙体育中心。下一站，终点站，嘉橙体育中心，可换乘21号线，请全体乘客带齐行李物品，做好下车准备。This train is bound for 草风佳地, the terminus is 嘉橙体育中心, the next station is the terminus, 嘉橙体育中心, you can transfer to line 21, please take all your belongings and get ready to exit.'));
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
