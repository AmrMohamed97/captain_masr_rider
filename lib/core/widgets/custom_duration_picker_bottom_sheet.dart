import 'package:flutter/cupertino.dart';
import '../imports/imports.dart';

Future<int?> customDurationPickerBottomSheet(
  BuildContext context, {
  int initialDuration = 30,
}) async {
  int selectedDuration = initialDuration;
  final initialIndex = selectedDuration - 5;

  return await showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 24.rH(context),
          horizontal: 8.rW(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.tripDuration.tr(context),
              style: Styles.semibold16Primary(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(height: 16.rH(context)),
            SizedBox(
              height: 200.rH(context),
              child: CupertinoPicker(
                looping: false,
                itemExtent: 40,
                scrollController: FixedExtentScrollController(
                  initialItem: initialIndex >= 0 ? initialIndex : 25,
                ),
                onSelectedItemChanged: (int index) {
                  selectedDuration = index + 5;
                },
                children: List.generate(296, (index) {
                  final minutes = index + 5;
                  return Center(
                    child: Text(
                      "$minutes ${AppStrings.min.tr(context)}",
                      style: Styles.semibold24Primary(context).copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 16.rH(context)),
            //! Choose Button
            CustomButton(
              title: AppStrings.save.tr(context),
              onPressed: () {
                Navigator.pop(context, selectedDuration);
              },
            ),
          ],
        ),
      );
    },
  );
}
