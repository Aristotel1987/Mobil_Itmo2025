
fun Calc(first_num: String, second_number: String, operation: String): String {
    val a = first_num.toDoubleOrNull()
    val b = second_number.toDoubleOrNull()

    if (a == null || b == null) {
        return "Ошибка: first_num и second_number должны быть числами."
    }

    val opTrim = operation.trim()
    if (opTrim.length != 1) {
        return "Ошибка: operation должен быть одним символом (+ - * /)."
    }
    val op = opTrim[0]

    val result: Double = if (op == '+') {
        a + b
    } else if (op == '-') {
        a - b
    } else if (op == '*') {
        a * b
    } else if (op == '/') {
        if (b == 0.0) return "Ошибка: деление на ноль."
        a / b
    } else {
        return "Неизвестная операция: '$op'. Допустимые: + - * /"
    }

    return formatNumber(result)
}

private fun formatNumber(x: Double): String {
    if (x.isNaN()) return "NaN"
    if (x.isInfinite()) return if (x > 0) "Infinity" else "-Infinity"
    val asLong = x.toLong()
    return if (x == asLong.toDouble()) "$asLong" else String.format("%.8f", x).trimEnd('0').trimEnd('.')
}

fun main(args: Array<String>) {
    if (args.size == 3) {
        println(Calc(args[0], args[1], args[2]))
    } else {
        println("Использование: <first_num> <second_number> <operation>")
        println("operation: +  -  *  /")
    }
}