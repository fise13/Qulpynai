# TestFlight: UI и дизайн — чеклист улучшений

Документ описывает все необходимые улучшения UI/дизайна и функций для успешного релиза в TestFlight с целью демонстрации возможностей приложения.

---

## 1. Экраны и навигация

### 1.1 Splash / Onboarding
| Что | Как сделать |
|-----|-------------|
| Splash с логотипом | `SplashView` — проверить анимацию появления, длительность ~2 сек |
| Onboarding | `OnboardingView` — слайды с ключевыми функциями (меню, корзина, loyalty) |
| Пропуск онбординга | Кнопка «Пропустить» — `@AppStorage("hasCompletedOnboarding")` |

### 1.2 Главная
| Что | Как сделать |
|-----|-------------|
| Заголовок «Главная» | Крупный, bold, слева или по центру |
| Промо-баннер | Жёлто-янтарный градиент, текст + иконка, tappable |
| «Популярное» | Горизонтальный скролл карточек, тап → ProductDetailView |
| «Повторить заказ» | Показать первые 2–3 позиции последнего заказа, кнопка «Заказать» |
| Кнопка корзины | Текст «Корзина» + иконка, бейдж с количеством |

### 1.3 Меню
| Что | Как сделать |
|-----|-------------|
| Выбор локации | Секция «Магазин» — чипы Downtown, Mall и т.д. |
| Категории | Горизонтальные чипы: All, Pastries, Drinks и т.д. |
| Сетка товаров | 2 колонки, карточки с картинкой/иконкой, ценой |
| Пустые состояния | DSEmptyState при ошибке загрузки |
| Pull-to-refresh | `.refreshable` на ScrollView |

### 1.4 Карточка товара
| Что | Как сделать |
|-----|-------------|
| Изображение/плейсхолдер | AsyncImage или SF Symbol |
| Название, цена | Чёткая типографика |
| Кастомизация (напитки) | Size, milk, add-ons — чипы или пикеры |
| Добавить в корзину | DSButton primary, feedback (успех/анимация) |

### 1.5 Корзина
| Что | Как сделать |
|-----|-------------|
| Список позиций | Карточки: иконка, название, кастомизация, количество, цена |
| Изменение количества | +/- кнопки |
| Итого | Subtotal, discount (если промокод), итог |
| Checkout | Кнопка «Оформить» → CheckoutView |

### 1.6 Checkout
| Что | Как сделать |
|-----|-------------|
| Доставка/самовывоз | Сегментированный выбор |
| Адрес | DSInput, валидация для доставки |
| Промокод | Поле + «Применить», скидка в итоге |
| Итог | Subtotal, Discount, Total |
| Оплата | Заглушка «•••• 4242» или Apple Pay placeholder |
| Place Order | DSButton, loading state, обработка ошибок |

### 1.7 Заказы
| Что | Как сделать |
|-----|-------------|
| Список заказов | Карточки: номер, дата, статус, сумма |
| Детали заказа | OrderDetailView — позиции, статус, адрес |

### 1.8 Профиль
| Что | Как сделать |
|-----|-------------|
| Гость / авторизован | Блок логина или аватар + email |
| Loyalty | NavigationLink → LoyaltyView |
| Настройки | NavigationLink → SettingsView |
| Уведомления | NavigationLink → NotificationsView |
| Помощь | NavigationLink → HelpView |
| Выход | DSButton secondary |

### 1.9 Настройки
| Что | Как сделать |
|-----|-------------|
| Секции-карточки | Уведомления, Внешний вид, О приложении |
| Toggle’ы | Push, обновления заказа, акции, тёмная тема |
| Версия | Строка «1.0.0» |

### 1.10 Loyalty
| Что | Как сделать |
|-----|-------------|
| Баланс очков | Крупное число, «points until next reward» |
| Промо/офферы | DSBanner или карточки |

---

## 2. Дизайн-система

### 2.1 Цвета
| Токен | Light | Dark | Использование |
|-------|-------|------|---------------|
| primary | #1C1917 | #FEF3C7 | Кнопки, заголовки |
| secondary | #D97706 | #FCD34D | Акценты, активные элементы |
| background | #FFFBEB | #0F0D0B | Фон экранов |
| surface | #FFFFFF | #292524 | Карточки, панели |
| textPrimary | #1C1917 | #FAFAF9 | Основной текст |
| textSecondary | #57534E | #A8A29E | Подзаголовки, цена |
| error | #DC2626 | #FCA5A5 | Ошибки |

### 2.2 Типографика
- **Display** — serif, 36pt, bold
- **Headline** — serif, 26pt, semibold
- **Subheadline** — 20pt, semibold
- **Title** — 17pt, semibold
- **Body** — 16pt
- **Caption** — 13pt

### 2.3 Компоненты
- **DSButton** — primary, secondary, tertiary, disabled
- **DSChip** — выбранный/невыбранный
- **DSProductCard** — grid/list
- **DSBanner** — promo/alert
- **DSEmptyState** — иконка, заголовок, subtitle, опциональная кнопка
- **DSLoadingState** — индикатор загрузки
- **DSInput** — текстовое поле с иконкой

### 2.4 Отступы и радиусы
- Spacing: 4, 8, 16, 24, 32, 48 pt
- Corner radius: 8, 12, 16, 24 pt

---

## 3. Состояния и обратная связь

| Состояние | Как показать |
|-----------|--------------|
| Загрузка | DSLoadingState или overlay spinner |
| Ошибка | DSEmptyState или алерт с retry |
| Пусто | DSEmptyState (корзина, заказы, список) |
| Success | Краткий toast/overlay или transition на следующий экран |

---

## 4. Тестовый сценарий для демо

1. **Splash** → 2 сек
2. **Onboarding** (если первый запуск) → Пропустить или пролистать
3. **Главная** → Тап по карточке «Круассан» → ProductDetailView
4. **ProductDetail** → Выбрать size/milk → Add to Cart → Корзина открывается
5. **Корзина** → Изменить количество → Checkout
6. **Checkout** → Выбрать Pickup, ввести адрес (или пропустить), WELCOME10 → Place Order
7. **Order Success** → Кнопка «Готово»
8. **Заказы** → Проверить последний заказ
9. **Профиль** → Settings → Toggle’ы
10. **Профиль** → Loyalty → Баланс очков

---

## 5. Чеклист перед TestFlight

### UI/Дизайн
- [ ] Все экраны читаемы в Light и Dark mode
- [ ] Нет обрезанного текста (lineLimit, truncation)
- [ ] Картинки/иконки везде, где нужны плейсхолдеры
- [ ] Кнопки с достаточной областью нажатия (44×44 pt)
- [ ] Единообразные отступы и выравнивание
- [ ] Корзина показывает количество и открывается по тапу
- [ ] Tab bar: выделен активный таб (цвет/жирность)

### Функции
- [ ] Логин/регистрация (mock) работает
- [ ] Меню загружается, категории фильтруют
- [ ] Добавление в корзину, изменение количества
- [ ] Checkout с промокодом WELCOME10
- [ ] Оформление заказа без падений
- [ ] Список заказов, детали заказа
- [ ] Loyalty баланс
- [ ] Settings: переключатели сохраняются

### Сборка
- [ ] Release build без ошибок
- [ ] Архив проходит
- [ ] Нет DEBUG-логов в Release
- [ ] App icon и Launch Screen настроены

---

## 6. Файлы для правок

| Область | Файлы |
|---------|-------|
| Главная | `Presentation/Features/Home/HomeView.swift` |
| Меню | `Presentation/Features/Menu/MenuView.swift` |
| Товар | `Presentation/Features/Product/ProductDetailView.swift` |
| Корзина | `Presentation/Features/Cart/CartView.swift`, `CartButton.swift` |
| Checkout | `Presentation/Features/Checkout/CheckoutView.swift` |
| Заказы | `Presentation/Features/Orders/OrdersView.swift`, `OrderDetailView.swift` |
| Профиль | `Presentation/Features/Profile/ProfileView.swift` |
| Настройки | `Presentation/Features/Profile/SettingsView.swift` |
| Loyalty | `Presentation/Features/Loyalty/LoyaltyView.swift` |
| Тема | `Core/Theme/Colors.swift`, `Typography.swift`, `Components/*` |
| Таб-бар | `Core/Navigation/MainTabView.swift` |

---

## 7. Референсы

- Тёмная тема, жёлто-золотые акценты
- Карточки с закруглёнными углами
- Кнопка корзины: «Корзина» + иконка, не стандартный iOS-стиль
- Промо-баннер: яркий градиент, белый текст
