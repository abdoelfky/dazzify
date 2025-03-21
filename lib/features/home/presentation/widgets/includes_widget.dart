import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/home/logic/service_details/service_details_bloc.dart';

class IncludesWidget extends StatelessWidget {
  final List<String> include;

  const IncludesWidget({
    super.key,
    required this.include,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0).r,
                child: Divider(
                  height: 1.h,
                  color: context.colorScheme.outlineVariant,
                ),
              ),
              SizedBox(height: 16.h),
              DText(
                context.tr.includes,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
              SizedBox(height: 8.h),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: include.length,
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0).r,
                        child: CircleAvatar(
                          radius: 2.r,
                          backgroundColor: context.colorScheme.outline,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Flexible(
                        child: DText(
                          include[index],
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.outline,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0).r,
                child: Divider(
                  height: 1.h,
                  color: context.colorScheme.outlineVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
