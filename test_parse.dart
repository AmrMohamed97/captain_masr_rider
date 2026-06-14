import 'dart:convert';
import 'lib/features/rider_trip/data/models/trip_details_model.dart';
import 'lib/features/preferences/data/models/preferences_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  String jsonStr = '''
{
      "401": {
        "baby_carriage": false,
        "created_at": "2026-05-25 14:05:33",
        "distance_km": 95.19,
        "dropoff_address": "364C+HHP, Omar Al Khayam, , Egypt",
        "dropoff_latitude": 30.0565733,
        "dropoff_longitude": 31.221025,
        "female_driver": false,
        "id": 401,
        "large_count": 0,
        "luggages": false,
        "medium_count": 0,
        "notes": " ",
        "pickup_address": "386P+W4J, Al Manteqah Al Oula, , Egypt",
        "pickup_latitude": 30.547678,
        "pickup_longitude": 30.9027525,
        "preferences": {
          "cool_ride": false,
          "pets_free": false,
          "quiet_ride": false,
          "smoking_friendly": false
        },
        "price": 408.55,
        "ride_id": 401,
        "rider_id": 17,
        "rider_name": "amr",
        "rider_rating": 0,
        "seats_needed": 1,
        "small_count": 0,
        "status": "pending",
        "time_minutes": 117.97,
        "trip_type": "classic trip",
        "trip_type_id": 1,
        "updated_at": "2026-05-25 14:05:33",
        "user_id": 17,
        "vehicle_category_id": 2
      }
}
  ''';
  var data = jsonDecode(jsonStr);
  data.forEach((key, value) {
    try {
      var model = TripDetailsModel.fromJson(value);
      print("Success parsing 401!");
    } catch(e, s) {
      print("Error parsing 401: $e\n$s");
    }
  });
  
  String jsonStr2 = '''
{
      "140": {
        "created_at": "2026-06-09 10:05:45",
        "id": 140,
        "luggages": false,
        "pickup_address": "387M+F6P Yaya’sPark, Al Manteqah Al Oula, , Egypt",
        "pickup_latitude": 30.0631954,
        "pickup_longitude": 31.3330675,
        "price": 100,
        "race_duration": "20",
        "ride_id": 140,
        "rider_id": 23,
        "rider_image": "https://captian-masr.evyx.lol/uploads/users/1772620116_4426.jpg",
        "rider_name": "test rider",
        "rider_rating": 0,
        "status": "pending",
        "trip_type": "Classic Ride",
        "trip_type_id": 1,
        "updated_at": "2026-06-09 10:05:45",
        "user_id": 23,
        "vehicle_category_id": 2
      }
}
  ''';
  var data2 = jsonDecode(jsonStr2);
  data2.forEach((key, value) {
    try {
      var model = TripDetailsModel.fromJson(value);
      print("Success parsing 140!");
    } catch(e, s) {
      print("Error parsing 140: $e\n$s");
    }
  });

  String jsonStr3 = '''
{
      "215": {
        "baby_carriage": false,
        "created_at": "2026-06-11 13:18:23",
        "distance_km": 2.07,
        "driver_id": 29,
        "driver_name": "aiman",
        "driver_phone": "1066399925",
        "driver_phone_code": "20",
        "driver_rating": 3.5,
        "dropoff_address": "مكرم عبيد، Al Mintaqah as Sādisah, Nasr City, Egypt",
        "dropoff_latitude": 30.0620249,
        "dropoff_longitude": 31.3449786,
        "female_driver": false,
        "id": 215,
        "large_count": 0,
        "luggages": false,
        "main_payment_method_id": 8,
        "medium_count": 0,
        "notes": " ",
        "pickup_address": "عباس العقاد، Al Manteqah Al Oula, Nasr City, Egypt",
        "pickup_latitude": 30.0610147,
        "pickup_longitude": 31.3372655,
        "preferences": {
          "cool_ride": false,
          "pets_free": false,
          "quiet_ride": false,
          "smoking_friendly": false
        },
        "price": "30",
        "ride_id": 215,
        "rider_id": 28,
        "rider_name": "amr",
        "rider_phone": "1066399977",
        "rider_phone_code": "20",
        "rider_rating": 0,
        "seats_needed": 1,
        "small_count": 0,
        "status": "accepted",
        "time_minutes": 6.47,
        "trip_code": 4997,
        "trip_type": "Classic Ride",
        "trip_type_id": 1,
        "updated_at": "2026-06-11 13:18:23",
        "user_id": 28,
        "vehicle": {
          "brand": "Toyota",
          "category": "car",
          "color": "White",
          "license": "uploads/vehicles/1780177382_47372aac-b89c-447b-a1d6-57fa0e3bbc013998491950233368729.jpg",
          "model": "Toyota Model B",
          "plate": "123abc",
          "type": "Sedan"
        },
        "vehicle_category_id": 2
      }
}
  ''';
  var data3 = jsonDecode(jsonStr3);
  data3.forEach((key, value) {
    try {
      var model = TripDetailsModel.fromJson(value);
      print("Success parsing 215!");
    } catch(e, s) {
      print("Error parsing 215: $e\n$s");
    }
  });
}
