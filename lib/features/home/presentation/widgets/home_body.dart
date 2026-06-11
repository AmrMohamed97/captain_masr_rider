import 'package:captain_masr_rider/features/home/presentation/widgets/home_header.dart';
import 'package:captain_masr_rider/features/home/presentation/widgets/home_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../../../saved_places/data/models/saved_place_model.dart';
import '../../../saved_places/presentation/views/saved_places_view.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        final globalCubit = context.read<GlobalCubit>();
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              style: context.read<GlobalCubit>().isDarkMode
                  ? context.read<GlobalCubit>().mapDarkStyle
                  : null,
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  globalCubit.userLocation?.latitude ?? 26.820553,
                  globalCubit.userLocation?.longitude ?? 30.802498,
                ),
                zoom: 6.151926040649414,
              ),
            ),

            //! Title & Location
            //! Choose Saved Place
            Column(
              children: [
                const HomeHeader(),
                SizedBox(height: 12.rH(context)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.rW(context)),
                  child: Container(
                    height: 40.rH(context),
                    decoration: BoxDecoration(
                      // color: AppColors.grey.withOpacity(.15),
                      color: Theme.of(context).cardColor.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.grey.withOpacity(.15),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: AppColors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          navBarNavigate(
                            context: context,
                            widget: const SavedPlacesView(canChoose: true),
                            then: (value) {
                              if (value != null && value is SavedPlaceModel) {
                                globalCubit.setRiderLoction(value).then((
                                  value,
                                ) {
                                  if (globalCubit.userLocation != null) {
                                    mapController?.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: globalCubit.userLocation!,
                                          zoom: 14.151926040649414,
                                        ),
                                      ),
                                    );
                                  }
                                });
                              }
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 11.rW(context),
                            vertical: 0.rH(context),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4.rH(context)),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.star_rounded,
                                  color: AppColors.primary,
                                  size: 15.rH(context),
                                ),
                              ),
                              SizedBox(width: 12.rW(context)),
                              Text(
                                AppStrings.chooseSavedPlace.tr(context),
                                style: Styles.medium14(context).copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color?.withOpacity(.7),
                                size: 14.rH(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (globalCubit.userLocation != null)
              //! Pin
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 63.rH(context),
                    height: 63.rH(context),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.15),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 5.rH(context),
                            backgroundColor: AppColors.white,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: (63.rH(context) / 2) - (27.rH(context) / 2),
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CustomSvgPicture(
                              svg: Assets.imagesPinLocation,
                              height: 27.rH(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            //----------------------------------------------------------------
            ///services
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(.08),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(bottom: 35.rH(context)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 12.rH(context),
                          bottom: 12.rH(context),
                        ),
                        width: 48.rW(context),
                        height: 5.rH(context),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const HomeServices(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


//  Column(
//       children: [
//         //! Header & Slider
//         // const HomeHeader(),

//         // SizedBox(height: 18.rH(context)),

//         //! Trips Today (For Driver)
//         // if (!isRider) const HomeTodayTrips(),

//         //! Services (For Rider)
//         // if (isRider) const HomeServices(),
//         // SizedBox(height: 20.rH(context)),

//         //! Current Location (For Rider)

//         //! Preferces (For Driver)
//         // if (!isRider) const HomeDriverPreferences(),
//         // SizedBox(height: 20.rH(context)),

//         //! Recent Rides
//         // const HomeRecentRides(),
//         // SizedBox(height: 24.rH(context)),

//         // if (!isRider) SizedBox(height: 120.rH(context)),
//       ],
//     );