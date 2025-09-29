import 'package:absensi_app/core/api/attendance_api.dart';
import 'package:absensi_app/core/api/attendance_point_api.dart';
import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/core/api/event_api.dart';
import 'package:absensi_app/core/api/leave_api.dart';
import 'package:absensi_app/core/api/schedule_api.dart';
import 'package:absensi_app/core/services/dio_service.dart';
import 'package:absensi_app/core/services/pref_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> independentServices = <SingleChildWidget>[
  Provider<DioService>(create: (_) => DioService(PrefService())),
];

List<SingleChildWidget> apiServices = <SingleChildWidget>[
  ProxyProvider<DioService, AuthApi>(
    update: (_, dioService, __) => AuthApi(dioService.dio),
  ),
  ProxyProvider<DioService, AttendancePointApi>(
    update: (_, dioService, __) => AttendancePointApi(dioService.dio),
  ),
  ProxyProvider<DioService, AttendanceApi>(
    update: (_, dioService, __) => AttendanceApi(dioService.dio),
  ),
  ProxyProvider<DioService, LeaveApi>(
    update: (_, dioService, __) => LeaveApi(dioService.dio),
  ),
  ProxyProvider<DioService, ScheduleApi>(
    update: (_, dioService, __) => ScheduleApi(dioService.dio),
  ),
  ProxyProvider<DioService, EventApi>(
    update: (_, dioService, __) => EventApi(dioService.dio),
  ),
];

List<SingleChildWidget> appProviders = [...independentServices, ...apiServices];
