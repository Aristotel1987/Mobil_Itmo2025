fun main() {
    val myAge = 38
    val myAgeInTenYears = myAge + 10
    val daysInYear = 365.25
    val daysPassed = myAgeInTenYears * daysInYear

    // Округлим дни до целого для читабельности
    println(
        "Мой возраст $myAge лет. " +
        "Через 10 лет мне будет $myAgeInTenYears лет, " +
        "с момента рождения пройдёт ${"%.0f".format(daysPassed)} дней."
    )
}