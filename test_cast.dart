class TripDetailsModel {}

void main() {
  Map<dynamic, dynamic> data = {"1": "a", "2": "b"};
  List<TripDetailsModel> ongoingTrips = [];
  try {
    ongoingTrips = data.map((key, value) => MapEntry(key, TripDetailsModel())).values.toList();
    print("Success!");
  } catch (e, s) {
    print("Error: $e\n$s");
  }
}
