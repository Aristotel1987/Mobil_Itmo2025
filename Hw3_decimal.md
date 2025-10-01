# Отчет
# По домашнему заданию № 3 от 26.09.2025

Студент: Выдумкин Илья Александрович
Преподаватель: Васильев Дмитрий Евгениевич
Группа: p4250  
Дата выполнения: 1.10.2025  
дисциплина: Мобильная разработка
Decimal — структурный тип из Foundation для десятичной арифметики с высокой точностью, удобен для финансовых расчётов. Это Swift‑обёртка над платформенным десятичным представлением (NSDecimal / NSDecimalNumber).

Когда использовать
- Для денежных сумм и любых вычислений, где нежелательны двоичные погрешности Float/Double.

Как устроен и ограничения
- Представляется как мантисса × 10^exponent (прибл. до 38 значащих цифр; экспонента ≈ −128…+127). При выходе за пределы точности/диапазона применяется округление или возникает статус ошибки (lossOfPrecision, overflow и т. п.).

Инициализация и литералы (методы и инициализаторы)
- init() — стандартный инициализатор (нулевое значение).
- Инициализация из литералов работает (let a: Decimal = 19.99).
- Инициализация из строк: типично доступен инициализатор/фабрика для парсинга строк (на практике используется Decimal(string: "...") или парсинг через FormatStyle/ParseStrategy для локалезированного ввода).
- Можно создавать Decimal из других числовых типов через соответствующие инициализаторы/инициализацию через NSNumber (мост к NSDecimalNumber).

Арифметика и операторы (методы/функции)
- Операторы +, -, *, / и т. п. предоставлены для Decimal и реализованы поверх низкоуровневых API Foundation (функции NSDecimalAdd, NSDecimalSubtract, NSDecimalMultiply, NSDecimalDivide, NSDecimalMultiplyByPowerOf10, NSDecimalNormalize и т. п.). Эти низкоуровневые функции выполняют арифметику в десятичной модели и возвращают/отражают статусы ошибок (lossOfPrecision, overflow, divideByZero).
- При потенциальной потере точности или переполнении поведение контролируется правилами округления и статусом вычисления (перечисления CalculationError / RoundingMode доступны в связке с NSDecimalNumber).

Форматирование и парсинг (методы/тип‑стили)
- Decimal.FormatStyle — современный стиль форматирования из Swift FormatStyle API. Основные методы:
  - init(locale:) — создать стиль с локалью.
  - grouping() — задать стратегию группировки разрядов.
  - precision() — установить требуемую точность (например, количество дробных знаков).
  - sign(strategy:) — управление отображением знака.
  - decimalSeparator(strategy:) — управление показом десятичного разделителя.
  - rounded(rule:increment:) — задать правило округления и, опционально, шаг инкремента.
  - scale(:) — применить масштабирование перед форматированием.
  - notation(:) — выбрать нотацию (обычная, экспоненциальная и т.п.).
  - format(_ value: Decimal) -> String — получить строку по текущему стилю.
  - locale(:) -> Decimal.FormatStyle — вернуть копию со сменой локали.
- Удобные методы на экземпляре:
  - formatted() -> String — форматирование по умолчанию.
  - formatted<S>( format: S) -> S.FormatOutput — форматирование с вашим FormatStyle.
- Decimal.ParseStrategy<Format> — связывает FormatStyle и парсинг:
  - свойства: formatStyle (сам стиль) и lenient (более терпимый парсинг).
  - служит для преобразования строки в Decimal в соответствии с форматом.
- Для форматирования вывода используйте Decimal.FormatStyle и метод decimal.formatted(myStyle).
- Для локалезированного парсинга применяйте Decimal.ParseStrategy с соответствующим FormatStyle.
- Для точных финансовых вычислений используйте стандартные арифметические операторы; в случаях тонкого контроля над округлением/ошибками обращайтесь к соответствующим функциям NSDecimal* или задавайте правила через FormatStyle.rounded(...) и режимы округления NSDecimalNumber.RoundingMode.
- Обычно не трогайте внутренние поля Decimal (_mantissa, _exponent и т. п.) — пользуйтесь публичными инициализаторами и методами.

## Примеры парсинга: 
1) Простой парсинг из строки (универсально)

import Foundation

if let d = Decimal(string: "1234.56") {
    print("Parsed (simple):", d)   // Decimal(1234.56)
} else {
    print("Invalid number")
}

2) Локализованный парсинг через NumberFormatter (лучше для пользовательского ввода)

import Foundation

let formatter = NumberFormatter()
formatter.locale = Locale(identifier: "ru_RU")
formatter.numberStyle = .decimal

let input = "1 234,56" // в русской локали: пробел как разделитель тысяч и запятая — десятичный разделитель
if let number = formatter.number(from: input) {
    let decimal = number.decimalValue
    print("Parsed (NumberFormatter):", decimal)  // Decimal(1234.56)
} else {
    print("Не удалось распознать число")
}
3) Современный способ: Decimal.FormatStyle + Decimal.ParseStrategy (iOS 15+/macOS 12+)

import Foundation

if #available(iOS 15.0, macOS 12.0, *) {
    let style = Decimal.FormatStyle()
        .precision(.fractionLength(2))
        .grouping(.automatic)
        .locale(Locale(identifier: "ru_RU"))

    let parser = Decimal.ParseStrategy(formatStyle: style, lenient: true)

    do {
        let parsed = try parser.parse("1 234,56")
        print("Parsed (FormatStyle + ParseStrategy):", parsed)
    } catch {
        print("Ошибка парсинга:", error)
    }
} else {
    print("ParseStrategy доступен начиная с iOS 15 / macOS 12")
}

