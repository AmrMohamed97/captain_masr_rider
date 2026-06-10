import 'dart:developer';
import 'package:captain_masr_rider/features/rider_trip/data/models/trip_details_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/imports/imports.dart';

class RaceTripRepo {
  final DioConsumer api;

  RaceTripRepo(this.api);

  //! Request Classic Trip
  Future<Either<String, TripDetailsModel>> requestRaceTrip({
    required int vehicleCategoryId,
    required String pickupAddress,
    required String requestType,
    required int raceDuration,
    required double pickupLatitude,
    required double pickupLongitude,
    // required String dropoffAddress,
    // required double dropoffLatitude,
    // required double dropoffLongitude,
    // required List<LatLng> stops,
    // required bool? femaleDriver,
    // required bool? babyCarriage,
    // required bool? luggages,
    // required int? smallLuggaes,
    // required int? mediumLuggaes,
    // required int? largeLuggaes,
    required String? promoCode,
    required int mainPaymentMethodId,tripTypeId,
    required int? subPaymentMethodId,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.userRequestClassic,
        isFormData: true,
        data: {
          // "dropoff_address": dropoffAddress,
          // "dropoff_latitude": dropoffLatitude,
          "vehicle_category_id": vehicleCategoryId,
          "pickup_address": pickupAddress,
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "race_duration": raceDuration,
          "trip_type_id": tripTypeId,
          "request_type":requestType,
          // "dropoff_longitude": dropoffLongitude,
          // "stops": stops
          //     .map((e) => {"latitude": e.latitude, "longitude": e.longitude})
          //     .toList(),
          // "female_driver": femaleDriver ?? false,
          // "baby_carriage": babyCarriage ?? false,
          // "luggages": luggages ?? false,
          // "small_count": smallLuggaes ?? 0,
          // "medium_count": mediumLuggaes ?? 0,
          // "large_count": largeLuggaes ?? 0,
          "promo_code": promoCode,
          "main_payment_method_id": mainPaymentMethodId,
          "sub_payment_method_id": subPaymentMethodId,
        },
      );
      return Right(TripDetailsModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  // //! Request Delivery Trip
  // Future<Either<String, TripDetailsModel>> requestDeliveryTrip({
  //   required int vehicleCategoryId,
  //   required String pickupAddress,
  //   required double pickupLatitude,
  //   required double pickupLongitude,
  //   required String dropoffAddress,
  //   required double dropoffLatitude,
  //   required double dropoffLongitude,
  //   required List<LatLng> stops,
  //   required DeliveryDetailsModel deliveryDetails,
  //   required String? promoCode,
  //   required int mainPaymentMethodId,
  //   required int? subPaymentMethodId,
  // }) async {
  //   try {
  //     final Response response = await api.post(
  //       EndPoints.userRequestClassic,
  //       isFormData: true,
  //       data: {
  //         "trip_type_id": 4,
  //         "vehicle_category_id": vehicleCategoryId,
  //         "pickup_address": pickupAddress,
  //         "pickup_latitude": pickupLatitude,
  //         "pickup_longitude": pickupLongitude,
  //         "dropoff_address": dropoffAddress,
  //         "dropoff_latitude": dropoffLatitude,
  //         "dropoff_longitude": dropoffLongitude,
  //         "stops": stops
  //             .map((e) => {"latitude": e.latitude, "longitude": e.longitude})
  //             .toList(),
  //         "deliver_type": deliveryDetails.deliveryType,
  //         "deliver_item_id": deliveryDetails.deliveryItemId,
  //         "deliver_item_size_id": deliveryDetails.deliveryItemSizeId,
  //         "payment_of_deliver_type": deliveryDetails.paymentType,
  //         "notes": deliveryDetails.note ?? "",
  //         "delivery_image": await uploadImageToApi(deliveryDetails.image),
  //         "promo_code": promoCode,
  //         "main_payment_method_id": mainPaymentMethodId,
  //         "sub_payment_method_id": subPaymentMethodId,
  //       },
  //     );
  //     return Right(TripDetailsModel.fromJson(response.data["data"]));
  //   } on ServerException catch (e) {
  //     return Left(e.errorModel.detail);
  //   } catch (e) {
  //     return Left(AppStrings.anErrorOccured());
  //   }
  // }

  //! Calculate Estimated
  Future<Either<String, TripDetailsModel>> calculateEstimated({
    required int tripTypeId,
    required int vehilceCategoryId,
    required String requestType,
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required int raceDuration,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.userTripEstimate,
        data: {
  "pickup_address": pickupAddress,
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
  "vehicle_category_id": vehilceCategoryId,
   "race_duration": raceDuration,
          "trip_type_id": tripTypeId,
          "request_type":requestType,

},
        // {
        //   "trip_type_id": tripTypeId,
        //   "vehicle_category_id": vehilceCategoryId,
        //   "pickup_address": pickupAddress,
        //   "pickup_latitude": pickupLatitude,
        //   "pickup_longitude": pickupLongitude,
        //   "dropoff_address": dropoffAddress,
        //   "dropoff_latitude": dropoffLatitude,
        //   "dropoff_longitude": dropoffLongitude,
        //   "seats_needed":seatsNeeded,
        //   "stops": stops
        //       .map((e) => {"latitude": e.latitude, "longitude": e.longitude})
        //       .toList(),
        // },
      );
      print(response.data["data"]);
      print(response.data["data"]["total_price"]);
      print(response.data["data"]["price"]);
      print(TripDetailsModel.fromJson(response.data["data"]).toMap());
      return Right(TripDetailsModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Accept Driver
  Future<Either<String, String>> acceptDriver(
      {required int tripId, required int driverId,required int driverRequestId}) async {
    try {
      //status of trip changed from pending to accepted in assign_trip
      final Response response = await api.post(
        "${EndPoints.userAcceptDriver}/$tripId/$driverId/$driverRequestId",
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Negotiate Driver
  Future<Either<String, String>> negotiateDriver({
    required int driverRequestId,
    required double price,
    String? message,
  }) async {
    try {
      final Response response = await api.post(
        "${EndPoints.userNegotiation}/$driverRequestId",
        data: {
          "action": "counter_offer",
          "price": price,
          "message": message,
        },
      );
      return Right(response.data["message"] ?? "Success");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Cancel Trip
  Future<Either<String, String>> cancelTrip({
    required int tripId,
    List<String>? cancelReasons,
    String? notes,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.cancelTrip.replaceAll("tripId", tripId.toString()),
        data: {
          "cancel_reasons": cancelReasons,
          "notes": notes,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Remove Assigned For Driver
  Future<void> removeAssignedForDriver({
    required int rideId,
    required int driverId,
  }) async {
    try {
      await api.post(
        "${EndPoints.removeAssignedForDriver}/$rideId/$driverId",
      );
    } catch (e) {
      log("Error removing assigned for driver: ${e.toString()}");
    }
  }
}
