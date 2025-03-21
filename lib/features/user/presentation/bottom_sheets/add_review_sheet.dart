import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/home/presentation/widgets/custom_rating_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';

class AddReviewSheet extends StatefulWidget {
  const AddReviewSheet({super.key});

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  late final BookingCubit bookingCubit;
  late final GlobalKey<FormState> formKey;
  bool isLoading = false;
  late double rating;
  late String reviewComment;

  @override
  void initState() {
    bookingCubit = context.read<BookingCubit>();
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DazzifySheetBody(
      title: context.tr.writeReview,
      textStyle: context.textTheme.titleLarge,
      children: [
        Expanded(
          child: ListView(
            children: [
              SizedBox(height: 28.h),
              serviceInfo(context, bookingCubit),
              SizedBox(height: 28.h),
              brandInfo(context, bookingCubit),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24).r,
                child: Center(
                  child: CustomRatingBar(
                    initialRating: 0,
                    onRatingUpdate: (value) {
                      rating = value;
                    },
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24).r,
                      child: DazzifyTextFormField(
                        height: 46,
                        textInputType: TextInputType.text,
                        borderRadius: 12,
                        hintText: context.tr.reviewComment,
                        maxLength: 500,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.tr.textIsRequired;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          reviewComment = value;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            reviewComment = value;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 62.h),
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
                          if (formKey.currentState!.validate()) {
                            bookingCubit.createReview(
                              comment: reviewComment,
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
            ],
          ),
        ),
      ],
    );
  }
}

Widget serviceInfo(BuildContext context, BookingCubit bookingCubit) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadiusDirectional.only(
            topStart: const Radius.circular(50).r,
            topEnd: const Radius.circular(20).r,
            bottomStart: const Radius.circular(20).r,
            bottomEnd: const Radius.circular(50).r,
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
            DText(
              bookingCubit.state.singleBooking.services.first.title,
              style: context.textTheme.bodyLarge,
            ),
            DText(
              "\$ ${bookingCubit.state.singleBooking.price}",
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget brandInfo(BuildContext context, BookingCubit bookingCubit) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24).r,
    child: Row(
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
    ),
  );
}
