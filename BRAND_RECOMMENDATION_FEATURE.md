# Brand Recommendation Feature Documentation

## نظرة عامة (Overview)

هذه الـ feature تسمح للمستخدمين بالحصول على توصيات للـ brands بناءً على:
- **الميزانية الإجمالية** (Total Budget)
- **التاريخ المطلوب** (Event Date)
- **الفئات المختارة** (Selected Categories) مع **الأوزان** (Weights)

## كيف تعمل الـ Feature (How It Works)

### 1. Input من المستخدم
المستخدم يدخل:
- **totalBudget**: الميزانية الإجمالية (من 1 إلى 1,000,000,000)
- **date**: تاريخ الحدث (صيغة: "YYYY-MM-DD")
- **categories**: مصفوفة من الفئات، كل فئة تحتوي على:
  - `categoryId`: معرف الفئة
  - `weight`: الوزن (يجب أن يكون مجموع الأوزان = 100)

### 2. Algorithm لتوزيع الميزانية (Budget Allocation Algorithm)

#### الخطوات:

**Step 1: Fetch Categories**
- جلب معلومات الفئات المختارة من الـ API

**Step 2: Read recommendationWeight**
- كل فئة لديها `recommendationWeight` (1-100، default: 50)
- يتم جمع هذه القيم للفئات المختارة

**مثال:**
```
User selects 4 categories with points [80, 60, 40, 90]
```

**Step 3: Calculate Total Points**
```
totalPoints = 80 + 60 + 40 + 90 = 270
```

**Step 4: Convert Points to Raw Percentages**
```
For each category: rawPercentage = (points / totalPoints) * 100

[29.629, 22.222, 14.814, 33.333]
```

**Step 5: Floor Each Percentage**
```
Take integer part: [29, 22, 14, 33] → sum = 98
```

**Step 6: Calculate Remainder**
```
remainder = 100 - sum of floored = 100 - 98 = 2
```

**Step 7: Distribute Remainder (Largest Remainder Method)**
- ترتيب الفئات حسب الجزء الكسري (descending)
- إعطاء +1 للفئات الأعلى في الباقي

```
Fractional parts: [0.629, 0.222, 0.814, 0.333]
Sorted: index 2 (0.814), index 0 (0.629), index 3 (0.333), index 1 (0.222)
Give +1 to index 2 and index 0 (remainder = 2)

Final: [30, 22, 15, 33] → sum = 100 ✓
```

### 3. API Response
الـ API يرجع:
- `id`: معرف التوصية
- `totalBudget`: الميزانية الإجمالية
- `date`: التاريخ
- `categories`: مصفوفة من الفئات، كل فئة تحتوي على:
  - `category`: معلومات الفئة (id, name)
  - `weight`: الوزن المخصص
  - `allocatedBudget`: الميزانية المخصصة للفئة
  - `brands`: قائمة الـ brands الموصى بها مع:
    - معلومات الـ brand (id, name, logo, slug)
    - الأسعار (minPrice, maxPrice)
    - التقييم (rating, ratingCount)
    - الحالة (verified, hasAvailability)

## API Endpoint

```
POST {{AppURL}}/brand-recommendation/generate
```

### Request Body:
```json
{
  "totalBudget": 50000,
  "date": "2026-03-15",
  "categories": [
    {
      "categoryId": "67656f70635398a5a831b41b",
      "weight": 40
    },
    {
      "categoryId": "67a36c99e66eaedd76708ae9",
      "weight": 35
    },
    {
      "categoryId": "67656bdd635398a5a831b3c5",
      "weight": 25
    }
  ]
}
```

### Response:
```json
{
  "status": "success",
  "data": {
    "id": "6992f1977ad6698a5456adfc",
    "totalBudget": 50000,
    "date": "2026-03-15T00:00:00.000Z",
    "categories": [
      {
        "category": {
          "id": "67656bdd635398a5a831b3c5",
          "name": "Photographer"
        },
        "weight": 25,
        "allocatedBudget": 12500,
        "brands": [...]
      },
      ...
    ],
    "createdAt": "2026-02-16T10:29:43.062Z"
  }
}
```

## أين يمكن تطبيقها في التطبيق (Where to Implement)

### الخيارات المقترحة:

#### 1. **Home Screen - Button/Feature Card**
- إضافة زر أو بطاقة في الـ Home Screen
- العنوان: "Get Brand Recommendations" أو "احصل على توصيات"
- عند الضغط، ينتقل إلى شاشة إدخال البيانات

#### 2. **New Dedicated Screen: Brand Recommendation Screen**
- شاشة جديدة مخصصة للـ feature
- يمكن الوصول إليها من:
  - Home Screen
  - Bottom Navigation Bar (إذا كان هناك مكان)
  - Menu/Drawer

#### 3. **Category Selection Flow**
- بعد اختيار الفئات من الـ Home Screen
- إضافة خيار "Get Recommendations" في Category Screen
- أو في شاشة متعددة الفئات

### التدفق المقترح (Recommended Flow):

```
Home Screen
    ↓
Brand Recommendation Input Screen
    ├─ Budget Input (TextField with validation)
    ├─ Date Picker (Calendar)
    └─ Category Selection (Multi-select with weight sliders)
    ↓
Brand Recommendation Results Screen
    ├─ Show allocated budget per category
    └─ List of recommended brands per category
    ↓
Brand Profile (when user taps on a brand)
```

## الملفات المطلوبة (Required Files)

### 1. Models
- `lib/features/home/data/models/brand_recommendation_model.dart`
- `lib/features/home/data/models/brand_recommendation_request.dart`

### 2. Data Sources
- `lib/features/home/data/data_sources/remote/home_remote_datasource.dart` (add method)
- `lib/features/home/data/data_sources/remote/home_remote_datasource_impl.dart` (implement)

### 3. Repository
- `lib/features/home/data/repositories/home_repository.dart` (add method)
- `lib/features/home/data/repositories/home_repository_impl.dart` (implement)

### 4. Logic (BLoC/Cubit)
- `lib/features/home/logic/brand_recommendation/brand_recommendation_cubit.dart`
- `lib/features/home/logic/brand_recommendation/brand_recommendation_state.dart`

### 5. Presentation
- `lib/features/home/presentation/screens/brand_recommendation_input_screen.dart`
- `lib/features/home/presentation/screens/brand_recommendation_results_screen.dart`
- `lib/features/home/presentation/widgets/category_weight_selector.dart`
- `lib/features/home/presentation/widgets/budget_input_field.dart`

### 6. API Constants
- `lib/core/constants/api_constants.dart` (add endpoint)

## ملاحظات مهمة (Important Notes)

1. **Validation:**
   - totalBudget: min(1), max(1000000000)
   - date: يجب أن يكون تاريخ صحيح (ليس في الماضي)
   - categories: يجب أن يكون مجموع الأوزان = 100

2. **User Experience:**
   - إضافة loading states
   - إضافة error handling
   - إضافة empty states
   - إضافة pull-to-refresh (إذا لزم الأمر)

3. **Navigation:**
   - إضافة route في `app_router.dart`
   - إضافة deep linking (إذا لزم الأمر)

4. **Analytics:**
   - تتبع استخدام الـ feature
   - تتبع النقرات على الـ brands الموصى بها

