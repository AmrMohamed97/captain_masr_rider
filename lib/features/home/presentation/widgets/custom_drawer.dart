import 'package:cached_network_image/cached_network_image.dart';
import 'package:captain_masr_rider/features/learning/presentation/helper_page.dart';
import 'package:captain_masr_rider/features/learning/presentation/learning_page.dart';
import 'package:captain_masr_rider/features/preferences/presentation/views/preferences_view.dart';
import 'package:captain_masr_rider/features/promo_code/presentation/views/promo_code_view.dart';
import 'package:captain_masr_rider/features/saved_places/presentation/views/saved_places_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/partial_star.dart';
import '../../../become_rider_or_driver/presentation/views/become_rider_or_driver_view.dart';
import '../../../edit_profile/presentation/views/edit_profile_view.dart';
import '../../../find_riders/presentation/views/find_riders_view.dart';
import '../../../profile/presentation/widgets/logout_alert_dialog.dart';
import '../../../trips/presentation/views/trips_view.dart';
import '../../../wallet/presentation/views/wallet_view.dart';
import '../cubit/home_cubit.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          //! Background
          Transform.flip(
            flipX: context.read<GlobalCubit>().language == "ar",
            child: Image.asset(
              Assets.imagesDrawerBackground,
              width: 315.rW(context),
              height: double.infinity,
              fit: BoxFit.fill,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),

          //! Close Button
          PositionedDirectional(
            top: 52.rH(context),
            end: 40.rW(context),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 38.rH(context),
                width: 38.rH(context),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.close, color: AppColors.primary),
              ),
            ),
          ),

          //! Content
          PositionedDirectional(
            top: 94.rH(context),
            bottom: 0,
            start: 38.rW(context),
            child: SizedBox(
              width: 258.rW(context),
              child: Column(
                children: [
                  //! Image, Name & Rate
                  BlocBuilder<GlobalCubit, GlobalState>(
                    builder: (context, state) {
                      final globalCubit = context.read<GlobalCubit>();
                      return Row(
                        children: [
                          //! Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl:
                                  globalCubit.userModel?.profilePicture ?? "",
                              height: 76.rH(context),
                              width: 76.rH(context),
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return SvgPicture.asset(
                                  Assets.imagesPersonSvg,
                                  color: AppColors.grey,
                                );
                              },
                            ),
                          ),

                          SizedBox(width: 16.rW(context)),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //! Name
                                Text(
                                  globalCubit.userModel?.username ?? "",
                                  style: Styles.semibold18Primary(context)
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                      ),
                                ),
                                SizedBox(height: 4.rH(context)),
                                //! Rating
                                Row(
                                  children: [
                                    SinglePartialStar(
                                      value:
                                          double.tryParse(
                                            globalCubit.userModel?.rating
                                                    ?.toString() ??
                                                "0.0",
                                          ) ??
                                          0.0,
                                      starSize: 20.rH(context),
                                    ),
                                    SizedBox(width: 5.rW(context)),
                                    Text(
                                      double.tryParse(
                                            globalCubit.userModel?.rating
                                                    ?.toString() ??
                                                "0.0",
                                          )?.toStringAsFixed(3) ??
                                          "0.0",
                                      style: Styles.regular16(
                                        context,
                                      ).copyWith(color: AppColors.greyText),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 35.rH(context)),

                  //! Edit Profile
                  Row(
                    children: [
                      CustomButton(
                        onPressed: () {
                          Navigator.pop(context);
                          navigate(context, const EditProfileView());
                        },
                        title: AppStrings.editProfile.tr(context),
                        icon: const CustomSvgPicture(svg: Assets.imagesEdit),
                        widgth: null,
                      ),
                    ],
                  ),

                  SizedBox(height: 35.rH(context)),

                  //! List Tiles
                  //* Rider Mode
                  drawerListTile(
                    context,
                    title: AppStrings.driverMode.tr(context),
                    svg: Assets.imagesDriverMode,
                    onTap: () {},
                    trailing: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return CustomSwitch(
                          value: false,
                          onChanged: (onChanged) {
                            navBarNavigate(
                              context: context,
                              widget: const BecomeRiderOrDriverView(),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  //* Preferences
                  drawerListTile(
                    context,
                    svg: Assets.imagesPreferences,
                    title: AppStrings.preferences.tr(context),
                    onTap: () {
                      navBarNavigate(
                        context: context,
                        widget: const PreferencesView(isEdit: true),
                      );
                    },
                  ),
                  //* SavedPlaces
                  drawerListTile(
                    context,
                    svg: Assets.imagesSavedPlaces,
                    title: AppStrings.savedPlaces.tr(context),
                    onTap: () {
                      navBarNavigate(
                        context: context,
                        widget: const SavedPlacesView(),
                      );
                    },
                  ),
                  //* PromoCode
                  drawerListTile(
                    context,
                    svg: Assets.imagesPromoCode,
                    title: AppStrings.promoCode.tr(context),
                    onTap: () {
                      navBarNavigate(
                        context: context,
                        widget: const PromoCodeView(),
                      );
                    },
                  ),
                  // //* Requests
                  // drawerListTile(
                  //   context,
                  //   title: AppStrings.requests.tr(context),
                  //   svg: Assets.imagesRequests,
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     navigate(
                  //       context,
                  //       FindRidersView(
                  //         acceptedTripTypeIds: context
                  //             .read<HomeCubit>()
                  //             .driverTripTypes,
                  //       ),
                  //     );
                  //   },
                  // ),
                  //* Trips
                  drawerListTile(
                    context,
                    title: AppStrings.trips.tr(context),
                    svg: Assets.imagesHistory,
                    onTap: () {
                      // Navigator.pop(context);
                      navigate(context, const TripsView());
                    },
                  ),
                  //* Wallet
                  drawerListTile(
                    context,
                    title: AppStrings.wallet.tr(context),
                    svg: Assets.imagesWalletActive,
                    onTap: () {
                      // Navigator.pop(context);
                      navigate(context, const WalletView());
                    },
                  ),
                  //* Language
                  drawerListTile(
                    context,
                    title: AppStrings.arabic.tr(context),
                    svg: Assets.imagesLanguage,
                    trailing: CustomSwitch(
                      value: context.read<GlobalCubit>().language == "ar",
                      onChanged: (value) {
                        context.read<GlobalCubit>().languageToggle();
                      },
                    ),
                    onTap: () {
                      context.read<GlobalCubit>().languageToggle();
                    },
                  ),
                  //* Dark Mode
                  drawerListTile(
                    context,
                    title: AppStrings.darkMode.tr(context),
                    svg: Assets.imagesDarkModeNightMoonSvgrepoCom,
                    trailing: CustomSwitch(
                      value: context.read<GlobalCubit>().isDarkMode,
                      onChanged: (value) {
                        context.read<GlobalCubit>().darkModeToggle();
                      },
                    ),
                    onTap: () {
                      context.read<GlobalCubit>().darkModeToggle();
                    },
                  ),

                  //* help
                  drawerListTile(
                    context,
                    svg: Assets.imagesHelp,
                    title: AppStrings.help.tr(context),
                    onTap: () {
                      navBarNavigate(
                        context: context,
                        widget: const HelperPage(),
                      );
                    },
                  ),
                  //* Learning Center
                  drawerListTile(
                    context,
                    svg: Assets.imagesLearningCenter,
                    title: AppStrings.learningCenter.tr(context),
                    onTap: () {
                      navBarNavigate(
                        context: context,
                        widget: const LearningPage(),
                      );
                    },
                  ),
                  const Spacer(),

                  //* Logout
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const LogoutAlertDialog(),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 32.rH(context)),
                      color: AppColors.transparent,
                      child: Row(
                        children: [
                          //! Icon
                          Transform.flip(
                            flipX: context.read<GlobalCubit>().language == "en"
                                ? true
                                : false,
                            child: CustomSvgPicture(
                              svg: Assets.imagesLogout,
                              height: 22.rH(context),
                              width: 22.rW(context),
                            ),
                          ),
                          SizedBox(width: 16.rW(context)),
                          //! Title
                          Expanded(
                            child: Text(
                              AppStrings.logout.tr(context),
                              style: Styles.medium16Primary(
                                context,
                              ).copyWith(color: AppColors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerListTile(
    BuildContext context, {
    required String title,
    required String svg,
    required Function() onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.rH(context)),
        color: AppColors.transparent,
        child: Row(
          children: [
            //! Icon
            SizedBox(
              height: 22.rH(context),
              width: 22.rW(context),
              child: CustomSvgPicture(svg: svg, color: AppColors.primary),
            ),
            SizedBox(width: 16.rW(context)),
            //! Title
            Expanded(
              child: Text(
                title,
                style: Styles.medium16Primary(
                  context,
                ).copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
            trailing ?? Container(),
          ],
        ),
      ),
    );
  }
}
