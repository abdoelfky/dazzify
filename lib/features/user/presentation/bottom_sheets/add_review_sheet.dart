import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/validation_manager.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/home/presentation/widgets/custom_rating_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/dazzify_multiline_text_field.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';

class AddReviewSheet extends StatefulWidget {
  const AddReviewSheet({super.key});

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  late final BookingCubit bookingCubit;
  late final GlobalKey<FormState> formKey;
  late final TextEditingController _reviewController;
  late UserCubit _profileCubit;

  bool isLoading = false;
  double rating = 0;

  @override
  void initState() {
    bookingCubit = context.read<BookingCubit>();
    formKey = GlobalKey<FormState>();
    _reviewController = TextEditingController();
    _profileCubit = context.read<UserCubit>();

    super.initState();
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DazzifySheetBody(
        height: context.isKeyboardClosed
            ? context.screenHeight * 0.85
            : context.screenHeight,
        title: context.tr.writeReview,
        textStyle: context.textTheme.titleLarge,
        enableBottomInsets: true,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      serviceInfo(context, bookingCubit),
                      SizedBox(height: 20.h),
                      Padding(
                        padding:  EdgeInsets.symmetric(
                          vertical: 4.h,
                          horizontal: 24,
                        ).r,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(360).r,
                              child: DazzifyCachedNetworkImage(
                                imageUrl: _profileCubit.state.userModel.picture ?? "",
                                fit: BoxFit.cover,
                                placeHolder: AssetsManager.avatar,
      
                                height: 40.h,
                                width: 40.w,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DText(
                                  _profileCubit.state.userModel.fullName,
                                  style: context.textTheme.bodyMedium,
                                ),
                                SizedBox(height: 4.h),
                                SizedBox(
                                  width: 220.w,
                                  child: DText(
                                    context.tr.reviewConditions,
                                    style:
                                    context.textTheme.bodySmall!.copyWith(
                                      color:
                                      context.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16).r,
                        child: Center(
                          child: CustomRatingBar(
                            initialRating: 0,
                            onRatingUpdate: (value) {
                              rating = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: formKey,

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                    child: Column(

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            // vertical: 12,
                            horizontal: 8,
                          ).r,
                          child: DazzifyMultilineTextField(
                            maxLength: 200,
                            controller: _reviewController,
                            hintText: context.tr.reviewComment,
                            validator: (value) {
                              return ValidationManager.hasData(
                                data: _reviewController.text,
                                errorMessage: context.tr.textIsTooShort,
                              );
                            },
                            onSaved: (value) {
                              if (value != null) {
                                _reviewController.text = value;
                              }
                            },
                          ),
                        ),
                        // SizedBox(height: 62.h),
                        BlocListener<BookingCubit, BookingState>(
                          listener: (context, state) {
                            if (state.createReviewState == UiState.loading) {
                              isLoading = true;
                            } else if (state.createReviewState == UiState.success) {
                              isLoading = false;
                              context.maybePop();
                              DazzifyToastBar.showSuccess(
                                message: context.tr.reviewCreated,
                              );
                            } else {
                              isLoading = false;
                            }
                          },
                          child: PrimaryButton(
                            isLoading: isLoading,
                            onTap: () {
                              if (rating == 0) {
                                DazzifyToastBar.showError(
                                  message: context.tr.pleaseSelectRating,
                                );
                                return;
                              }
                              if (formKey.currentState!.validate()) {
                                bookingCubit.createReview(
                                  comment: _reviewController.text,
                                  rate: rating,
                                );
                              }
                            },
                            title: context.tr.createReview,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget serviceInfo(BuildContext context, BookingCubit bookingCubit) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadiusDirectional.only(
          topStart: const Radius.circular(40).r,
          topEnd: const Radius.circular(16).r,
          bottomStart: const Radius.circular(16).r,
          bottomEnd: const Radius.circular(40).r,
        ),
        child: DazzifyCachedNetworkImage(
          width: 120.w,
          height: 145.h,
          imageUrl: bookingCubit.state.singleBooking.services.first.image,
          fit: BoxFit.cover,
        ),
      ),
      SizedBox(width: 16.w),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 180.w),
            child: IntrinsicWidth(
              child: DText(
                maxLines: 2,
                bookingCubit.state.singleBooking.services.first.title,
                style: context.textTheme.bodyLarge,
              ),
            ),
          ),
          SizedBox(height: 9.h),
          DText(
            "${bookingCubit.state.singleBooking.price} ${context.tr.egp}",
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget brandInfo(BuildContext context, BookingCubit bookingCubit) {
  return Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(360).r,
        child: DazzifyCachedNetworkImage(
          imageUrl: bookingCubit.state.singleBooking.brand.logo,
          fit: BoxFit.cover,
          height: 40.h,
          width: 40.w,
        ),
      ),
      SizedBox(width: 16.w),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DText(
            bookingCubit.state.singleBooking.brand.name,
            style: context.textTheme.bodyMedium,
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: 220.w,
            child: DText(
              context.tr.reviewConditions,
              style: context.textTheme.bodySmall!.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
