# TestFlight Deployment Checklist

## Build Configuration

- [ ] Release build succeeds (`xcodebuild -configuration Release`)
- [ ] No DEBUG-only code paths in Release (Logger, AppLogger are `#if DEBUG`)
- [ ] Archive builds without errors

## Security

- [ ] No hardcoded API keys or secrets
- [ ] Token storage uses Keychain (KeychainTokenStore)
- [ ] Environment config uses xcconfig for production URLs

## Payment

- [ ] MockPaymentProcessor used in development
- [ ] Apple Pay: Configure merchant ID in EnvironmentConfig for production
- [ ] Switch to ApplePayPaymentProcessor in AppEnvironment when ready

## App Assets

- [ ] App icon configured (ASSETCATALOG_COMPILER_APPICON_NAME)
- [ ] Launch screen configured (INFOPLIST_KEY_UILaunchScreen_Generation)

## Crash Safety

- [ ] No fatalError in runtime paths (Persistence uses assertionFailure in DEBUG only)
- [ ] CoreData not used in critical app flow (optional)

## Testing

- [ ] Unit tests pass
- [ ] UI tests pass
- [ ] Manual smoke: Auth -> Menu -> Cart -> Checkout -> Orders
