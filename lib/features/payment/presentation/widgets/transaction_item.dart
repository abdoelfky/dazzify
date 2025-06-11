import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/payment/data/models/transaction_model.dart';
import 'package:dazzify/features/payment/presentation/widgets/transaction_bar.dart';
import 'package:dazzify/features/payment/presentation/widgets/transaction_button.dart';
import 'package:dazzify/features/shared/enums/transaction_enum.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TransactionItem extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late TransactionType transactionType;
  late PaymentStatus paymentStatus;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    transactionType = getTransactionType(widget.transaction.type);
    paymentStatus = getPaymentStatus(widget.transaction.status);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14).r,
      padding: const EdgeInsets.all(8).r,
      decoration: BoxDecoration(
        color: context.colorScheme.inversePrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8).r,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.transaction.services.length > 1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: DText(
                        transactionType.name,
                        style: context.textTheme.labelSmall!.copyWith(
                          color: context.colorScheme.primaryContainer,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      height: 90.h,
                      child: ListView.separated(
                        controller: _pageController,
                        itemCount: widget.transaction.services.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 6.w),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16).r,
                              color: context.colorScheme.inversePrimary
                                  .withValues(alpha: 0.1),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8).r,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8).r,
                                    child: DazzifyCachedNetworkImage(
                                      height: 70.h,
                                      width: 65.w,
                                      imageUrl: widget
                                          .transaction.services[index].image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DText(
                                      widget.transaction.services[index].title,
                                      style: context.textTheme.bodyMedium,
                                    ),
                                    SizedBox(
                                      width: 165.w,
                                      child: DText(
                                        widget.transaction.services[index]
                                            .description,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.textTheme.bodySmall!
                                            .copyWith(
                                          color: context
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 6.h),

                    Center(
                      child: SmoothPageIndicator(
                        controller:
                            _pageController, // Connect the page controller
                        count: widget.transaction.services.length, // The number of dots
                        effect: ScrollingDotsEffect(
                          // You can customize the dot effect here
                          activeDotColor: context.colorScheme.primary,
                          // Active dot color
                          dotColor: Colors.grey,
                          // Inactive dot color
                          dotHeight: 4.0.h,
                          // Height of the dot
                          dotWidth: 20.0.h,
                          // Width of the dot
                          spacing: 8.0.w, // Space between dots
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    DText(

                      "${reformatPriceWithCommas(widget.transaction.amount)} ${context.tr.egp}",
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8).r,
                      child: DazzifyCachedNetworkImage(
                        imageUrl: widget.transaction.services[0].image,
                        width: 80.w,
                        height: 100.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 24.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 140.w,
                              child: DText(
                                widget.transaction.services[0].title,
                                style: context.textTheme.bodyMedium,
                              ),
                            ),
                            DText(
                              transactionType.name,
                              style: context.textTheme.labelSmall!.copyWith(
                                color: context.colorScheme.primaryContainer,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: 193.w,
                          child: DText(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            widget.transaction.services[0].description,
                            style: context.textTheme.bodySmall!.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        DText(
                          "${reformatPriceWithCommas(widget.transaction.amount)} ${context.tr.egp}",
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
          SizedBox(height: 6.h),
          paymentStatusWidget(),
        ],
      ),
    );
  }

  Widget paymentStatusWidget() {

    if (paymentStatus == PaymentStatus.cancelled) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            SolarIconsOutline.closeCircle,
            color: context.colorScheme.error,
            size: 12.r,
          ),
          SizedBox(width: 2.w),
          DText(
            context.tr.canceled,
            style: context.textTheme.bodySmall!.copyWith(
              color: context.colorScheme.error,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          TransactionBar(
            transaction: widget.transaction,
            onTimerFinish: () {
              setState(() {
                widget.transaction.status = "cancelled";
              });
            },
          ),
          const Spacer(),
          TransactionButton(
            status: widget.transaction.status,
            serviceName: widget.transaction.services[0].title,
            transactionId: widget.transaction.id,
          ),
        ],
      );
    }
  }
}
