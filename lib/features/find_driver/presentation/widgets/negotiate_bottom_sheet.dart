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
  // final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _priceController =
        TextEditingController(text: widget.initialPrice.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _priceController.dispose();
    // _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(16.rH(context)),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.negotiationOffer.tr(context),
                style: Styles.semibold18Primary(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              SizedBox(height: 16.rH(context)),
              Text(
                AppStrings.offerPrice.tr(context),
                style: Styles.medium14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              SizedBox(height: 8.rH(context)),
              CustomTextField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                hintText: AppStrings.offerPrice.tr(context),
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
              SizedBox(height: 16.rH(context)),
              Text(
                AppStrings.messageToDriver.tr(context),
                style: Styles.medium14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              SizedBox(height: 8.rH(context)),
              // CustomTextField(
              //   controller: _messageController,
              //   hintText: "مثال: نزلها شوية علشان خاطري",
              //   maxLines: 3,
              // ),
              SizedBox(height: 24.rH(context)),
              CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final price = double.parse(_priceController.text);
                    // final message = _messageController.text.trim().isEmpty
                    //     ? null
                    //     : _messageController.text.trim();
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
      ),
    );
  }
}
