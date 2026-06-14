import 'dart:convert';
import 'lib/features/rider_trip/data/models/trip_details_model.dart';

void main() {
  String jsonStr = '''
{
  "17": {
      "401": {
        "id": 401,
        "status": "pending",
        "created_at": "2026-05-25 14:05:33"
      }
  }
}
  ''';
  var fullData = jsonDecode(jsonStr);
  var data = fullData["17"]; // This simulates data from rider_trips/17

  List<TripDetailsModel> ongoingTrips = [];
  try {
    if (data != null && data is Map) {
      ongoingTrips = data
          .map((key, value) =>
              MapEntry(key, TripDetailsModel.fromJson(value as Map)))
          .values
          .toList();
    }
    print("Success! ongoingTrips length: ${ongoingTrips.length}");
  } catch (e, s) {
    print("Error: $e\n$s");
  }
}
