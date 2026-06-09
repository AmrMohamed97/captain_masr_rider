import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/sounds/sound_player.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../../../rider_trip/data/repo/rider_trip_repo.dart';
import '../../data/models/notified_driver_model.dart';

part 'find_driver_state.dart';

class FindDriverCubit extends Cubit<FindDriverState> {
  FindDriverCubit({
    required this.tripDetails,
    required this.isDelivery,
    required this.isShareRide,
    String? createdAt,
  }) : super(FindDriverInitial()) {
    initRealTime();
    if (createdAt != null) {
      final createdDateTime = DateTime.parse(createdAt);
      final currentDateTime = DateTime.now();
      final difference = currentDateTime.difference(createdDateTime);
      log("Difference: ${difference.inSeconds}");
      timerSeconds = difference.inSeconds;
      if (timerSeconds! < 0) {
        timerSeconds = 0;
      }
    } else {
      timerSeconds = 0;
    }
  }

  DatabaseReference? db;
  DatabaseReference? dbNotifiedDrivers;
  List<TripDetailsModel> requests = [];
  List<NotifiedDriverModel> notifiedDrivers = [];

  void initRealTime() {
    db = FirebaseDatabase.instance.ref(
      "ride_requests/${tripDetails?.rideId ?? 0}/drivers",
    );

    dbNotifiedDrivers = FirebaseDatabase.instance.ref(
      "trips/${tripDetails?.rideId ?? 0}/notified_drivers",
    );

    //! Request Added
    db!.onChildAdded.listen((event) {
      try {
        final data = event.snapshot.value as Map?;

        if (data != null) {
          final newRequest = TripDetailsModel.fromJson(data);
          final index = requests.indexWhere((element) => element.driverId == newRequest.driverId);
          if (index == -1) {
            requests.add(newRequest);
          } else {
            requests[index] = newRequest; // تحديث بيانات السائق إذا كان موجوداً مسبقاً
          }
          SoundPlayer.alertSound();
          emit(RecieveDriverRequestState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Add: $e");
      }
    });

    //! Request Changed
    db!.onChildChanged.listen((event) {
      try {
        final data = event.snapshot.value as Map?;

        if (data != null) {
          final updatedRequest = TripDetailsModel.fromJson(data);
          // تحديث بيانات السائق الموجود بدلاً من إضافته كعنصر جديد
          final index = requests.indexWhere((element) => element.driverId == updatedRequest.driverId);
          if (index != -1) {
            requests[index] = updatedRequest;
          } else {
            requests.add(updatedRequest); // إذا لم يكن موجوداً لسبب ما
          }
          SoundPlayer.alertSound();
          emit(RecieveDriverRequestState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Change: $e");
      }
    });

    //! Request Removed
    db!.onChildRemoved.listen((event) {
      try {
        final data = event.snapshot.value as Map?;
        if (!kReleaseMode) log("Removed: ${data.toString()}");

        if (data != null) {
           final removedRequest = TripDetailsModel.fromJson(data);
           // حذف السائق من القائمة عند إزالته من فايربيز
           requests.removeWhere((element) => element.driverId == removedRequest.driverId);
           emit(RecieveDriverRequestState()); // تحديث الواجهة بعد الحذف
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Remove: $e");
      }
    });

    //! Notified Drivers
    dbNotifiedDrivers!.onChildAdded.listen((event) {
      try {
        final data = event.snapshot.value as Map?;

        if (data != null) {
          notifiedDrivers.add(NotifiedDriverModel.fromJson(data));
          if (notifiedDrivers.length > 3) {
            notifiedDrivers.add(notifiedDrivers.removeAt(0));
          }
          emit(RecieveDriverRequestState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Add: $e");
      }
    });
  }

  //! Decline Driver
  Future<void> declineDriver({required int driverId}) async {
    db!.child(driverId.toString()).remove();
  }

  //! Accept Ride
  void acceptDriver({
    required int driverId,
    required int driverRequestId,
  }) async {
    emit(AcceptDriverLoadingState());
    final result = await sl<RiderTripRepo>().acceptDriver(
      tripId: tripDetails?.id ?? 0,
      driverId: driverId,
      driverRequestId: driverRequestId,
    );
    result.fold((error) => emit(AcceptDriverErrorState(error: error)), (
      message,
    ) {
      removeDriverAssigned(driverId: driverId);
      emit(AcceptDriverSuccessState(message: message, driverId: driverId));
    });
  }

  //! Negotiate Driver
  Future<void> negotiateDriver({
    required int driverRequestId,
    required double price,
    String? message,
  }) async {
    emit(NegotiationLoadingState());
    final result = await sl<RiderTripRepo>().negotiateDriver(
      driverRequestId: driverRequestId,
      price: price,
      message: message,
    );
    result.fold((error) => emit(NegotiationErrorState(error: error)), (
      successMessage,
    ) {
      // try {
      //   final request = requests.firstWhere(
      //     (e) => e.requestId == driverRequestId,
      //   );
      //   removeRequest(request.id);
      // } catch (_) {}
      emit(NegotiationSuccessState(message: successMessage));
    });
  }

  //! Cancel Trip
  Future<void> cancelTrip() async {
    emit(FindDriverCancelTripLoadingState());
    final result = await sl<RiderTripRepo>().cancelTrip(
      tripId: tripDetails?.rideId ?? 0,
    );
    result.fold(
      (error) => emit(FindDriverCancelTripErrorState(error: error)),
      (message) => emit(FindDriverCancelTripSuccessState(message: message)),
    );
  }

  //! Remove Driver Assigned
  void removeDriverAssigned({required int driverId}) {
    sl<RiderTripRepo>().removeAssignedForDriver(
      rideId: tripDetails?.rideId ?? 0,
      driverId: driverId,
    );
  }

  //! Ride Type
  TripDetailsModel? tripDetails;
  bool isShareRide = false;
  bool isDelivery = false;
  bool isActive = true;

  // recieveRequest() {
  //   if (!isActive) return;
  //   Future.delayed(const Duration(seconds: 3), () {
  //     if (requests.length < 2) {
  //       requests.add("value");
  //     }
  //     if (!isActive) return;
  //     emit(RecieveRequestState());
  //     recieveRequest();
  //   });
  // }

  void removeRequest(int? tripId) {
    if (isActive) {
      requests.removeWhere((e) => e.id == tripId);
      if (!isActive) return;
      emit(FindDriverInitial());
    }
  }

  //! Dragable Container
  bool isBottomContainerExpanded = false;

  void bottomContainerExpandedToggle(bool value) {
    if (!isActive) return;
    isBottomContainerExpanded = value;
    if (!isActive) return;
    emit(BottomContainerExpandedToggleState());
  }

  //! Timer
  int? timerSeconds;

  @override
  Future<void> close() {
    isActive = false;
    return super.close();
  }
}
