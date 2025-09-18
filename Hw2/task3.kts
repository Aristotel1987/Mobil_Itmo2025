import kotlin.math.sqrt

fun main() {
    val ac = 6.0   // катет AC
    val cb = 8.0   // катет CB

    val ab = sqrt(ac * ac + cb * cb) // гипотенуза 
    val area = 0.5 * ac * cb         // площадь
    val perimeter = ab + ac + cb     // периметр

    println("Площадь = ${"%.2f".format(area)}")
    println("Периметр = ${"%.2f".format(perimeter)}")
    println("Гипотенуза = ${"%.2f".format(ab)}")
}