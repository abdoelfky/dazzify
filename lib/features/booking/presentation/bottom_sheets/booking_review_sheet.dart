import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/data/requests/create_booking_review_request.dart';
import 'package:dazzify/features/booking/logic/booking_review/booking_review_cubit.dart';
import 'package:dazzify/features/home/presentation/widgets/custom_rating_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/dazzify_multiline_text_field.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/features/user/data/models/user/user_model.dart';

class BookingReviewSheet extends StatefulWidget {
  final BookingReviewCubit bookingReviewCubit;
  final UserModel userModel;

  const BookingReviewSheet({
    super.key,
    required this.bookingReviewCubit,
    required this.userModel,
  });

  @override
  State<BookingReviewSheet> createState() => _BookingReviewSheetState();
}

class _BookingReviewSheetState extends State<BookingReviewSheet> {
  late final GlobalKey<FormState> formKey;
  double rating = 0;
  bool isLoading = false;
  String reviewComment = "";

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        widget.bookingReviewCubit.setNotInterestedToReview();
      },
      child: BlocBuilder<BookingReviewCubit, BookingReviewState>(
        buildWhen: (previous, current) =>
            previous.bookingReviewRequestState !=
            current.bookingReviewRequestState,
        builder: (context, state) {
          return Form(
            key: formKey,
            child: DazzifySheetBody(
              height: context.isKeyboardClosed
                  ? context.screenHeight * 0.85
                  : context.screenHeight,
              title: context.tr.writeReview,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
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
                              imageUrl: state.bookingReviewRequest.brand.logo,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: [
                              DText(
                                state.bookingReviewRequest.brand.name,
                                style: context.textTheme.bodyLarge,
                              ),
                              SizedBox(height: 9),
                              DText(
                                "${state.bookingReviewRequest.totalPrice.toString()} ${context.tr.currency}",
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ).r,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(360).r,
                              child: DazzifyCachedNetworkImage(
                                imageUrl: widget.userModel.picture ?? "",
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
                                  widget.userModel.fullName,
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
                        padding: const EdgeInsets.symmetric(vertical: 12).r,
                        child: Center(
                          child: CustomRatingBar(
                            initialRating: 0,
                            onRatingUpdate: (value) {
                              rating = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ).r,
                        child: DazzifyMultilineTextField(
                          maxLength: 200,
                          hintText: context.tr.reviewComment,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr.textIsRequired;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              reviewComment = value;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 62.h),
                      BlocListener<BookingReviewCubit, BookingReviewState>(
                        listener: (context, state) {
                          if (state.addReviewState == UiState.loading) {
                            isLoading = true;
                          } else if (state.addReviewState == UiState.success) {
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
                              widget.bookingReviewCubit.addBookingReview(
                                CreateBookingReviewRequest(
                                  bookingId:
                                      state.bookingReviewRequest.bookingId,
                                  comment: reviewComment,
                                  rate: rating,
                                ),
                              );
                            }
                          },
                          title: context.tr.createReview,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<void> showBookingReviewSheet({
  required BuildContext context,
  required BookingReviewCubit bookingReviewCubit,
  required UserModel userModel,
}) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    routeSettings: const RouteSettings(
      name: "ServiceSelectionBottomSheet",
    ),
    builder: (context) => BlocProvider.value(
      value: bookingReviewCubit,
      child: BookingReviewSheet(
        bookingReviewCubit: bookingReviewCubit,
        userModel: userModel,
      ),
    ),
  );
}
