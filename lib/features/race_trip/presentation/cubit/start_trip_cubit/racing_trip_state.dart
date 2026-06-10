// part of 'racing_trip_cubit.dart';

import 'package:captain_masr_rider/features/rider_trip/data/models/available_share_trips_model.dart';

sealed class RacingTripState {}

final class RacingTripInitial extends RacingTripState {}

final class RacingGetCurrentLocationLoadingState extends RacingTripState {}

final class RacingGetCurrentLocationSuccessState extends RacingTripState {}

final class RacingTripIsFemaleToggleState extends RacingTripState {}

final class RacingGetStartTripTripDetailsState extends RacingTripState {}

final class RacingTripCheckPromoCodeState extends RacingTripState {}

final class RacingTripSelectLocationsState extends RacingTripState {}

final class RacingTripBottomContainerExpandedToggleState
    extends RacingTripState {}

final class RacingTripChangeSeatsNumberState extends RacingTripState {}

final class RacingCalculateEstimatedErrorState extends RacingTripState {
  final String error;

  RacingCalculateEstimatedErrorState({required this.error});
}

final class RacingCalculateEstimatedSuccessState extends RacingTripState {}

final class RacingRiderRequestTripErrorState extends RacingTripState {
  final String error;

  RacingRiderRequestTripErrorState({required this.error});
}

final class RacingRiderRequestTripSuccessState extends RacingTripState {}

final class RacingTripToggleState extends RacingTripState {}

final class RacingTripLoadingState extends RacingTripState {}

final class RacingTripErrorState extends RacingTripState {
  final String error;

  RacingTripErrorState({required this.error});
}

final class RacingTripSuccessState extends RacingTripState {}

final class RacingDriverPostShareTripSuccessState extends RacingTripState {
  final String message;
  final int tripId;

  RacingDriverPostShareTripSuccessState({
    required this.message,
    required this.tripId,
  });
}

final class RacingRiderSearchShareTripsSuccessState extends RacingTripState {
  final AvailableShareTripsModel model;

  RacingRiderSearchShareTripsSuccessState({required this.model});
}
