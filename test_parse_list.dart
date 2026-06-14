import 'dart:convert';
import 'lib/features/rider_trip/data/models/trip_details_model.dart';

void main() {
  String jsonStr = '''
[
  null,
  null,
  {
    "id": 140,
    "luggages": false,
    "pickup_address": "387M+F6P Yaya’sPark, Al Manteqah Al Oula, , Egypt",
    "pickup_latitude": 30.0631954,
    "pickup_longitude": 31.3330675,
    "price": 100,
    "race_duration": "20",
    "ride_id": 140,
    "rider_id": 23,
    "rider_name": "test rider",
    "rider_rating": 0,
    "status": "pending",
    "trip_type": "Classic Ride",
    "trip_type_id": 1,
    "user_id": 23,
    "vehicle_category_id": 2
  }
]
  ''';
  var data = jsonDecode(jsonStr);
  List<TripDetailsModel> ongoingTrips = [];
  try {
    if (data != null && data is List) {
      ongoingTrips = data
          .where((tripData) => tripData != null)
          .map((tripData) => TripDetailsModel.fromJson(tripData as Map))
          .toList();
    }
    print("Success parsing List: ${ongoingTrips.length} items");
  } catch(e, s) {
    print("Error parsing List: $e\n$s");
  }
}
