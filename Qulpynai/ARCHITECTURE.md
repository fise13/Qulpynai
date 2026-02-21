# Qulpynai Architecture

Clean architecture MVP with MVVM, dependency injection, and mock-first approach.

## Structure

```
App/
  AppState.swift          # Global app state
  AppEnvironment.swift    # DI container
  AppConfiguration.swift  # Environment config (feeds EnvironmentConfig)
  Managers/
    AuthManager.swift
    CartManager.swift
    OrderManager.swift

Core/
  Environment/
    EnvironmentConfig.swift  # staging/production, baseURL, feature flags
  DI/
    EnvironmentKeys.swift
  Extensions/
  Logging/
    AppLogger.swift
  Networking/
    APIClient.swift
    MockAPIClient.swift
    RealAPIClient.swift
  Navigation/
  Payment/
  Theme/, Utilities/

Domain/
  Models/                 # Business models
  Entities/               # Rich domain entities
  UseCases/               # Business logic
  Protocols/              # Repository contracts

Data/
  DTOs/
  API/
  Repositories/
  Services/

Presentation/
  Features/
    Auth/, Home/, Menu/, Product/, Cart/, Checkout/, Orders/, Profile/, Loyalty/, Root/
```

## Switching to Real Backend

1. In `AppConfiguration`, set `isMock = false` for staging/production
2. Ensure `apiBaseURL` points to your API
3. `RealAPIClient` will be used automatically
4. Add auth tokens to `RealAPIClient` when needed

## Switching to Real Payment

1. Implement `ApplePayPaymentProcessor` with PKPaymentAuthorizationController
2. In `AppEnvironment`, replace `MockPaymentProcessor` with `ApplePayPaymentProcessor(merchantId: config.applePayMerchantId)`
3. Add backend verification for payment confirmation
4. See `TESTFLIGHT_CHECKLIST.md` for deployment steps

## No Global Singletons

All dependencies are injected via `AppEnvironment` and SwiftUI `.environment()`.
