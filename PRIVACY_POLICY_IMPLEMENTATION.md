# Privacy Policy Feature Implementation

## Overview
This document describes the complete privacy policy feature that has been implemented to fetch and display privacy policies from the API endpoint `/api/settings/privacy-policies/public`.

## What Was Implemented

### 1. Data Layer

#### Models (`lib/features/settings/data/models/`)
- **privacy_policy_model.dart**: Contains three models:
  - `PrivacyPolicyModel`: Represents a single privacy policy with fields:
    - `id` (mapped from `_id`)
    - `title`
    - `content`
    - `createdAt`
    - `updatedAt`
  - `PrivacyPoliciesDataModel`: Contains the list of policies
  - `PrivacyPoliciesResponseModel`: Wraps the API response with success, statusCode, message, and data

- **privacy_policy_model.g.dart**: Generated JSON serialization code

#### Data Sources (`lib/features/settings/data/data_sources/`)
- **settings_remote_datasource.dart**: Abstract interface
- **settings_remote_datasource_impl.dart**: Implementation that calls the API endpoint

#### Repositories (`lib/features/settings/data/repositories/`)
- **settings_repository.dart**: Abstract repository interface
- **settings_repository_impl.dart**: Implementation with error handling using `Either` type

### 2. Business Logic Layer

#### Cubit (`lib/features/settings/logic/`)
- **privacy_policy_cubit.dart**: Manages privacy policy state
- **privacy_policy_state.dart**: Contains:
  - `loadingState` (initial, loading, success, failure)
  - `policies` (list of privacy policies)
  - `errorMessage` (optional error message)

### 3. Presentation Layer

#### Screens (`lib/features/settings/presentation/screens/`)
- **privacy_policy_screen.dart**: 
  - Implements `AutoRouteWrapper` for dependency injection
  - Displays policies in a scrollable list with cards
  - Shows loading animation while fetching
  - Shows error widget with retry button on failure
  - Shows empty state message when no policies exist
  - Each policy card displays the title and content

### 4. Routing & Navigation

#### Updates Made:
- **app_router.dart**: Added `PrivacyPolicyRoute` to authenticated routes
- **profile_body_component.dart**: Added "Privacy Policy" menu item in "App Settings" section with shield icon

### 5. API Integration

#### Updates Made:
- **api_constants.dart**: Added constant `privacyPolicies = "/settings/privacy-policies/public"`

### 6. Dependency Injection

#### Updates Made:
- **injection.config.dart**: Added registrations for:
  - `SettingsRemoteDatasource`
  - `SettingsRepository`
  - `PrivacyPolicyCubit`

### 7. Localization

#### Added Translations:
- **intl_en.arb**: 
  - `"privacyPolicy": "Privacy Policy"`
  - `"noPrivacyPoliciesAvailable": "No privacy policies available at the moment"`
  
- **intl_ar.arb**: 
  - `"privacyPolicy": "سياسة الخصوصية"`
  - `"noPrivacyPoliciesAvailable": "لا توجد سياسات خصوصية متاحة في الوقت الحالي"`

## How It Works

1. User opens the app and navigates to Profile screen
2. User taps on "Privacy Policy" in the "App Settings" section
3. The app navigates to `PrivacyPolicyScreen`
4. The screen automatically triggers `PrivacyPolicyCubit.getPrivacyPolicies()`
5. The cubit calls the repository, which calls the remote data source
6. The data source makes a GET request to `/settings/privacy-policies/public`
7. The response is parsed into `PrivacyPoliciesResponseModel`
8. The policies are displayed in a scrollable list with cards

## UI Features

- **App Bar**: Shows "Privacy Policy" title with back button
- **Loading State**: Displays a loading animation while fetching data
- **Success State**: Shows policies in cards with:
  - Title in bold with primary color
  - Content with proper line height and text wrapping
- **Error State**: Shows error widget with retry button
- **Empty State**: Shows "No privacy policies available" message
- **RTL Support**: Properly handles Arabic text direction

## API Response Structure

The implementation expects the following response format:

```json
{
  "success": true,
  "statusCode": 200,
  "message": "Privacy Policies retrieved successfully",
  "data": {
    "policies": [
      {
        "_id": "68e1cf8d0379dcd9f98084b2",
        "title": "تيست",
        "content": "تيست",
        "createdAt": "2025-10-05T01:53:17.088Z",
        "updatedAt": "2025-10-05T01:53:17.088Z"
      }
    ]
  }
}
```

## Testing

To test the implementation:

1. Run the app
2. Navigate to Profile tab
3. Scroll down to "App Settings" section
4. Tap on "Privacy Policy"
5. Verify that policies are displayed correctly

## Troubleshooting

If you see a white screen, check:

1. **API Response**: Ensure the API is returning data in the correct format
2. **Network Connection**: Verify the device has internet connectivity
3. **API Endpoint**: Confirm the base URL is correctly configured
4. **Build Runner**: Run `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate files
5. **Dependencies**: Run `flutter pub get` to ensure all packages are installed

## Files Created

```
lib/features/settings/
├── data/
│   ├── data_sources/
│   │   ├── settings_remote_datasource.dart
│   │   └── settings_remote_datasource_impl.dart
│   ├── models/
│   │   ├── privacy_policy_model.dart
│   │   └── privacy_policy_model.g.dart
│   └── repositories/
│       ├── settings_repository.dart
│       └── settings_repository_impl.dart
├── logic/
│   ├── privacy_policy_cubit.dart
│   └── privacy_policy_state.dart
└── presentation/
    └── screens/
        └── privacy_policy_screen.dart
```

## Files Modified

- `lib/core/constants/api_constants.dart`
- `lib/core/injection/injection.config.dart`
- `lib/settings/router/app_router.dart`
- `lib/features/user/presentation/components/profile/profile_body_component.dart`
- `lib/l10n/intl_en.arb`
- `lib/l10n/intl_ar.arb`

## Next Steps

1. Run `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate router files
2. Run `flutter pub get` to ensure dependencies are installed
3. Test the feature on both iOS and Android
4. Test with empty response to verify empty state
5. Test with network error to verify error handling
