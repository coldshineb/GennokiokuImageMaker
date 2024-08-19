import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Parent/TextMaker/TextMaker.dart';

class Rule extends StatefulWidget {
  const Rule({super.key});

  @override
  State<Rule> createState() => _RuleState();
}

class _RuleState extends State<Rule> with TextMaker {
  TextEditingController commonStationController = TextEditingController();
  TextEditingController commonStationENController = TextEditingController();
  TextEditingController commonResultController = TextEditingController();
  int loopDirection = 1;
  TextEditingController loopInnerStationController = TextEditingController();
  TextEditingController loopInnerStationENController = TextEditingController();
  TextEditingController loopInnerResultController = TextEditingController();
  TextEditingController loopOuterStationController = TextEditingController();
  TextEditingController loopOuterStationENController = TextEditingController();
  TextEditingController loopOuterResultController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Card(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(flex:1,child: Text('类型',style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex:3,child: Text('要求',style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(flex:1,child: Text('线路')),
                          Expanded(flex:3,child: Text('一般线路使用数字或字母（如果有），中文线路使用中文')),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(flex:1,child: Text('终点站（英）')),
                          Expanded(flex:3,child: Text('大部分专属站名使用中文，部分专属站名使用中文+英文翻译，数字使用英文，简写使用全称')),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(flex:1,child: Text('经过站（英）')),
                          Expanded(flex:3,child: Text('大部分专属站名使用中文，部分专属站名使用中文+英文翻译，数字使用英文，简写使用全称')),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(flex:1,child: Text('出口编号')),
                          Expanded(flex:3,child: Text('使用字母编号')),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(flex:1,child: Text('下一站（英）')),
                          Expanded(flex:3,child: Text('大部分专属站名使用中文，部分专属站名使用中文+英文翻译，数字使用英文，简写使用全称')),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(flex:1,child: Text('换乘线路（中）')),
                          Expanded(flex:3,child: Text('一般线路使用数字或字母（如果有），中文线路使用中文')),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(flex:1,child: Text('换乘线路（英）')),
                          Expanded(flex:3,child: Text('一般线路使用英文，中文线路使用简写名')),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(flex:1,child: Text('站名（英）')),
                          Expanded(flex:3,child: Text('大部分专属站名使用中文，部分专属站名使用中文+英文翻译，数字使用英文，简写使用全称')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
