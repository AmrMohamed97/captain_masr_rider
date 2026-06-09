// import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_slide_transition.dart';
import '../../../../core/widgets/partial_star.dart';
import '../../../../core/widgets/rounded_border_timer.dart';
import 'find_driver_bottom_container.dart';
import 'find_driver_my_location_pin.dart';
import 'looking_for_drivers_card.dart';
import 'negotiate_bottom_sheet.dart';

class FindDriverBody extends StatefulWidget {
  const FindDriverBody({super.key});

  @override
  State<FindDriverBody> createState() => _FindDriverBodyState();
}

class _FindDriverBodyState extends State<FindDriverBody> {
  int? pausedRequestId;
  Set<int> negotiatingRequests = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FindDriverCubit, FindDriverState>(
      builder: (context, state) {
        final cubit = context.read<FindDriverCubit>();
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              //! Map
              Positioned.fill(
                child: GoogleMap(
                  style: context.read<GlobalCubit>().isDarkMode
                      ? context.read<GlobalCubit>().mapDarkStyle
                      : null,
                  // myLocationEnabled: true,
                  zoomGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      cubit.tripDetails?.pickupLatitude ?? 0,
                      cubit.tripDetails?.pickupLongitude ?? 0,
                    ),
                    zoom: 14.151926040649414,
                  ),
                  // markers: {
                  //   const Marker(
                  //     markerId: MarkerId("value"),
                  //     position: LatLng(30.077290, 31.331747),
                  //   ),
                  // },
                ),
              ),

              //! Pop Button
              PositionedDirectional(
                start: 16.rW(context),
                end: 16.rW(context),
                child: const CustomAppBar(),
              ),

              //! Looking For Drivers Card
              Positioned(
                top: 96.rH(context),
                left: 0,
                right: 0,
                child: LookingForDriversCard(seconds: cubit.timerSeconds),
              ),

              //! My Location Pin
              const FindDriverMyLocationPin(),

              //! Requests
              Positioned(
                top: 210.rH(context),
                left: 0,
                right: 0,
                child: Column(
                  children: List.generate(
                    cubit.requests.length > 2 ? 2 : cubit.requests.length,
                    (index) {
                      final request = cubit.requests[index];
                      final requestId = request.requestId ?? 0;
                      final driverId = request.driverId ?? 0;
                      final requestPrice = request.price?.toDouble() ?? 0.0;
                      final requestIdVal = request.id;
                      final bool isWaitingForDriver = negotiatingRequests.contains(requestId);
                      final bool isDriverAccepted = request.negotiationStatus == "driver_accepted" &&
                          request.negotiation?.action == "driver_accepted";
                      final bool isDriverCounterOffer = request.negotiation?.action == "counter_offer";

                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.rH(context)),
                        child: SlideFromLeft(
                          child: RoundedBorderTimer(
                            key: ValueKey('${request.id}_${negotiatingRequests.contains(requestId)}'),
                            isPaused: requestId == pausedRequestId,
                            onComplete: () {
                              cubit.declineDriver(driverId: driverId);
                              cubit.removeRequest(requestIdVal);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 334.rW(context),
                              padding: EdgeInsets.only(
                                top: 15.rH(context),
                                bottom: 11.rH(context),
                                left: 16.rW(context),
                                right: 16.rW(context),
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //! User Details & Cost
                                  Row(
                                    children: [
                                      //! User Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          request.driverImage ?? "",
                                          height: 46.rH(context),
                                          width: 46.rH(context),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  CircleAvatar(
                                                    radius: 23.rH(context),
                                                    backgroundColor:
                                                        AppColors.grey3,
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: AppColors.greyText,
                                                    ),
                                                  ),
                                        ),
                                      ),
                                      SizedBox(width: 9.rW(context)),

                                      //! Name & Rating
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            //! Name
                                            Text(
                                              request.driverName ?? "",
                                              style:
                                                  Styles.semibold16Primary(
                                                    context,
                                                  ).copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                            ),
                                            SizedBox(height: 2.rH(context)),
                                            //! Rating
                                            Row(
                                              children: [
                                                SinglePartialStar(
                                                  value:
                                                      request.driverRating
                                                          ?.toDouble() ??
                                                      0.0,
                                                  starSize: 18.rH(context),
                                                ),
                                                SizedBox(width: 7.rW(context)),
                                                Text(
                                                  "${num.parse((request.driverRating ?? 0.0).toStringAsFixed(2))}",
                                                  style:
                                                      Styles.regular14(
                                                        context,
                                                      ).copyWith(
                                                        color:
                                                            AppColors.greyText,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 9.rW(context)),

                                      //! Arrives In
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppStrings.arrivesIn.tr(context),
                                            style: Styles.regular12(
                                              context,
                                            ).copyWith(color: AppColors.grey),
                                          ),
                                          SizedBox(height: 2.rH(context)),
                                          RichText(
                                            text: TextSpan(
                                              style: Styles.regular12(context)
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      request
                                                          .timeBetRiderAndDriver
                                                          ?.toString() ??
                                                      "?",
                                                ),
                                                TextSpan(
                                                  text:
                                                      " ${AppStrings.min.tr(context)}",
                                                ),
                                                WidgetSpan(
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 4.rW(
                                                            context,
                                                          ),
                                                        ),
                                                    width: 1,
                                                    height: 14.rH(context),
                                                    color: AppColors.grey,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      request
                                                          .distanceBetRiderAndDriver
                                                          ?.toString() ??
                                                      "?",
                                                ),
                                                TextSpan(
                                                  text:
                                                      " ${AppStrings.km.tr(context)}",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  //! Divider
                                  Divider(
                                    color: AppColors.greyText.withOpacity(.15),
                                  ),
                                  //! Car Details & Cost
                                  Row(
                                    children: [
                                      Image.asset(
                                        cubit.isDelivery
                                            ? Assets.imagesDeliveryTripCard
                                            : Assets.imagesTestCar1,
                                        height: 27.rH(context),
                                        width: 40.rW(context),
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 11.rW(context)),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //! Brand & Model
                                            Text(
                                              "${request.vehicleBrand ?? ""} ${request.vehicleModel ?? ""}",
                                              style: Styles.semibold12(context)
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                            ),
                                            SizedBox(height: 1.rH(context)),
                                            //! Color & Plate
                                            Text(
                                              "${request.vehicleColor ?? ""} - ${request.vehiclePlats ?? ""}",
                                              style: Styles.regular12(context)
                                                  .copyWith(
                                                    color: AppColors.greyText,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      Text(
                                        "${request.negotiation?.riderPrice?.toStringAsFixed(2) ?? request.price?.toStringAsFixed(2) ?? ""} ${AppStrings.egp.tr(context)}",
                                        style: Styles.semibold20Primary(
                                          context,
                                        ).copyWith(color: AppColors.red),
                                      ),
                                    ],
                                  ),
                                  //! Buttons or Waiting Message
                                  if (isDriverAccepted)
                                    // رد السائق بالموافقة - عرض سعر الموافقة وأزرار القبول أو الرفض
                                    Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10.rH(context)),
                                          margin: EdgeInsets.only(bottom: 8.rH(context)),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.10),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.check_circle_outline, color: Colors.green, size: 18.rH(context)),
                                              SizedBox(width: 6.rW(context)),
                                              Text(
                                                "وافق السائق على سعر ${request.negotiation?.riderPrice?.toStringAsFixed(0) ?? ""} جنيه",
                                                style: Styles.semibold14Primary(context).copyWith(color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomButton(
                                                onPressed: () {
                                                  cubit.declineDriver(driverId: driverId);
                                                  cubit.removeRequest(requestIdVal);
                                                },
                                                title: AppStrings.decline.tr(context),
                                                color: AppColors.transparent,
                                                textColor: AppColors.primary,
                                                borderColor: AppColors.primary,
                                              ),
                                            ),
                                            SizedBox(width: 8.rW(context)),
                                            Expanded(
                                              child: CustomButton(
                                                onPressed: () {
                                                  if (state is! AcceptDriverLoadingState) {
                                                    cubit.acceptDriver(
                                                      driverId: driverId,
                                                      driverRequestId: requestId,
                                                    );
                                                  }
                                                },
                                                title: state is AcceptDriverLoadingState
                                                    ? 'loading...'
                                                    : AppStrings.accept.tr(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  else if (isWaitingForDriver && !isDriverCounterOffer)
                                    // في انتظار رد السائق
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(vertical: 12.rH(context)),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "في إنتظار رد السائق على عرضك...",
                                        style: Styles.semibold14Primary(context),
                                      ),
                                    )
                                  else
                                    // الأزرار العادية (لم يتم التفاوض بعد أو السائق قدم عرضاً مضاداً)
                                    Row(
                                      children: [
                                        //! Decline Button
                                        Expanded(
                                          child: CustomButton(
                                            onPressed: () {
                                              cubit.declineDriver(
                                                driverId: driverId,
                                              );
                                              cubit.removeRequest(requestIdVal);
                                            },
                                            title: AppStrings.decline.tr(context),
                                            color: AppColors.transparent,
                                            textColor: AppColors.primary,
                                            borderColor: AppColors.primary,
                                          ),
                                        ),
                                        SizedBox(width: 8.rW(context)),
                                        //! Negotiate Button
                                        if (request.negotiation?.riderPrice == null || isDriverCounterOffer)
                                          Expanded(
                                            child: CustomButton(
                                              onPressed: () async {
                                                setState(() {
                                                  pausedRequestId = requestId;
                                                });
                                                await showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder: (_) =>
                                                      NegotiateBottomSheet(
                                                        driverRequestId:
                                                            requestId,
                                                        initialPrice: isDriverCounterOffer
                                                            ? (request.negotiation?.driverPrice?.toDouble() ?? requestPrice)
                                                            : requestPrice,
                                                        onSubmit: (price, message) {
                                                          setState(() {
                                                            negotiatingRequests.add(requestId);
                                                          });
                                                          cubit.negotiateDriver(
                                                            driverRequestId:
                                                                requestId,
                                                            price: price,
                                                            message: message,
                                                          );
                                                        },
                                                      ),
                                                );
                                                if (mounted) {
                                                  setState(() {
                                                    pausedRequestId = null;
                                                  });
                                                }
                                              },
                                              title: isDriverCounterOffer
                                                  ? "رد على العرض"
                                                  : AppStrings.negotiate.tr(context),
                                              color: AppColors.transparent,
                                              textColor: AppColors.primary,
                                              borderColor: AppColors.primary,
                                            ),
                                          ),
                                        SizedBox(width: 8.rW(context)),
                                        //! Accept Button
                                        Expanded(
                                          child: CustomButton(
                                            onPressed: () {
                                              if (state
                                                  is! AcceptDriverLoadingState) {
                                                cubit.acceptDriver(
                                                  driverId: driverId,
                                                  driverRequestId: requestId,
                                                );
                                              }
                                            },
                                            title:
                                                state is AcceptDriverLoadingState
                                                ? 'loading...'
                                                : AppStrings.accept.tr(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              //! Bottom Section
              const FindDriverBottomContainer(),
            ],
          ),
        );
      },
    );
  }
}
