import 'package:captain_masr_rider/features/race_trip/presentation/cubit/start_trip_cubit/racing_trip_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../cubit/start_trip_cubit/racing_trip_cubit.dart';
import 'racing_trip_bottom_section.dart';

class RacingTripBody extends StatelessWidget {
  const RacingTripBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RacingTripCubit, RacingTripState>(
      builder: (context, state) {
        final cubit = context.read<RacingTripCubit>();
        final globalCubit = context.read<GlobalCubit>();
        return CustomModalProgressIndicator(
          inAsyncCall: state is RacingGetCurrentLocationLoadingState,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                //! Map
                if (globalCubit.userLocation != null)
                  Positioned.fill(
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        cubit.mapController = controller;
                      },
                      style: context.read<GlobalCubit>().isDarkMode
                          ? context.read<GlobalCubit>().mapDarkStyle
                          : null,
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          globalCubit.userLocation!.latitude,
                          globalCubit.userLocation!.longitude,
                        ),
                        zoom: 14,
                      ),
                      markers: cubit.markers ?? {},
                      // polylines: cubit.polylines,
                    ),
                  ),

                //! Header
                Positioned(
                  top: 0,
                  left: 16.rW(context),
                  right: 16.rW(context),
                  child: const CustomAppBar(),
                ),

                //! Bottom Section
                const RacingTripBottomSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}
