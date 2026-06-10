import '../../../../core/imports/imports.dart';
import 'home_current_location.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    // final isRider = context.read<GlobalCubit>().isRider;
    return Column(
      children: [
        //! Header & Slider
        // const HomeHeader(),

        // SizedBox(height: 18.rH(context)),

        //! Trips Today (For Driver)
        // if (!isRider) const HomeTodayTrips(),

        //! Services (For Rider)
        // if (isRider) const HomeServices(),
        // SizedBox(height: 20.rH(context)),

        //! Current Location (For Rider)
        const HomeCurrentLocation(),

        //! Preferces (For Driver)
        // if (!isRider) const HomeDriverPreferences(),
        // SizedBox(height: 20.rH(context)),

        //! Recent Rides
        // const HomeRecentRides(),
        // SizedBox(height: 24.rH(context)),

        // if (!isRider) SizedBox(height: 120.rH(context)),
      ],
    );
  }
}
