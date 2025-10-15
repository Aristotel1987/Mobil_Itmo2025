import Foundation

// Простой генератор id
class IdGenerator {
    static var current = 0
    static func next() -> Int { current += 1; return current }
}

enum Gender { case male, female
    static func random() -> Gender { Bool.random() ? .male : .female }
}
enum Health { case healthy, sick, dead }

// Родительский класс Animal (упрощённый)
class Animal: CustomStringConvertible {
    let id: Int
    var age: Int            // в днях
    var weight: Double
    var name: String
    let gender: Gender
    let isWild: Bool
    let legs: Int
    let motherId: Int?
    let fatherId: Int?
    var health: Health = .healthy
    let species: String
    let adultAge: Int      // возраст, с которого можно размножаться (в днях)

    init(species: String,
         age: Int,
         weight: Double,
         name: String,
         gender: Gender,
         isWild: Bool,
         legs: Int,
         motherId: Int?,
         fatherId: Int?,
         adultAge: Int)
    {
        self.id = IdGenerator.next()
        self.species = species
        self.age = age
        self.weight = weight
        self.name = name
        self.gender = gender
        self.isWild = isWild
        self.legs = legs
        self.motherId = motherId
        self.fatherId = fatherId
        self.adultAge = adultAge
    }

    var description: String {
        return "\(species)#\(id) '\(name)' age:\(age)d w:\(String(format: "%.1f", weight))kg g:\(gender) h:\(health)"
    }

    // Простые действия
    func eat() { guard health != .dead else { return }; weight += Double.random(in: 0.05...0.3) }
    func drink() { /* ничего сложного */ }
    func walk() { guard health != .dead else { return }; weight = max(0.1, weight - Double.random(in: 0.01...0.1)) }

    // Заболеть
    func getSick() {
        guard health == .healthy else { return }
        if Double.random(in: 0...1) < sicknessChance { health = .sick }
    }
    var sicknessChance: Double { return 0.03 } // простой фиксированный шанс

    // Попытка умереть
    func tryDie() {
        guard health != .dead else { return }
        var chance = 0.002
        if health == .sick { chance = 0.15 }
        if age > adultAge * 8 { chance += 0.01 } // старость
        if Double.random(in: 0...1) < chance { health = .dead }
    }

    // Раз в день
    func dayPassed() {
        guard health != .dead else { return }
        age += 1
    }

    // Создать детёныша (переопределять в подклассах)
    func createOffspring(motherId: Int?, fatherId: Int?) -> Animal {
        return Animal(species: species, age: 0, weight: max(0.1, weight * 0.2),
                      name: randomBabyName(), gender: Gender.random(), isWild: isWild,
                      legs: legs, motherId: motherId, fatherId: fatherId, adultAge: adultAge)
    }

    // Размножение: простая проверка и шанс
    func tryReproduce(partner: Animal) -> Animal? {
        guard species == partner.species else { return nil }
        guard gender != partner.gender else { return nil }
        guard health == .healthy && partner.health == .healthy else { return nil }
        guard age >= adultAge && partner.age >= partner.adultAge else { return nil }
if Double.random(in: 0...1) < 0.35 { // шанс успеха
            let mother = (gender == .female) ? self : partner
            let father = (gender == .male) ? self : partner
            return createOffspring(motherId: mother.id, fatherId: father.id)
        }
        return nil
    }

    func randomBabyName() -> String {
        let names = ["Max","Bella","Leo","Luna","Mila","Kira","Tom","Molly","Jack","Nora"]
        return names.randomElement() ?? "Baby"
    }
}

// Подклассы (коротко, переопределяют createOffspring и параметры)
class Dog: Animal {
    init(age:Int=0, weight:Double=5.0, name:String="Dog", gender:Gender=Gender.random(), motherId:Int?=nil, fatherId:Int?=nil) {
        super.init(species:"Dog", age:age, weight:weight, name:name, gender:gender, isWild:false, legs:4, motherId:motherId, fatherId:fatherId, adultAge:365)
    }
    override func createOffspring(motherId: Int?, fatherId: Int?) -> Animal {
        return Dog(age:0, weight:1.0, name: randomBabyName(), gender: Gender.random(), motherId: motherId, fatherId: fatherId)
    }
}

class Cat: Animal {
    init(age:Int=0, weight:Double=3.0, name:String="Cat", gender:Gender=Gender.random(), motherId:Int?=nil, fatherId:Int?=nil) {
        super.init(species:"Cat", age:age, weight:weight, name:name, gender:gender, isWild:false, legs:4, motherId:motherId, fatherId:fatherId, adultAge:300)
    }
    override func createOffspring(motherId: Int?, fatherId: Int?) -> Animal {
        return Cat(age:0, weight:0.5, name: randomBabyName(), gender: Gender.random(), motherId: motherId, fatherId: fatherId)
    }
}

class Bird: Animal {
    init(age:Int=0, weight:Double=0.3, name:String="Bird", gender:Gender=Gender.random(), motherId:Int?=nil, fatherId:Int?=nil) {
        super.init(species:"Bird", age:age, weight:weight, name:name, gender:gender, isWild:false, legs:2, motherId:motherId, fatherId:fatherId, adultAge:120)
    }
    override func createOffspring(motherId: Int?, fatherId: Int?) -> Animal {
        return Bird(age:0, weight:0.05, name: randomBabyName(), gender: Gender.random(), motherId: motherId, fatherId: fatherId)
    }
}

class Bear: Animal {
    init(age:Int=0, weight:Double=80.0, name:String="Bear", gender:Gender=Gender.random(), motherId:Int?=nil, fatherId:Int?=nil) {
        super.init(species:"Bear", age:age, weight:weight, name:name, gender:gender, isWild:true, legs:4, motherId:motherId, fatherId:fatherId, adultAge:365*4)
    }
    override func createOffspring(motherId: Int?, fatherId: Int?) -> Animal {
        return Bear(age:0, weight:4.0, name: randomBabyName(), gender: Gender.random(), motherId: motherId, fatherId: fatherId)
    }
}

class Wolf: Animal {
    init(age:Int=0, weight:Double=40.0, name:String="Wolf", gender:Gender=Gender.random(), motherId:Int?=nil, fatherId:Int?=nil) {
        super.init(species:"Wolf", age:age, weight:weight, name:name, gender:gender, isWild:true, legs:4, motherId:motherId, fatherId:fatherId, adultAge:365*2)
    }
    override func createOffspring(motherId: Int?, fatherId: Int?) -> Animal {
        return Wolf(age:0, weight:3.0, name: randomBabyName(), gender: Gender.random(), motherId: motherId, fatherId: fatherId)
    }
}

// Зоопарк — создаём случайное количество каждого вида и симулируем дни
class Zoo {
    var animals: [Animal] = []

    init() {
        // Для простоты: 1..5 животных каждого вида
        for _ in 0..<(Int.random(in: 1...5)) { animals.append(Dog(age: Int.random(in: 0...1000))) }
        for _ in 0..<(Int.random(in: 1...5)) { animals.append(Cat(age: Int.random(in: 0...1000))) }
        for _ in 0..<(Int.random(in: 1...5)) { animals.append(Bird(age: Int.random(in: 0...800))) }
for _ in 0..<(Int.random(in: 1...3)) { animals.append(Bear(age: Int.random(in: 0...4000))) }
        for _ in 0..<(Int.random(in: 1...4)) { animals.append(Wolf(age: Int.random(in: 0...2000))) }
    }

    func stats() {
        let grouped = Dictionary(grouping: animals, by: { $0.species })
        print("=== Статистика ===")
        for (species, list) in grouped {
            let alive = list.filter { $0.health != .dead }.count
            let total = list.count
            print("\(species): \(alive) живых из \(total)")
        }
    }

    func simulate(days: Int) {
        for day in 1...days {
            print("\n--- День \(day) ---")
            // Действия каждого животного
            for animal in animals {
                if animal.health == .dead { continue }
                if Double.random(in: 0...1) < 0.9 { animal.eat() }
                if Double.random(in: 0...1) < 0.8 { animal.drink() }
                if Double.random(in: 0...1) < 0.7 { animal.walk() }
                animal.getSick()
                animal.tryDie()
                animal.dayPassed()
            }

            // Размножение: для каждого вида собираем здоровых взрослых и делаем пары
            let grouped = Dictionary(grouping: animals.filter { $0.health == .healthy && $0.age >= $0.adultAge }, by: { $0.species })
            for (_, adults) in grouped {
                var males = adults.filter { $0.gender == .male }
                var females = adults.filter { $0.gender == .female }
                while !males.isEmpty && !females.isEmpty {
                    let m = males.remove(at: Int.random(in: 0..<males.count))
                    let f = females.remove(at: Int.random(in: 0..<females.count))
                    if let baby = m.tryReproduce(partner: f) {
                        animals.append(baby)
                        print("Рождение: \(baby.species)#\(baby.id) (родители: \(m.id),\(f.id))")
                    }
                }
            }

            stats()
        }
    }
}

// Запуск
let zoo = Zoo()
print("Зоопарк создан. Начальное число животных: \(zoo.animals.count)")
zoo.stats()
zoo.simulate(days: 10)
