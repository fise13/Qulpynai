//
//  OrdersView.swift
//  Qulpynai
//
//  Orders history — uses OrderManager
//

import SwiftUI

struct OrdersView: View {
    @Environment(CartManager.self) private var cartManager
    @Environment(OrderManager.self) private var orderManager
    @State private var orders: [Order] = []
    @State private var isLoading = false

    @Environment(\.colorScheme) private var colorScheme

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    DSLoadingState()
                } else if orders.isEmpty {
                    DSEmptyState(
                        icon: "bag",
                        title: "No orders yet",
                        subtitle: "Your order history will appear here"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: DSSpacing.md) {
                            ForEach(orders) { order in
                                NavigationLink(value: order) {
                                    orderCard(order)
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(DSSpacing.xl)
                    }
                }
            }
            .background(DSColors.background(theme: colorScheme))
            .navigationTitle("Orders")
            .navigationDestination(for: Order.self) { order in
                OrderDetailView(order: order)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CartButton()
                }
            }
            .task {
                await loadOrders()
            }
            .refreshable {
                await loadOrders()
            }
        }
    }

    private func loadOrders() async {
        isLoading = true
        do {
            let result = try await orderManager.fetchOrderHistory()
            await MainActor.run {
                orders = result
            }
        } catch {
            await MainActor.run {
                orders = []
            }
        }
        isLoading = false
    }

    private func orderCard(_ order: Order) -> some View {
        DSCard(elevated: false) {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                HStack {
                    Text("Order \(order.orderNumber)")
                        .font(DSTypography.title)
                        .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                    Spacer()
                    Text(statusText(order.status))
                        .font(DSTypography.captionSmall)
                        .foregroundStyle(DSColors.surface)
                        .padding(.horizontal, DSSpacing.sm)
                        .padding(.vertical, DSSpacing.xs)
                        .background(DSColors.success(theme: colorScheme))
                        .clipShape(Capsule())
                }
                Text(dateFormatter.string(from: order.date))
                    .font(DSTypography.caption)
                    .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                Text(order.totalFormatted)
                    .font(DSTypography.body)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
            }
        }
    }

    private func statusText(_ status: Order.OrderStatus) -> String {
        switch status {
        case .pending: return String(localized: "status_pending")
        case .confirmed: return String(localized: "status_confirmed")
        case .preparing: return String(localized: "status_preparing")
        case .ready: return String(localized: "status_ready")
        case .delivered: return String(localized: "status_delivered")
        case .failed: return "Failed"
        }
    }
}
