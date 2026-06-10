import '../../../../core/imports/imports.dart';
import '../../data/models/services_model.dart';

class HomeServiceCard extends StatelessWidget {
  const HomeServiceCard({
    super.key,
    required this.model,
    required this.onTap,
    required this.selected,
    required this.index,
  });

  final ServicesModel model;
  final Function() onTap;
  final bool selected;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: selected ? 1 : .85,
        child: SizedBox(
          width: 156.rW(context),
          child: Stack(
            children: [
              //! Background
              BlocBuilder<GlobalCubit, GlobalState>(
                builder: (context, state) {
                  return Transform.flip(
                    flipX: context.read<GlobalCubit>().language == "ar",
                    child: CustomSvgPicture(
                      svg: Assets.imagesServiceCardContainer,
                      width: 146.rW(context),
                      height: 138.rH(context),
                      fit: BoxFit.fill,
                      color: selected
                          ? AppColors.primary
                          : Theme.of(context).cardColor,
                    ),
                  );
                },
              ),
              //! Forward Button
              PositionedDirectional(
                bottom: 0,
                end: 10.rW(context),
                child: Container(
                  width: 28.rH(context),
                  height: 28.rH(context),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: selected ? AppColors.white : AppColors.black,
                      size: 11.rH(context),
                    ),
                  ),
                ),
              ),

              PositionedDirectional(
                top: 12.rH(context),
                start: 11.rW(context),
                end: index == 3 ? -18.rW(context) : -12.rW(context),
                bottom: 11.rH(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //! Type
                    // Text(
                    //   model.type.tr(context),
                    //   style: Styles.semibold16Primary(context).copyWith(
                    //     color: selected
                    //         ? AppColors.white
                    //         : Theme.of(context).textTheme.bodyLarge?.color,
                    //     fontSize: 13.rT(context),
                    //   ),
                    // ),
                    //! Image
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Image.asset(
                          model.image,
                          height: 88.rH(context),
                          width: 132.rW(context),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    //! Title
                    // Text(
                    //   model.title.tr(context),
                    //   style: Styles.regular13(context).copyWith(
                    //     color: selected
                    //         ? AppColors.white
                    //         : Theme.of(context).textTheme.bodyLarge?.color,
                    //     fontSize: 10.rT(context),
                    //   ),
                    // ),
                    Text(
                      model.type.tr(context),
                      style: Styles.semibold16Primary(context).copyWith(
                        color: selected
                            ? AppColors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 13.rT(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
