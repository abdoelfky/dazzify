import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/data/models/category_model.dart';
import 'package:dazzify/features/home/data/requests/generate_brand_recommendation_request.dart';
import 'package:dazzify/features/home/logic/brand_recommendation/brand_recommendation_cubit.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:solar_icons/solar_icons.dart';

@RoutePage()
class BrandRecommendationInputScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const BrandRecommendationInputScreen({super.key});

  @override
  State<BrandRecommendationInputScreen> createState() =>
      _BrandRecommendationInputScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    // Try to get HomeCubit from context, otherwise create a new one
    HomeCubit homeCubit;
    try {
      homeCubit = context.read<HomeCubit>();
    } catch (e) {
      homeCubit = getIt<HomeCubit>();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: homeCubit),
        BlocProvider(
          create: (context) => getIt<BrandRecommendationCubit>(),
        ),
      ],
      child: this,
    );
  }
}

class _BrandRecommendationInputScreenState
    extends State<BrandRecommendationInputScreen> {
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final AppEventsLogger _logger = getIt<AppEventsLogger>();
  DateTime? _selectedDate;
  final Map<String, int> _categoryWeights = {};
  final Set<String> _selectedCategoryIds = {};

  @override
  void initState() {
    super.initState();
    final homeCubit = context.read<HomeCubit>();
    // Always fetch categories to ensure they're loaded
    if (homeCubit.state.mainCategories.isEmpty) {
      homeCubit.getMainCategories();
    }
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: today,
      lastDate: now.add(const Duration(days: 365 * 2)),
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (pickedDate == null) return;

    final dateOnly = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
    setState(() {
      _selectedDate = dateOnly;
      _dateController.text = DateFormat('MMM dd, yyyy').format(dateOnly);
    });
  }

  void _toggleCategory(String categoryId) {
    setState(() {
      if (_selectedCategoryIds.contains(categoryId)) {
        _selectedCategoryIds.remove(categoryId);
        _categoryWeights.remove(categoryId);
      } else {
        _selectedCategoryIds.add(categoryId);
        _categoryWeights[categoryId] = 0;
      }
      _updateWeights();
    });
  }

  void _updateWeights() {
    if (_selectedCategoryIds.isEmpty) return;

    final int totalWeight = _categoryWeights.values.fold(0, (a, b) => a + b);
    if (totalWeight != 100) {
      // Distribute equally if not set
      final int equalWeight = 100 ~/ _selectedCategoryIds.length;
      final int remainder = 100 % _selectedCategoryIds.length;

      int index = 0;
      for (final categoryId in _selectedCategoryIds) {
        _categoryWeights[categoryId] =
            equalWeight + (index < remainder ? 1 : 0);
        index++;
      }
    }
  }

  void _updateWeight(String categoryId, int weight) {
    setState(() {
      _categoryWeights[categoryId] = weight.clamp(0, 100);
      final otherIds = _selectedCategoryIds.where((id) => id != categoryId).toList();
      if (otherIds.isEmpty) return; // single category: only one weight, must be 100
      final remaining = 100 - _categoryWeights[categoryId]!;
      final otherSum = otherIds.fold<int>(0, (s, id) => s + (_categoryWeights[id] ?? 0));
      if (otherSum <= 0) {
        // Give remaining equally to others
        final perOther = remaining ~/ otherIds.length;
        final remainder = remaining % otherIds.length;
        for (var i = 0; i < otherIds.length; i++) {
          _categoryWeights[otherIds[i]] = perOther + (i < remainder ? 1 : 0);
        }
      } else if (remaining != otherSum) {
        final factor = remaining / otherSum;
        int assigned = 0;
        for (var i = 0; i < otherIds.length; i++) {
          final id = otherIds[i];
          final v = (i == otherIds.length - 1)
              ? (remaining - assigned)
              : ((_categoryWeights[id]! * factor).round());
          _categoryWeights[id] = v.clamp(0, 100);
          assigned += _categoryWeights[id]!;
        }
      }
    });
  }

  bool _validateInput() {
    if (_budgetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr.pleaseEnterBudget)),
      );
      return false;
    }

    final budget = int.tryParse(_budgetController.text);
    if (budget == null || budget < 1 || budget > 1000000000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr.invalidBudget)),
      );
      return false;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr.pleaseSelectDate)),
      );
      return false;
    }

    // Validate that the selected date is not in the past
    final now = DateTime.now();
    final selectedDateOnly = DateTime(
        _selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
    final today = DateTime(now.year, now.month, now.day);
    if (selectedDateOnly.isBefore(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr.dateCannotBeInPast),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_selectedCategoryIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr.pleaseSelectCategories)),
      );
      return false;
    }

    final totalWeight = _categoryWeights.values.fold(0, (a, b) => a + b);
    if (totalWeight != 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr.percentagesMustSumTo100)),
      );
      return false;
    }

    return true;
  }

  void _generateRecommendation() {
    if (!_validateInput()) return;

    _logger.logEvent(event: AppEvents.brandRecommendationGenerate);

    final categories = _categoryWeights.entries
        .map((e) => CategoryWeight(
              categoryId: e.key,
              weight: e.value,
            ))
        .toList();

    // Format date only (yyyy-MM-dd)
    final String formattedDate =
        DateFormat('yyyy-MM-dd').format(_selectedDate!);

    context.read<BrandRecommendationCubit>().generateRecommendation(
          totalBudget: int.parse(_budgetController.text),
          date: formattedDate,
          categories: categories,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12).r,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _logger.logEvent(event: AppEvents.brandRecommendationBack);
                      context.maybePop();
                    },
                    icon: Icon(
                      context.isRtl
                          ? SolarIconsOutline.arrowRight
                          : SolarIconsOutline.arrowLeft,
                      size: 22.r,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      context.tr.brandRecommendations,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _logger.logEvent(
                          event: AppEvents.brandRecommendationInputClickHistory);
                      context.pushRoute(const BrandRecommendationHistoryRoute());
                    },
                    icon: Icon(
                      SolarIconsOutline.clockCircle,
                      size: 22.r,
                      color: context.colorScheme.onSurface,
                    ),
                    tooltip: context.tr.recommendationsHistory,
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocListener<BrandRecommendationCubit,
                  BrandRecommendationState>(
                listener: (context, state) {
                  if (state.blocState == UiState.success &&
                      state.recommendation != null) {
                    context.pushRoute(
                      BrandRecommendationResultsRoute(
                        recommendation: state.recommendation!,
                      ),
                    );
                  }
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16).r,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Budget Input
                      Container(
                        padding: const EdgeInsets.all(16).r,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16).r,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  SolarIconsOutline.wallet,
                                  color: context.colorScheme.primary,
                                  size: 20.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  context.tr.totalBudget,
                                  style: context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            DazzifyTextFormField(
                              controller: _budgetController,
                              textInputType: TextInputType.number,
                              hintText: context.tr.enterBudget,
                              prefixIconData: SolarIconsOutline.wallet,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return null; // Don't show error on empty, we'll validate on submit
                                }
                                final budget = int.tryParse(value);
                                if (budget == null) {
                                  return context.tr.invalidBudget;
                                }
                                if (budget < 1 || budget > 1000000000) {
                                  return context.tr.invalidBudget;
                                }
                                return null;
                              },
                              autoValidationMode: AutovalidateMode.disabled,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${context.tr.minBudget}: 1 ${context.tr.egp} - ${context.tr.maxBudget}: 1,000,000,000 ${context.tr.egp}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Date Input
                      Container(
                        padding: const EdgeInsets.all(16).r,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16).r,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  SolarIconsOutline.calendar,
                                  color: context.colorScheme.primary,
                                  size: 20.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  context.tr.eventDate,
                                  style: context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            DazzifyTextFormField(
                              controller: _dateController,
                              textInputType: TextInputType.none,
                              hintText: context.tr.selectDate,
                              prefixIconData: SolarIconsOutline.calendar,
                              readOnly: true,
                              onTap: _selectDate,
                              validator: null,
                              autoValidationMode: AutovalidateMode.disabled,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Categories Selection
                      Container(
                        padding: const EdgeInsets.all(16).r,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16).r,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  SolarIconsOutline.list,
                                  color: context.colorScheme.primary,
                                  size: 20.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  context.tr.selectCategories,
                                  style: context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state.categoriesState == UiState.loading) {
                            return const DazzifyLoadingShimmer(
                              dazzifyLoadingType: DazzifyLoadingType.custom,
                            );
                          }

                          if (state.categoriesState == UiState.failure) {
                            return ErrorDataWidget(
                              errorDataType: DazzifyErrorDataType.sheet,
                              message: state.errorMessage,
                              onTap: () {
                                context.read<HomeCubit>().getMainCategories();
                              },
                            );
                          }

                          if (state.mainCategories.isEmpty &&
                              state.categoriesState == UiState.success) {
                            return Padding(
                              padding: const EdgeInsets.all(16).r,
                              child: Text(
                                context.tr.noCategories,
                                style: context.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          if (state.mainCategories.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: state.mainCategories.map((category) {
                              final isSelected =
                                  _selectedCategoryIds.contains(category.id);
                              return _CategoryWeightSelector(
                                category: category,
                                isSelected: isSelected,
                                weight: _categoryWeights[category.id] ?? 0,
                                onToggle: () => _toggleCategory(category.id),
                                onWeightChanged: (weight) =>
                                    _updateWeight(category.id, weight),
                              );
                            }).toList(),
                          );
                        },
                      ),
                            if (_selectedCategoryIds.isNotEmpty) ...[
                              SizedBox(height: 16.h),
                              // Container(
                              //   padding: const EdgeInsets.all(12).r,
                              //   decoration: BoxDecoration(
                              //     color: context.colorScheme.primaryContainer
                              //         .withValues(alpha: 0.3),
                              //     borderRadius: BorderRadius.circular(12).r,
                              //   ),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text(
                              //         context.tr.totalWeight,
                              //         style: context.textTheme.titleMedium?.copyWith(
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //       Container(
                              //         padding: const EdgeInsets.symmetric(
                              //           horizontal: 12,
                              //           vertical: 6,
                              //         ).r,
                              //         decoration: BoxDecoration(
                              //           color: _categoryWeights.values
                              //                       .fold(0, (a, b) => a + b) ==
                              //                   100
                              //               ? Colors.green.withValues(alpha: 0.2)
                              //               : Colors.orange.withValues(alpha: 0.2),
                              //           borderRadius: BorderRadius.circular(8).r,
                              //         ),
                              //         child: Text(
                              //           '${_categoryWeights.values.fold(0, (a, b) => a + b)}%',
                              //           style: context.textTheme.titleLarge?.copyWith(
                              //             fontWeight: FontWeight.bold,
                              //             color: _categoryWeights.values
                              //                         .fold(0, (a, b) => a + b) ==
                              //                     100
                              //                 ? Colors.green
                              //                 : Colors.orange,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Generate Button
                      BlocBuilder<BrandRecommendationCubit,
                          BrandRecommendationState>(
                        builder: (context, state) {
                          return PrimaryButton(
                            onTap: state.blocState == UiState.loading
                                ? () {}
                                : _generateRecommendation,
                            title: state.blocState == UiState.loading
                                ? context.tr.loading
                                : context.tr.generateRecommendations,
                            isActive: state.blocState != UiState.loading,
                            isLoading: state.blocState == UiState.loading,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryWeightSelector extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final int weight;
  final VoidCallback onToggle;
  final ValueChanged<int> onWeightChanged;

  const _CategoryWeightSelector({
    required this.category,
    required this.isSelected,
    required this.weight,
    required this.onToggle,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12).r,
      decoration: BoxDecoration(
        color: isSelected
            ? context.colorScheme.primaryContainer.withValues(alpha: 0.2)
            : context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12).r,
        border: Border.all(
          color: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: isSelected,
              onChanged: (_) => onToggle(),
              activeColor: context.colorScheme.primary,
            ),
            title: Text(
              category.name,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
                trailing: isSelected
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ).r,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8).r,
                    ),
                    child: Text(
                      '$weight%',
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : null,
            onTap: onToggle,
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${context.tr.categoryPercentage}:',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$weight%',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Slider(
                    value: weight.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '$weight%',
                    activeColor: context.colorScheme.primary,
                    onChanged: (value) => onWeightChanged(value.toInt()),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

