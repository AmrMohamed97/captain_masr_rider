import '../../../../core/imports/imports.dart';

class NegotiateBottomSheet extends StatefulWidget {
  final int driverRequestId;
  final double initialPrice;
  final Function(double price, String? message) onSubmit;

  const NegotiateBottomSheet({
    super.key,
    required this.driverRequestId,
    required this.initialPrice,
    required this.onSubmit,
  });

  @override
  State<NegotiateBottomSheet> createState() => _NegotiateBottomSheetState();
}

class _NegotiateBottomSheetState extends State<NegotiateBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    // Pre-populate with the initial price suggested by the driver
    _priceController = TextEditingController(
      text: widget.initialPrice.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _updatePrice(double newPrice) {
    if (newPrice < 1) newPrice = 1;
    _priceController.text = newPrice.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(20.rH(context)),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Initial Price display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.negotiationOffer.tr(context),
                  style: Styles.bold20(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.rW(context),
                    vertical: 6.rH(context),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${widget.initialPrice.toStringAsFixed(0)} ${AppStrings.egp.tr(context)}",
                    style: Styles.semibold14Primary(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.rH(context)),
            Text(
              AppStrings.originalDriverOfferSub.tr(context),
              style: Styles.regular14(context).copyWith(
                color: AppColors.greyText,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20.rH(context)),

            // Counter Card
            Container(
              padding: EdgeInsets.all(16.rH(context)),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Decrement Button
                  IconButton(
                    onPressed: () {
                      final current =
                          double.tryParse(_priceController.text) ??
                          widget.initialPrice;
                      _updatePrice(current - 5);
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primary,
                    iconSize: 40.rH(context),
                  ),
                  // Middle Price text field
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
                        style: Styles.bold28white(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 28.rT(context),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixText: " ${AppStrings.egp.tr(context)}",
                          suffixStyle: Styles.semibold16Primary(
                            context,
                          ).copyWith(color: AppColors.greyText),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppStrings.priceRequired.tr(context);
                          }
                          final price = double.tryParse(value);
                          if (price == null || price < 1) {
                            return AppStrings.priceRequired.tr(context);
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  // Increment Button
                  IconButton(
                    onPressed: () {
                      final current =
                          double.tryParse(_priceController.text) ??
                          widget.initialPrice;
                      _updatePrice(current + 5);
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                    iconSize: 40.rH(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.rH(context)),

            // Quick Discount Pills
            Text(
              AppStrings.quickDiscountFromOffer.tr(context),
              style: Styles.medium12(
                context,
              ).copyWith(color: AppColors.greyText),
            ),
            SizedBox(height: 10.rH(context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [5, 10, 15, 20].map((discount) {
                final targetPrice = widget.initialPrice - discount;
                if (targetPrice < 1) return const SizedBox();
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.rW(context)),
                    child: InkWell(
                      onTap: () {
                        _updatePrice(targetPrice);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.rH(context)),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.12),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "-$discount ${AppStrings.egp.tr(context)}",
                            style: Styles.semibold12(
                              context,
                            ).copyWith(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24.rH(context)),

            // Submit Button
            CustomButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final price = double.parse(_priceController.text);
                  widget.onSubmit(price, null);
                  Navigator.pop(context);
                }
              },
              title: AppStrings.sendOffer.tr(context),
            ),
            SizedBox(height: 16.rH(context)),
          ],
        ),
      ),
    );
  }
}
