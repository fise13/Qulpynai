//
//  MainTabView.swift
//  Qulpynai
//
//  Custom tab bar — Home, Menu, Orders, Profile (matches design system)
//

import SwiftUI

private enum Tab: Int, CaseIterable {
    case home, menu, orders, profile

    var title: String {
        switch self {
        case .home: return "Главная"
        case .menu: return "Меню"
        case .orders: return "Заказы"
        case .profile: return "Профиль"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .menu: return "menucard.fill"
        case .orders: return "bag.fill"
        case .profile: return "person.fill"
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    @Environment(CartManager.self) private var cartManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        @Bindable var cart = cartManager
        Group {
            switch selectedTab {
            case Tab.home.rawValue: HomeView()
            case Tab.menu.rawValue: MenuView()
            case Tab.orders.rawValue: OrdersView()
            case Tab.profile.rawValue: ProfileView()
            default: HomeView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CustomTabBar(selectedTab: $selectedTab, colorScheme: colorScheme)
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $cart.isCartPresented) {
            CartView()
        }
        .fullScreenCover(isPresented: $cart.isCheckoutPresented) {
            CheckoutView()
        }
    }
}

private struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let colorScheme: ColorScheme

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                tabButton(tab)
            }
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm)
        .background(DSColors.surface(theme: colorScheme))
        .overlay(
            Rectangle()
                .fill(DSColors.divider(theme: colorScheme))
                .frame(height: 1),
            alignment: .top
        )
    }

    private func tabButton(_ tab: Tab) -> some View {
        let isSelected = selectedTab == tab.rawValue
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab.rawValue
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(size: 22, weight: isSelected ? .bold : .medium))
                Text(tab.title)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(isSelected ? DSColors.secondary(theme: colorScheme) : DSColors.textTertiary(theme: colorScheme))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
