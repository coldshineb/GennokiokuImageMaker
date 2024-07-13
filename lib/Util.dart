import 'dart:io';

import 'package:flutter/material.dart';

import 'Preference.dart';
import 'main.dart';

class Util {
  static const String appVersion = '1.4';
  static const String copyright =
      '版权所有 © Calicy LLC 2022-2024 Gennokioku 原忆 2022-2024 Coldshine 2020-2024，由 Flutter 强力驱动';

  //轨道交通标识
  //如后续有修改，需要改 arrivalStationInfoBody.svg 以下内容
  //字体 FZLTHProGlobal-Regular, &apos;FZLTHPro Global&apos; 改为 GennokiokuLCDFont
  static const String railwayTransitLogo = "";

  //已到站 站点信息图主体部分
  //如后续有修改，需要改以下内容
  //1.主体颜色改为 lineColor，保留 #
  //2.字体 FZLTHProGlobal-Regular, &apos;FZLTHPro Global&apos; 改为 GennokiokuLCDFont
  //3.字体颜色 #fff 改为 fontColor，保留 #
  static const String arrivalStationInfoBody = '''
<?xml version="1.0" encoding="UTF-8"?>
<svg id="_图层_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1481 307.86">
    <g id="_图层_1-2">
        <rect x="2.5" y="2.5" width="1476" height="302.86" rx="25.71" ry="25.71" fill="none" stroke="#lineColor"
              stroke-miterlimit="10" stroke-width="5"/>
        <path d="M180.67,156.08c-1.81.07-3.94.31-6.27.88-4.68,1.15-8.24,3.16-10.57,4.76-6.07,3.76-13.4,9.25-20.38,17.14-16.01,18.1-20.7,38.09-22.29,48.05v15.3c0,2.93,2.37,5.3,5.3,5.3h54.21c2.93,0,5.3-2.37,5.3-5.3v-80.84c0-2.93-2.37-5.3-5.3-5.3Z"
              fill="#595757" stroke-width="0"/>
        <path d="M1284.03,156.08c1.81.07,3.94.31,6.27.88,4.68,1.15,8.24,3.16,10.57,4.76,6.07,3.76,13.4,9.25,20.38,17.14,16.01,18.1,20.7,38.09,22.29,48.05,0,5.1,0,10.2,0,15.3,0,2.93-2.37,5.3-5.3,5.3h-54.21c-2.93,0-5.3-2.37-5.3-5.3v-80.84c0-2.93,2.37-5.3,5.3-5.3Z"
              fill="#595757" stroke-width="0"/>
        <rect x="145.97" y="30.14" width="80" height="49.1" fill="#lineColor" stroke-width="0"/>
        <text transform="translate(172.21 68.02)" fill="#fontColor"
              font-family="GennokiokuLCDFont;" font-size="40.53">
            <tspan x="0" y="0">A</tspan>
        </text>
        <rect x="145.97" y="83.8" width="80" height="49.1" fill="#lineColor" stroke-width="0"/>
        <text transform="translate(171.4 121.68)" fill="#fontColor"
              font-family="GennokiokuLCDFont;" font-size="40.53">
            <tspan x="0" y="0">D</tspan>
        </text>
        <rect x="1235.49" y="30.14" width="80" height="49.1" fill="#lineColor" stroke-width="0"/>
        <text transform="translate(1262.93 68.02)" fill="#fontColor"
              font-family="GennokiokuLCDFont;" font-size="40.53">
            <tspan x="0" y="0">B</tspan>
        </text>
        <rect x="1235.49" y="83.8" width="80" height="49.1" fill="#lineColor" stroke-width="0"/>
        <text transform="translate(1261.63 121.68)" fill="#fontColor"
              font-family="GennokiokuLCDFont;" font-size="40.53">
            <tspan x="0" y="0">C</tspan>
        </text>
        <rect x="510.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29" fill="none" stroke="#lineColor"
              stroke-miterlimit="10" stroke-width="2"/>
        <path d="M533.22,90.86c-3.3-1.05-6.39,1.45-6.39,4.61,0,1.68.88,3.17,2.2,4.04-1.31.87-2.2,2.36-2.2,4.04v6.8l-2.47,2.47h-2.85c-2.65,0-5.12,1.53-6.16,3.97-2.13,4.98,1.54,9.83,6.28,9.83h7.55l19.83-19.83h1.81c3.06,0,5.86-2.02,6.53-5,.94-4.19-2.27-7.93-6.3-7.93h-7.14l-7.79,7.79c-.38-.87-1-1.61-1.79-2.13,1.71-1.14,2.68-3.32,1.94-5.61-.47-1.43-1.62-2.58-3.06-3.04ZM531.97,93.77c.92,0,1.62.71,1.62,1.62s-.7,1.62-1.62,1.62-1.62-.71-1.62-1.62.71-1.62,1.62-1.62ZM545.77,96.44h5.56c1.47,0,2.81.93,3.23,2.34.72,2.42-1,4.56-3.28,4.56h-3.61l-19.83,19.83h-5.56c-1.47,0-2.81-.93-3.23-2.34-.72-2.42,1-4.56,3.28-4.56h3.61l19.83-19.83ZM533.72,103.39v1s-3.45,3.45-3.45,3.45v-4.43c0-1.24,1.3-2.16,2.59-1.51.55.28.86.88.86,1.49Z"
              fill="#000" stroke-width="0"/>
        <rect x="909.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29" fill="none" stroke="#lineColor"
              stroke-miterlimit="10" stroke-width="2"/>
        <path d="M938.03,90.86c3.3-1.05,6.39,1.45,6.39,4.61,0,1.68-.88,3.17-2.2,4.04,1.31.87,2.2,2.36,2.2,4.04v6.8l2.47,2.47h2.85c2.65,0,5.12,1.53,6.16,3.97,2.13,4.98-1.54,9.83-6.28,9.83h-7.55l-19.83-19.83h-1.81c-3.06,0-5.86-2.02-6.53-5-.94-4.19,2.27-7.93,6.3-7.93h7.14l7.79,7.79c.38-.87,1-1.61,1.79-2.13-1.71-1.14-2.68-3.32-1.94-5.61.47-1.43,1.62-2.58,3.06-3.04ZM939.28,93.77c-.92,0-1.62.71-1.62,1.62s.7,1.62,1.62,1.62,1.62-.71,1.62-1.62-.71-1.62-1.62-1.62ZM925.48,96.44h-5.56c-1.47,0-2.81.93-3.23,2.34-.72,2.42,1,4.56,3.28,4.56h3.61l19.83,19.83h5.56c1.47,0,2.81-.93,3.23-2.34.72-2.42-1-4.56-3.28-4.56h-3.61l-19.83-19.83ZM937.52,103.39v1s3.45,3.45,3.45,3.45v-4.43c0-1.24-1.3-2.16-2.59-1.51-.55.28-.86.88-.86,1.49Z"
              fill="#000" stroke-width="0"/>
        <rect x="645.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29" fill="none" stroke="#lineColor"
              stroke-miterlimit="10" stroke-width="2"/>
        <path d="M665.33,85.53l-5.09,5.09h10.18l-5.09-5.09ZM673.81,85.62l5.09,5.09,5.09-5.09h-10.18ZM651.76,95.62v36h41v-36h-41ZM654.76,98.62h34v29h-34v-29ZM666.19,101.2c-2.93-.98-5.71,1.22-5.71,4,0,1.3.62,2.45,1.55,3.23-1.92.99-3.27,2.96-3.27,5.25v5.94h2v7h3v-10h-2v-2.42c0-1.29,1.04-2.58,2.33-2.66,1.48-.1,2.67,1.06,2.67,2.54v2.54h-2v10h4v-7h2v-5.94c0-2.29-1.35-4.25-3.27-5.25,1.18-.99,1.85-2.56,1.42-4.28-.35-1.37-1.39-2.51-2.73-2.96ZM681.19,101.2c-2.93-.98-5.71,1.22-5.71,4,0,1.3.62,2.45,1.55,3.23-1.92.99-3.27,2.96-3.27,5.25v5.94h2v7h3v-10h-2v-2.42c0-1.29,1.04-2.58,2.33-2.66,1.48-.1,2.67,1.06,2.67,2.54v2.54h-1v10h3v-7h2v-5.94c0-2.29-1.35-4.25-3.27-5.25,1.18-.99,1.85-2.56,1.42-4.28-.35-1.37-1.39-2.51-2.73-2.96ZM664.48,104.27c.49,0,.85.36.85.85s-.36.85-.85.85-.85-.36-.85-.85.36-.85.85-.85ZM679.74,104.27c.49,0,.85.36.85.85s-.36.85-.85.85-.85-.36-.85-.85.36-.85.85-.85Z"
              fill="#000" stroke-width="0"/>
        <rect x="447.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29" fill="none" stroke="#lineColor"
              stroke-miterlimit="10" stroke-width="2"/>
        <path d="M481.88,90.62v8.71h-8.71v8.71h-8.71v8.71h-8.71v11.88h3.17v-8.71h8.71v-8.71h8.71v-8.71h8.71v-8.71h8.71v-3.17h-11.88Z"
              fill="#000" stroke-width="0"/>
        <rect x="846.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29"
              transform="translate(1745.52 217.24) rotate(180)" fill="none" stroke="#lineColor" stroke-miterlimit="10"
              stroke-width="2"/>
        <path d="M864.63,90.62v8.71h8.71v8.71h8.71v8.71h8.71v11.88h-3.17v-8.71h-8.71v-8.71h-8.71v-8.71h-8.71v-8.71h-8.71v-3.17h11.88Z"
              fill="#000" stroke-width="0"/>
        <rect x="1053.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29"
              transform="translate(2159.52 217.24) rotate(-180)" fill="none" stroke="#lineColor" stroke-miterlimit="10"
              stroke-width="2"/>
        <path d="M1071.63,90.62v8.71h8.71v8.71h8.71v8.71h8.71v11.88h-3.17v-8.71h-8.71v-8.71h-8.71v-8.71h-8.71v-8.71h-8.71v-3.17h11.88Z"
              fill="#000" stroke-width="0"/>
        <rect x="242.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29" fill="none" stroke="#lineColor"
              stroke-miterlimit="10" stroke-width="2"/>
        <path d="M259.48,90.62c-2.54,0-4.63,2.09-4.63,4.63s2.09,4.63,4.63,4.63,4.63-2.09,4.63-4.63-2.09-4.63-4.63-4.63ZM259.44,99.83h-3.04c-2.55,0-4.63,2.09-4.63,4.63v8.75l3.07,3.09v11.17h3.07v-12.54l-3.07-3.07v-7.42c0-.85.69-1.54,1.54-1.54h6.12c.85,0,1.54.69,1.54,1.54v7.42l-3.07,3.07v12.54h3.07v-11.27l3.07-3.07v-8.67c0-2.55-2.09-4.63-4.63-4.63h-3.04ZM278.02,90.62c-2.54,0-4.63,2.09-4.63,4.63s2.09,4.63,4.63,4.63c1.87,0,3.36-.99,4.53-1.85,1.16-.86,1.99-1.71,1.99-1.71l1.04-1.08-1.05-1.07s-.83-.85-2-1.71c-1.16-.86-2.65-1.85-4.51-1.85ZM277.86,99.83h-2.32l-.46.63c-2,2.74-3.12,6.69-3.86,10.03-.74,3.34-1.04,6.06-1.04,6.06l-.18,1.7h3.25v9.21h3.07v-9.21h3.07v9.21h3.07v-9.21h3.29l-.23-1.74s-.36-2.72-1.13-6.05c-.77-3.32-1.89-7.24-3.73-9.96l-.46-.68h-2.35ZM259.48,93.71c.87,0,1.54.67,1.54,1.54s-.67,1.54-1.54,1.54-1.54-.67-1.54-1.54.67-1.54,1.54-1.54ZM278.02,93.71c.53,0,1.75.55,2.69,1.24.21.15.18.16.36.31-.17.14-.14.15-.34.3-.94.69-2.15,1.24-2.7,1.24-.87,0-1.54-.68-1.54-1.54s.68-1.54,1.54-1.54ZM277.48,102.9h1.04c1.23,2.09,2.36,5.34,3.04,8.27.51,2.21.6,3.06.75,4.02h-8.62c.13-.95.2-1.82.69-4.04.65-2.93,1.79-6.18,3.1-8.25Z"
              fill="#000" stroke-width="0"/>
    </g>
</svg>
  ''';

  //已到站 站点信息图主体部分（不带入口编号）
  static const String arrivalStationInfoBodyWithoutEntrance = '''
  <?xml version="1.0" encoding="UTF-8"?>
<svg id="_图层_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1481 307.86">
    <g id="_图层_1-2">
        <rect x="2.5" y="2.5" width="1476" height="302.86" rx="25.71" ry="25.71" fill="none" stroke="#lineColor"
              stroke-miterlimit="10" stroke-width="5"/>
        <path d="M180.67,156.08c-1.81.07-3.94.31-6.27.88-4.68,1.15-8.24,3.16-10.57,4.76-6.07,3.76-13.4,9.25-20.38,17.14-16.01,18.1-20.7,38.09-22.29,48.05v15.3c0,2.93,2.37,5.3,5.3,5.3h54.21c2.93,0,5.3-2.37,5.3-5.3v-80.84c0-2.93-2.37-5.3-5.3-5.3Z"
              fill="#595757" stroke-width="0"/>
        <path d="M1284.03,156.08c1.81.07,3.94.31,6.27.88,4.68,1.15,8.24,3.16,10.57,4.76,6.07,3.76,13.4,9.25,20.38,17.14,16.01,18.1,20.7,38.09,22.29,48.05,0,5.1,0,10.2,0,15.3,0,2.93-2.37,5.3-5.3,5.3h-54.21c-2.93,0-5.3-2.37-5.3-5.3v-80.84c0-2.93,2.37-5.3,5.3-5.3Z"
              fill="#595757" stroke-width="0"/>
        <rect x="510.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29" fill="none" stroke="#lineColor"
              stroke-miterlimit="10" stroke-width="2"/>
        <path d="M533.22,90.86c-3.3-1.05-6.39,1.45-6.39,4.61,0,1.68.88,3.17,2.2,4.04-1.31.87-2.2,2.36-2.2,4.04v6.8l-2.47,2.47h-2.85c-2.65,0-5.12,1.53-6.16,3.97-2.13,4.98,1.54,9.83,6.28,9.83h7.55l19.83-19.83h1.81c3.06,0,5.86-2.02,6.53-5,.94-4.19-2.27-7.93-6.3-7.93h-7.14l-7.79,7.79c-.38-.87-1-1.61-1.79-2.13,1.71-1.14,2.68-3.32,1.94-5.61-.47-1.43-1.62-2.58-3.06-3.04ZM531.97,93.77c.92,0,1.62.71,1.62,1.62s-.7,1.62-1.62,1.62-1.62-.71-1.62-1.62.71-1.62,1.62-1.62ZM545.77,96.44h5.56c1.47,0,2.81.93,3.23,2.34.72,2.42-1,4.56-3.28,4.56h-3.61l-19.83,19.83h-5.56c-1.47,0-2.81-.93-3.23-2.34-.72-2.42,1-4.56,3.28-4.56h3.61l19.83-19.83ZM533.72,103.39v1s-3.45,3.45-3.45,3.45v-4.43c0-1.24,1.3-2.16,2.59-1.51.55.28.86.88.86,1.49Z"
              fill="#000" stroke-width="0"/>
        <rect x="909.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29" fill="none" stroke="#lineColor"
              stroke-miterlimit="10" stroke-width="2"/>
        <path d="M938.03,90.86c3.3-1.05,6.39,1.45,6.39,4.61,0,1.68-.88,3.17-2.2,4.04,1.31.87,2.2,2.36,2.2,4.04v6.8l2.47,2.47h2.85c2.65,0,5.12,1.53,6.16,3.97,2.13,4.98-1.54,9.83-6.28,9.83h-7.55l-19.83-19.83h-1.81c-3.06,0-5.86-2.02-6.53-5-.94-4.19,2.27-7.93,6.3-7.93h7.14l7.79,7.79c.38-.87,1-1.61,1.79-2.13-1.71-1.14-2.68-3.32-1.94-5.61.47-1.43,1.62-2.58,3.06-3.04ZM939.28,93.77c-.92,0-1.62.71-1.62,1.62s.7,1.62,1.62,1.62,1.62-.71,1.62-1.62-.71-1.62-1.62-1.62ZM925.48,96.44h-5.56c-1.47,0-2.81.93-3.23,2.34-.72,2.42,1,4.56,3.28,4.56h3.61l19.83,19.83h5.56c1.47,0,2.81-.93,3.23-2.34.72-2.42-1-4.56-3.28-4.56h-3.61l-19.83-19.83ZM937.52,103.39v1s3.45,3.45,3.45,3.45v-4.43c0-1.24-1.3-2.16-2.59-1.51-.55.28-.86.88-.86,1.49Z"
              fill="#000" stroke-width="0"/>
        <rect x="645.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29" fill="none" stroke="#lineColor"
              stroke-miterlimit="10" stroke-width="2"/>
        <path d="M665.33,85.53l-5.09,5.09h10.18l-5.09-5.09ZM673.81,85.62l5.09,5.09,5.09-5.09h-10.18ZM651.76,95.62v36h41v-36h-41ZM654.76,98.62h34v29h-34v-29ZM666.19,101.2c-2.93-.98-5.71,1.22-5.71,4,0,1.3.62,2.45,1.55,3.23-1.92.99-3.27,2.96-3.27,5.25v5.94h2v7h3v-10h-2v-2.42c0-1.29,1.04-2.58,2.33-2.66,1.48-.1,2.67,1.06,2.67,2.54v2.54h-2v10h4v-7h2v-5.94c0-2.29-1.35-4.25-3.27-5.25,1.18-.99,1.85-2.56,1.42-4.28-.35-1.37-1.39-2.51-2.73-2.96ZM681.19,101.2c-2.93-.98-5.71,1.22-5.71,4,0,1.3.62,2.45,1.55,3.23-1.92.99-3.27,2.96-3.27,5.25v5.94h2v7h3v-10h-2v-2.42c0-1.29,1.04-2.58,2.33-2.66,1.48-.1,2.67,1.06,2.67,2.54v2.54h-1v10h3v-7h2v-5.94c0-2.29-1.35-4.25-3.27-5.25,1.18-.99,1.85-2.56,1.42-4.28-.35-1.37-1.39-2.51-2.73-2.96ZM664.48,104.27c.49,0,.85.36.85.85s-.36.85-.85.85-.85-.36-.85-.85.36-.85.85-.85ZM679.74,104.27c.49,0,.85.36.85.85s-.36.85-.85.85-.85-.36-.85-.85.36-.85.85-.85Z"
              fill="#000" stroke-width="0"/>
        <rect x="447.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29" fill="none" stroke="#lineColor"
              stroke-miterlimit="10" stroke-width="2"/>
        <path d="M481.88,90.62v8.71h-8.71v8.71h-8.71v8.71h-8.71v11.88h3.17v-8.71h8.71v-8.71h8.71v-8.71h8.71v-8.71h8.71v-3.17h-11.88Z"
              fill="#000" stroke-width="0"/>
        <rect x="846.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29"
              transform="translate(1745.52 217.24) rotate(180)" fill="none" stroke="#lineColor" stroke-miterlimit="10"
              stroke-width="2"/>
        <path d="M864.63,90.62v8.71h8.71v8.71h8.71v8.71h8.71v11.88h-3.17v-8.71h-8.71v-8.71h-8.71v-8.71h-8.71v-8.71h-8.71v-3.17h11.88Z"
              fill="#000" stroke-width="0"/>
        <rect x="1053.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29"
              transform="translate(2159.52 217.24) rotate(-180)" fill="none" stroke="#lineColor" stroke-miterlimit="10"
              stroke-width="2"/>
        <path d="M1071.63,90.62v8.71h8.71v8.71h8.71v8.71h8.71v11.88h-3.17v-8.71h-8.71v-8.71h-8.71v-8.71h-8.71v-8.71h-8.71v-3.17h11.88Z"
              fill="#000" stroke-width="0"/>
        <rect x="242.76" y="82.62" width="52" height="52" rx="4.29" ry="4.29" fill="none" stroke="#lineColor"
              stroke-miterlimit="10" stroke-width="2"/>
        <path d="M259.48,90.62c-2.54,0-4.63,2.09-4.63,4.63s2.09,4.63,4.63,4.63,4.63-2.09,4.63-4.63-2.09-4.63-4.63-4.63ZM259.44,99.83h-3.04c-2.55,0-4.63,2.09-4.63,4.63v8.75l3.07,3.09v11.17h3.07v-12.54l-3.07-3.07v-7.42c0-.85.69-1.54,1.54-1.54h6.12c.85,0,1.54.69,1.54,1.54v7.42l-3.07,3.07v12.54h3.07v-11.27l3.07-3.07v-8.67c0-2.55-2.09-4.63-4.63-4.63h-3.04ZM278.02,90.62c-2.54,0-4.63,2.09-4.63,4.63s2.09,4.63,4.63,4.63c1.87,0,3.36-.99,4.53-1.85,1.16-.86,1.99-1.71,1.99-1.71l1.04-1.08-1.05-1.07s-.83-.85-2-1.71c-1.16-.86-2.65-1.85-4.51-1.85ZM277.86,99.83h-2.32l-.46.63c-2,2.74-3.12,6.69-3.86,10.03-.74,3.34-1.04,6.06-1.04,6.06l-.18,1.7h3.25v9.21h3.07v-9.21h3.07v9.21h3.07v-9.21h3.29l-.23-1.74s-.36-2.72-1.13-6.05c-.77-3.32-1.89-7.24-3.73-9.96l-.46-.68h-2.35ZM259.48,93.71c.87,0,1.54.67,1.54,1.54s-.67,1.54-1.54,1.54-1.54-.67-1.54-1.54.67-1.54,1.54-1.54ZM278.02,93.71c.53,0,1.75.55,2.69,1.24.21.15.18.16.36.31-.17.14-.14.15-.34.3-.94.69-2.15,1.24-2.7,1.24-.87,0-1.54-.68-1.54-1.54s.68-1.54,1.54-1.54ZM277.48,102.9h1.04c1.23,2.09,2.36,5.34,3.04,8.27.51,2.21.6,3.06.75,4.02h-8.62c.13-.95.2-1.82.69-4.04.65-2.93,1.79-6.18,3.1-8.25Z"
              fill="#000" stroke-width="0"/>
    </g>
</svg>
  ''';

  static const String arrivalStationInfoTransfer =
      '''<?xml version="1.0" encoding="UTF-8"?>
<svg id="_图层_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 504.5 307.86">
    <g id="_图层_1-2">
        <g id="transfer">
            <rect x="2.5" y="2.5" width="499.5" height="302.86" rx="25.71" ry="25.71" fill="none" stroke="#lineColor"
                  stroke-miterlimit="10" stroke-width="5"/>
            <text transform="translate(74.19 156.08)" fill="#000"
                  font-family="GennokiokuLCDFont">
                <tspan font-size="55.08">
                    <tspan x="0" y="0">换乘</tspan>
                </tspan>
                <tspan font-size="28.16">
                    <tspan x="-11.71" y="33.8" letter-spacing="-.07em">T</tspan>
                    <tspan x="1.69" y="33.8" letter-spacing="-.02em">r</tspan>
                    <tspan x="11.21" y="33.8">an</tspan>
                    <tspan x="42.56" y="33.8" letter-spacing="-.01em">s</tspan>
                    <tspan x="55.82" y="33.8" letter-spacing="-.02em">f</tspan>
                    <tspan x="64.27" y="33.8">er</tspan>
                    <tspan x="95.53" y="33.8" letter-spacing="-.01em">t</tspan>
                    <tspan x="105.79" y="33.8">o</tspan>
                </tspan>
            </text>
        </g>
    </g>
</svg>
''';

  static const String screenDoorCoverDirectionArrow =
      '''<svg xmlns="http://www.w3.org/2000/svg" width="631.25" height="578.125">
   <g>
      <path
         d="M475.625 323.635H-45.078L215.078 583.79h-81.64l-289.063-289.063L133.438 5.666h81.64L-45.078 265.822h520.703v57.813z"
         transform="translate(155.625 -5.666)" />
   </g>
</svg>
  ''';

  static const String operationDirectionBody = '''
  <?xml version="1.0" encoding="UTF-8"?>
<svg id="_图层_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1920 270">
    <g id="_图层_1-2">
        <path d="M825.97.01c-1.15-.02-2.35-.01-15.33,0h0S0,0,0,0v41.46h768.06c6.86.07,17.19.12,29.86.01.61,0,1.19,0,1.76-.01h10.96v-.07c4-.01,5.73,0,6.98.04.6.02.9.03,1.23.04,4.8.22,10.89.97,17.68,3.01,10.16,3.06,17.73,7.77,22.59,11.38,9.86-10.07,19.72-20.15,29.58-30.22C859.93,5,839.55.28,825.97.01Z"
              fill="#lineColor" stroke-width="0"/>
        <path d="M1151.94,228.54h0c-6.86-.07-17.19-.12-29.86-.01-.61,0-1.19,0-1.76.01h-10.96v.07c-4,.01-5.73,0-6.98-.04-.6-.02-.9-.03-1.23-.04-4.8-.22-10.89-.97-17.68-3.01-10.16-3.06-17.73-7.77-22.59-11.38-9.86,10.07-19.72,20.15-29.58,30.22,28.77,20.64,49.15,25.36,62.73,25.63,1.15.02,2.35.01,15.33,0h0s810.64,0,810.64,0v-41.46h-768.06Z"
              fill="#lineColor" stroke-width="0"/>
        <polygon
                points="64.82 109.6 94.76 79.66 75.22 79.6 38.67 116.14 75.02 152.43 94.76 152.56 64.82 122.68 122.09 122.68 122.09 109.6 64.82 109.6"
                fill="#fff" stroke-width="0"/>
        <polygon
                points="1861.73 154.35 1831.79 184.3 1851.33 184.36 1887.88 147.81 1851.53 111.53 1831.79 111.4 1861.73 141.28 1804.46 141.28 1804.46 154.35 1861.73 154.35"
                fill="#fff" stroke-width="0"/>
    </g>
</svg>
''';

  static const String operationDirectionBodyLoop = '''
  <?xml version="1.0" encoding="UTF-8"?>
<svg id="_图层_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1772.72 260">
    <g id="_图层_1-2">
        <polygon
                points="102.66 121.71 132.61 91.77 113.06 91.7 76.51 128.25 112.86 164.53 132.61 164.66 102.66 134.79 159.93 134.79 159.93 121.71 102.66 121.71"
                fill="#fff" stroke-width="0"/>
        <polygon
                points="1670.01 133.06 1640.07 163.01 1659.62 163.07 1696.17 126.52 1659.81 90.24 1640.07 90.11 1670.01 119.99 1612.74 119.99 1612.74 133.06 1670.01 133.06"
                fill="#fff" stroke-width="0"/>
        <path d="M1642.72,0c-.54,0-1.08.02-1.62.02v-.02H131.62v.02c-.54,0-1.08-.02-1.62-.02C58.2,0,0,58.2,0,130s58.2,130,130,130c.54,0,1.08-.02,1.62-.02v.02h1509.47v-.02c.54,0,1.08.02,1.62.02,71.8,0,130-58.2,130-130S1714.52,0,1642.72,0ZM1642.72,216.54h-97s-598.83,0-598.83,0c-17.14,12.01-38.01,19.07-60.53,19.07s-43.39-7.05-60.53-19.07H227s-97,0-97,0c-47.79,0-86.54-38.74-86.54-86.54s38.75-86.54,86.54-86.54h695.83c17.14-12.01,38.01-19.07,60.53-19.07s43.39,7.05,60.53,19.07h695.83c47.79,0,86.54,38.74,86.54,86.54s-38.75,86.54-86.54,86.54Z"
              fill="#lineColor" stroke-width="0"/>
    </g>
</svg>
''';

  //获取当前平台的路径分隔符
  static String pathSlash = Platform.isAndroid ? "/" : "\\";

  //最大缩放比例
  static double maxScale = 20;

  //浅色主题
  static ThemeData themeData() {
    return ThemeData(
      fontFamily: "GennokiokuLCDFont",
      colorScheme: lightColorScheme(),
    );
  }

  //深色主题
  static ThemeData darkThemeData() {
    return ThemeData(
      fontFamily: "GennokiokuLCDFont",
      colorScheme: darkColorScheme(),
    );
  }

  //浅色主题颜色
  static ColorScheme lightColorScheme() {
    return ColorScheme.fromSeed(
      seedColor: Colors.pink,
    );
  }

  //深色主题颜色
  static ColorScheme darkColorScheme() {
    return ColorScheme.fromSeed(
        seedColor: Colors.pink, brightness: Brightness.dark);
  }

  //获取背景颜色
  static Color backgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark &&
            Preference.generalIsWhiteBackgroundInDarkMode
        ? Colors.white
        : Theme.of(context).scaffoldBackgroundColor;
  }

  ///涉及到实际效果的设置项
  //LCD默认中粗体
  static FontWeight railwayTransitLcdIsBoldFont =
      HomeState.sharedPreferences?.getBool(
                PreferenceKey.railwayTransitLcdIsBoldFont,
              ) ??
              DefaultPreference.railwayTransitLcdIsBoldFont
          ? FontWeight.w600
          : FontWeight.normal;

  //LCD默认线路颜色与站点颜色相同
  static bool railwayTransitLcdIsRouteColorSameAsLineColor =
      HomeState.sharedPreferences?.getBool(
            PreferenceKey.railwayTransitLcdIsRouteColorSameAsLineColor,
          ) ??
          DefaultPreference.railwayTransitLcdIsRouteColorSameAsLineColor;

  //屏蔽门盖板默认中粗体
  static FontWeight railwayTransitScreenDoorCoverIsBoldFont =
      HomeState.sharedPreferences?.getBool(
                PreferenceKey.railwayTransitScreenDoorCoverIsBoldFont,
              ) ??
              DefaultPreference.railwayTransitScreenDoorCoverIsBoldFont
          ? FontWeight.w600
          : FontWeight.normal;

  //LCD默认最大站点数
  static int railwayTransitLcdMaxStation = HomeState.sharedPreferences?.getInt(
        PreferenceKey.railwayTransitLcdMaxStation,
      ) ??
      DefaultPreference.railwayTransitLcdMaxStation;

  //屏蔽门盖板默认最大站点数
  static int railwayTransitScreenDoorCoverMaxStation =
      HomeState.sharedPreferences?.getInt(
            PreferenceKey.railwayTransitScreenDoorCoverMaxStation,
          ) ??
          DefaultPreference.railwayTransitScreenDoorCoverMaxStation;

  static Color hexToColor(String hexColor) {
    return Color(int.parse('FF${hexColor.replaceAll('#', '')}', radix: 16));
  }

  static Color getTextColorForBackground(Color backgroundColor) {
    // 根据亮度值返回合适的文本颜色
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  // 获取文本宽度
  static double getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.width;
  }
}
