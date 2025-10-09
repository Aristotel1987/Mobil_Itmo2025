import Foundation

// Создаём и заполняем массив из 100 случайных чисел в диапазоне -500...500
var arr: [Int] = []
arr.reserveCapacity(100)
for _ in 0..<100 {
    arr.append(Int.random(in: -500...500))
}

print("Before:", arr)

func hoarePartition(_ a: inout [Int], low: Int, high: Int) -> Int {
    let pivot = a[(low + high) / 2]    // берем опорный элемент как средний элемент
    var i = low - 1
    var j = high + 1

    while true {
        // сдвигаем i вправо, пока a[i] < pivot
        repeat {
            i += 1
        } while a[i] < pivot

        // сдвигаем j влево, пока a[j] > pivot
        repeat {
            j -= 1
        } while a[j] > pivot

        if i >= j {
            return j                     // возвращаем границу; рекурсия будет на [low..j] и [j+1..high]
        }

        // обмен a[i] и a[j] через временную переменную
        let tmp = a[i]
        a[i] = a[j]
        a[j] = tmp
    }
}

// Quicksort, использующий Hoare partition
func quicksortHoare(_ a: inout [Int], low: Int, high: Int) {
    if low < high {
        let p = hoarePartition(&a, low: low, high: high)
        quicksortHoare(&a, low: low, high: p)      // левая часть включает p
        quicksortHoare(&a, low: p + 1, high: high) // правая часть начинается с p+1
    }
}

// Выполняем сортировку
if arr.count > 1 {
    quicksortHoare(&arr, low: 0, high: arr.count - 1)
}

print("After:", arr)
