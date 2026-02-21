//
//  AppEnvironment.swift
//  Qulpynai
//
//  Dependency Injection container — no global singletons
//

import Foundation

/// DI container exposing APIClient, repositories, use cases, PaymentProcessor, and managers.
final class AppEnvironment {
    let config: EnvironmentConfig

    // State
    let appState: AppState
    let authManager: AuthManager
    let cartManager: CartManager
    let orderManager: OrderManager
    let loyaltyManager: LoyaltyManager
    let globalUXState: GlobalUXState

    // UseCases
    let loginUseCase: LoginUseCase
    let fetchMenuUseCase: FetchMenuUseCase
    let addToCartUseCase: AddToCartUseCase
    let removeFromCartUseCase: RemoveFromCartUseCase
    let createOrderUseCase: CreateOrderUseCase
    let fetchOrdersUseCase: FetchOrdersUseCase
    let calculateCartTotalUseCase: CalculateCartTotalUseCase
    let fetchLoyaltyBalanceUseCase: FetchLoyaltyBalanceUseCase
    let registerUseCase: RegisterUseCase
    let fetchLocationsUseCase: FetchLocationsUseCase
    let updateCartItemUseCase: UpdateCartItemUseCase
    let processPaymentUseCase: ProcessPaymentUseCase
    let applyPromotionUseCase: ApplyPromotionUseCase

    // Factories (swappable via config)
    let apiClient: APIClient
    let paymentProcessor: PaymentProcessor

    init(configuration: AppConfiguration = .current) {
        self.config = configuration.config
        let appState = AppState()

        let tokenStore = KeychainTokenStore()
        apiClient = config.isMock
            ? MockAPIClient(delay: config.mockDelay)
            : RealAPIClient(baseURL: config.baseURL, tokenStore: tokenStore)

        let menuRepository = MenuRepositoryImpl(apiClient: apiClient)
        let authRepository = AuthRepositoryImpl(apiClient: apiClient)
        let orderRepository = OrderRepositoryImpl(apiClient: apiClient)
        let loyaltyRepository = LoyaltyRepositoryImpl(apiClient: apiClient)
        let locationRepository = LocationRepositoryImpl(apiClient: apiClient)
        let promotionRepository = PromotionRepositoryImpl()

        paymentProcessor = MockPaymentProcessor(delay: config.mockDelay)

        let cartManager = CartManager()
        let loyaltyManager = LoyaltyManager(loyaltyRepository: loyaltyRepository)
        let globalUXState = GlobalUXState()

        let orderManager = OrderManager(
            orderRepository: orderRepository,
            paymentProcessor: paymentProcessor,
            loyaltyRepository: loyaltyRepository
        )
        let authManager = AuthManager(
            authRepository: authRepository,
            appState: appState,
            tokenStore: tokenStore
        )
        orderManager.inject(appState: appState, cartManager: cartManager)
        loyaltyManager.inject(appState: appState)
        authManager.restoreSession()

        self.appState = appState
        self.loyaltyManager = loyaltyManager
        self.globalUXState = globalUXState
        self.authManager = authManager
        self.cartManager = cartManager
        self.orderManager = orderManager

        loginUseCase = LoginUseCase(authRepository: authRepository)
        fetchMenuUseCase = FetchMenuUseCase(menuRepository: menuRepository)
        addToCartUseCase = AddToCartUseCase(cartManager: cartManager)
        removeFromCartUseCase = RemoveFromCartUseCase(cartManager: cartManager)
        createOrderUseCase = CreateOrderUseCase(
            orderManager: orderManager,
            cartManager: cartManager
        )
        fetchOrdersUseCase = FetchOrdersUseCase(orderRepository: orderRepository)
        calculateCartTotalUseCase = CalculateCartTotalUseCase(cartManager: cartManager)
        fetchLoyaltyBalanceUseCase = FetchLoyaltyBalanceUseCase(loyaltyRepository: loyaltyRepository)
        registerUseCase = RegisterUseCase(authRepository: authRepository)
        fetchLocationsUseCase = FetchLocationsUseCase(locationRepository: locationRepository)
        updateCartItemUseCase = UpdateCartItemUseCase(cartManager: cartManager)
        processPaymentUseCase = ProcessPaymentUseCase(paymentProcessor: paymentProcessor)
        applyPromotionUseCase = ApplyPromotionUseCase(promotionRepository: promotionRepository)
    }
}
