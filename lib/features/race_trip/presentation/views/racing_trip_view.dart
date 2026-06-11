import 'package:captain_masr_rider/features/race_trip/presentation/cubit/start_trip_cubit/racing_trip_state.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
// import '../../../driver_share_trip/presentation/views/driver_share_trip_view.dart';
// import '../../../driver_trip/presentation/views/driver_trip_view.dart';
import '../../../find_driver/presentation/views/find_driver_view.dart';
import '../cubit/start_trip_cubit/racing_trip_cubit.dart';
import '../widgets/racing_trip_body.dart';

class RacingTripView extends StatelessWidget {
  const RacingTripView({
    super.key,
    // this.isShareRide = false,
    // this.isDelivery = false,
    // this.isDailyRideNow = false,
    // this.driverOnMyWay = false,
    // this.deliveryDetailsModel,
  });

  // final bool isDelivery;
  // final DeliveryDetailsModel? deliveryDetailsModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RacingTripCubit()
        // ..isShareRide = isShareRide
        // ..isDailyRideNow = isDailyRideNow
        // ..driverOnMyWay = driverOnMyWay
        // ..isDelivery = isDelivery
        // ..deliveryDetailsModel = deliveryDetailsModel
        ..getVehicleCategories(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<RacingTripCubit, RacingTripState>(
          listener: (context, state) {
            // if (state is RacingDriverPostShareTripSuccessState) {
            //   showToast(
            //     context,
            //     message: state.message,
            //     state: ToastStates.success,
            //   );
            //   navigate(
            //     //ToDo
            //     context,
            //     DriverShareTripView(
            //       tripId: state.tripId,
            //       // isShareTrip: true,
            //       // isOnMyWay: true,
            //     ),
            //   );
            // }
            if (state is RacingRiderRequestTripSuccessState) {
              navigateReplacement(
                context,
                FindDriverView(
                  isShareRide: false,
                  isDelivery: true,
                  tripDetails: context.read<RacingTripCubit>().details!,
                ),
              );
              return;
            }
            if (state is RacingRiderRequestTripErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
            if (state is RacingCalculateEstimatedErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
            if (state is RacingTripErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
          },
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is RacingTripLoadingState,
              child: const RacingTripBody(),
            );
          },
        ),
      ),
    );
  }
}
