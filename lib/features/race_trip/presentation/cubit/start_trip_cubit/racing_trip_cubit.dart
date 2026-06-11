import 'dart:ui' as ui;

import 'package:captain_masr_rider/features/race_trip/data/repo/race_trip_repo.dart';
import 'package:captain_masr_rider/features/race_trip/presentation/cubit/start_trip_cubit/racing_trip_state.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/imports/imports.dart';
import '../../../../my_vehicle/data/models/vehicle_category_model.dart';
import '../../../../my_vehicle/data/repo/vehicle_repo.dart';
import '../../../../pick_location/data/models/selected_location_model.dart';
import '../../../../promo_code/data/models/promo_code_model.dart';
import '../../../../rider_trip/data/models/trip_details_model.dart';

class RacingTripCubit extends Cubit<RacingTripState> {
  RacingTripCubit() : super(RacingTripInitial());

  Duration? raceDuration;
  //! Request Classic Trip
  Future<void> requestClassicTrip() async {
    emit(RacingTripLoadingState());
    final result = await sl<RaceTripRepo>().requestRaceTrip(
      vehicleCategoryId: selectedVehicleCategoryId!,
      pickupAddress: startLocation?.address ?? "",
      pickupLatitude: startLocation?.lat ?? 0,
      pickupLongitude: startLocation?.lon ?? 0,
      raceDuration: raceDuration!.inMinutes,
      tripTypeId: 5,
      requestType: "race",
      // femaleDriver: isFemale,
      promoCode: promoCodeModel?.name,
      mainPaymentMethodId: mainPaymentMethodId ?? 0,
      subPaymentMethodId: subPaymentMethodId,
    );
    result.fold(
      (error) => emit(RacingRiderRequestTripErrorState(error: error)),
      (model) {
        details = model;
        emit(RacingRiderRequestTripSuccessState());
      },
    );
  }

  //! Calculate Estimated
  Future<void> calculateEstimated() async {
    print('===============calculateEstimated onMyWay data=================');
    print(startLocation?.lat);
    print(startLocation?.lon);
    // print(endLocation?.lat);
    // print(endLocation?.lon);
    // print(selectedSeatsIds.length);
    print('[${DateTime.now().toString()}]');
    print('===============calculateEstimated data end=====================');
    emit(RacingTripLoadingState());
    final result = await sl<RaceTripRepo>().calculateEstimated(
      tripTypeId: 5,
      vehilceCategoryId:
          selectedVehicleCategoryId ??
          // deliveryDetailsModel?.vehicleCategoryId ??
          4,
      pickupAddress: startLocation?.address ?? "",
      pickupLatitude: startLocation?.lat ?? 0,
      pickupLongitude: startLocation?.lon ?? 0,
      raceDuration: raceDuration!.inMinutes,
      requestType: "race",
    );
    result.fold(
      (error) => emit(RacingCalculateEstimatedErrorState(error: error)),
      (model) {
        details = model;
        emit(RacingCalculateEstimatedSuccessState());
      },
    );
  }

  //! Get Vehicles Categories
  List<VehicleCategoryModel> vehicleCategories = [];
  Future<void> getVehicleCategories() async {
    final result = await sl<VehicleRepo>().tripVehicleCategories(tripId: 5);
    result.fold((error) => emit(RacingTripErrorState(error: error)), (list) {
      vehicleCategories = list;
      if (vehicleCategories.isNotEmpty) {
        selectedVehicleCategoryId = vehicleCategories.first.id;
      }
      emit(RacingTripSuccessState());
      // if (isShareRide) {
      //   getSeats();
      // }
    });
  }

  // //! Seats
  // List<SeatModel> seats = [];
  // List<int> selectedSeatsIds = [];
  // Future<void> getSeats() async {
  //   final result = await sl<VehicleRepo>().getSeats();
  //   result.fold((error) => emit(RacingTripErrorState(error: error)), (list) {
  //     seats = list;
  //     emit(RacingTripSuccessState());
  //   });
  // }

  // void selectSeat(int index) {
  //   if (selectedSeatsIds.contains(seats[index].id)) {
  //     selectedSeatsIds.remove(seats[index].id);
  //   } else {
  //     selectedSeatsIds.add(seats[index].id!);
  //   }
  //   emit(RacingTripSuccessState());
  // }

  // bool isShareRide = false;
  // bool isDailyRideNow = false;
  // bool driverOnMyWay = false;
  // bool isDelivery = false;
  // DeliveryDetailsModel? deliveryDetailsModel;

  GoogleMapController? mapController;
  Set<Marker>? markers;

  SelectedLocationModel? startLocation;
  // SelectedLocationModel? endLocation;
  // List<SelectedLocationModel> stops = [];

  // bool isFemale = false;
  // bool hasBabyCarriage = false;
  // bool hasLuggages = false;

  int? mainPaymentMethodId, subPaymentMethodId;

  //! Promo Codes
  TextEditingController promoCodeController = TextEditingController();
  PromoCodeModel? promoCodeModel;
  double? discountPrice;

  void applyPromoCode(PromoCodeModel? model) {
    promoCodeModel = model;

    if (promoCodeModel != null) {
      // if (isShareRide) {
      //   final price = details?.totalPrice ?? 0;
      //   final dicountValue = ((promoCodeModel?.percentage ?? 0) / 100) * price;
      //   // استخدام math.max لمنع القيم السالبة تماشياً مع الـ Backend
      //   final finalPrice = price - dicountValue;
      //   discountPrice = double.tryParse(
      //     (finalPrice < 0 ? 0.0 : finalPrice).toStringAsFixed(2),
      //   );
      // } else {
        final price = details?.price ?? 0;
        final dicountValue = ((promoCodeModel?.percentage ?? 0) / 100) * price;
        // استخدام math.max لمنع القيم السالبة تماشياً مع الـ Backend
        final finalPrice = price - dicountValue;
        discountPrice = double.tryParse(
          (finalPrice < 0 ? 0.0 : finalPrice).toStringAsFixed(2),
        );
      // }
    } else {
      discountPrice = null;
    }

    emit(RacingTripToggleState());
  }

  TripDetailsModel? details;

  // void isFemaleToggle(bool value) {
  //   isFemale = value;
  //   emit(RacingTripIsFemaleToggleState());
  // }

  // void hasBabyCarriageToggle(bool value) {
  //   hasBabyCarriage = value;
  //   emit(RacingTripIsFemaleToggleState());
  // }

  // void hasLuggagesToggle(bool value) {
  //   hasLuggages = value;
  //   emit(RacingTripIsFemaleToggleState());
  // }

  Future<void> selectLocations(dynamic value) async {
    if (value != null) {
      startLocation = value[0];
      // endLocation = value[1];
      // stops = value[2];
      if (startLocation?.lat != null && startLocation!.lon != null) {
        setStartMarker(
          LatLng(startLocation!.lat ?? 0, startLocation?.lon ?? 0),
        );
        // mapController!.animateCamera(
        //   CameraUpdate.newLatLng(
        //     LatLng(
        //       startLocation!.lat!,
        //       startLocation!.lon!,
        //     ),
        //   ),
        //   duration: const Duration(seconds: 1),
        // );
      }
      // if (endLocation?.lat != null && endLocation!.lon != null) {
      //   setDestinationarker(
      //     LatLng(endLocation!.lat ?? 0, endLocation!.lon ?? 0),
      //   );
      // }
      // await getRoute();
      fitToTwoPoints();
      emit(RacingTripSelectLocationsState());
    }
  }

  void setStartMarker(LatLng position) async {
    final BitmapDescriptor pinIcon = await getScaledMarkerIcon(
      Assets.imagesPinLocationPng,
      80,
    );

    final marker = Marker(
      markerId: const MarkerId('Start'),
      position: position,
      icon: pinIcon,
    );

    markers = markers?.union({marker}) ?? {marker};

    emit(RacingTripSelectLocationsState());
  }

  void setDestinationarker(LatLng position) async {
    final BitmapDescriptor pinIcon = await getScaledMarkerIcon(
      Assets.imagesRiderMapPin,
      100,
    );

    final marker = Marker(
      markerId: const MarkerId('end'),
      position: position,
      icon: pinIcon,
    );

    markers = markers?.union({marker}) ?? {marker};
    emit(RacingTripSelectLocationsState());
  }

  Future<BitmapDescriptor> getScaledMarkerIcon(String path, int width) async {
    final ByteData byteData = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width,
    );
    final frame = await codec.getNextFrame();
    final byteDataResized = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return BitmapDescriptor.fromBytes(byteDataResized!.buffer.asUint8List());
  }

  //! Polyline
  // Set<Polyline> polylines = {};

  // Future<void> getRoute() async {
  //   if (startLocation?.lat == null ||
  //       // endLocation?.lat == null ||
  //       startLocation?.lon == null ||
  //       // endLocation?.lon == null
  //       ) {
  //     return;
  //   }
  //   const String apiKey = "AIzaSyCuOWpUhowE4hXXmyFi0P_2wlCBQu6cFt4";

  //   // Build URL with waypoints if stops exist
  //   String url =
  //       "https://maps.googleapis.com/maps/api/directions/json?origin=${startLocation!.lat},${startLocation!.lon}&destination=${endLocation!.lat},${endLocation!.lon}";

  //   // Add waypoints if there are stops
  //   // if (stops.isNotEmpty) {
  //   //   final waypoints = stops
  //   //       .map((stop) => "${stop.lat},${stop.lon}")
  //   //       .join("|");
  //   //   url += "&waypoints=$waypoints";

  //   //   if (!kReleaseMode) {
  //   //     log("Route with ${stops.length} stops: $waypoints");
  //   //   }
  //   // }

  //   url += "&key=$apiKey";

  //   try {
  //     final response = await sl<DioConsumer>().get(url);
  //     if (response.statusCode == 200) {
  //       final List<LatLng> polylineCoordinates = _decodePolyline(
  //         response.data['routes']?[0]['overview_polyline']['points'],
  //       );
  //       polylines = {};
  //       polylines.add(
  //         Polyline(
  //           polylineId: const PolylineId("route"),
  //           color: AppColors.primary,
  //           width: 5,
  //           points: polylineCoordinates,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     log("Error fetching route: $e");
  //   }
  // }

  // List<LatLng> _decodePolyline(String encoded) {
  //   final List<LatLng> polylineCoordinates = [];
  //   int index = 0, len = encoded.length;
  //   int lat = 0, lng = 0;

  //   while (index < len) {
  //     int shift = 0, result = 0;
  //     int byte;
  //     do {
  //       byte = encoded.codeUnitAt(index++) - 63;
  //       result |= (byte & 0x1F) << shift;
  //       shift += 5;
  //     } while (byte >= 0x20);
  //     final int deltaLat = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
  //     lat += deltaLat;

  //     shift = 0;
  //     result = 0;
  //     do {
  //       byte = encoded.codeUnitAt(index++) - 63;
  //       result |= (byte & 0x1F) << shift;
  //       shift += 5;
  //     } while (byte >= 0x20);
  //     final int deltaLng = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
  //     lng += deltaLng;

  //     polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
  //   }
  //   return polylineCoordinates;
  // }

  void fitToTwoPoints() {
    if (mapController == null) return;

    if (startLocation?.lat == null ||
        // endLocation?.lat == null ||
        startLocation?.lon == null 
        // ||
        // endLocation?.lon == null
        ) {
      return;
    }

    // Determine the southwest and northeast corners correctly
    final double southWestLat =   startLocation!.lat ??0.0;
    final double southWestLng = startLocation!.lon ??0.0;
    final double northEastLat = startLocation!.lat ?? 0.0;
    final double northEastLng = startLocation!.lon ?? 0.0;

    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50), // padding
    );
  }

  //! Seats Number
  // int seatsNum = 1;

  // void changeSeatsNum({required bool increase}) {
  //   if (increase && seatsNum < 4) {
  //     seatsNum++;
  //   } else if (!increase && seatsNum > 1) {
  //     seatsNum--;
  //   }
  //   emit(RacingTripChangeSeatsNumberState());
  // }

  // //! Luggages Numbers
  // int smallLuggaes = 0;
  // int mediumLuggaes = 0;
  // int largeLuggaes = 0;

  // void changeLuggagesNumber({required int index, required bool increase}) {
  //   switch (index) {
  //     case 0:
  //       smallLuggaes = increase ? smallLuggaes + 1 : smallLuggaes - 1;

  //       break;
  //     case 1:
  //       mediumLuggaes = increase ? mediumLuggaes + 1 : mediumLuggaes - 1;
  //       break;
  //     case 2:
  //       largeLuggaes = increase ? largeLuggaes + 1 : largeLuggaes - 1;
  //       break;
  //     default:
  //   }
  //   emit(RacingTripToggleState());
  // }

  //! Selected Vehicle Category
  int? selectedVehicleCategoryId;

  void chooseVhecileCategory(int index) {
    if (details == null) {
      selectedVehicleCategoryId = vehicleCategories[index].id;
    }
    emit(RacingTripSuccessState());
  }

  void chooseRaceDuration(int minutes) {
    raceDuration = Duration(minutes: minutes);
    emit(RacingTripToggleState());
  }
}
