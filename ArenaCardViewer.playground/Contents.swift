//===============================================
//ATB Arena Card Viewer
//1) Просмотрщик карт АТБ Арена:
//   выбираем Героя, прикладываем к нему Артефакт
//   и смотрим как меняются его характеристики
//2) Симулятор боя:
//   выбираем двух Героев, прикладываем Артефаткы
//   (по желанию) и запускаем битву
//===============================================
import UIKit

class CardAtbArena {
    let cardName: String
    let cardNumber: Int
    init(name: String, num: Int) {
        self.cardName = name
        self.cardNumber = num
    }
}

class Hero: CardAtbArena {
    let heClan: String
    let heRank: String
    let heSkill: String
    let defaultDamage: (lowerBound: Int, upperBound: Int)
    let defaultHealth: Int
    let defaultStamina: Int
    let defaultDefence: Int = 0
    let defaultMultyplier: Double = 1
    var heDamage: ClosedRange<Int>
    var heHealth: Int = 0
    var heStamina: Int = 0
    var heDefence: Int = 0
    var multyplier: Double = 1
    var skillIsActive: Bool = false
    init(hname: String, hnum: Int, clan: String, rank: String, skill: String, dam: (Int, Int), health: Int, stam: Int) {
        self.heClan = clan
        self.heRank = rank
        self.heSkill = skill
        self.defaultDamage = dam
        self.defaultHealth = health
        self.defaultStamina = stam
        self.heDamage = dam.0...dam.1
        self.heHealth = health
        self.heStamina = stam
        super.init(name: hname, num: hnum)
    }
    func activateSkill() -> Void {
        self.skillIsActive = true
    }
    func disactivateSkill() -> Void {
        self.skillIsActive = false
    }
    func addPercentDamage(pDamage: Double) -> Void {
        self.heDamage = Int(Double(self.defaultDamage.lowerBound) * pDamage * self.multyplier)...Int(Double(self.defaultDamage.upperBound) * pDamage * self.multyplier)
    }
    func addUnitDamage(uDamage: Double) -> Void{
        self.heDamage = Int(Double(self.defaultDamage.lowerBound + Int(uDamage)) * self.multyplier)...Int(Double(self.defaultDamage.upperBound + Int(uDamage)) * self.multyplier)
    }
    func applyGameMultiplier() -> Void {
        self.heDamage = Int(Double(self.heDamage.lowerBound) * self.multyplier)...Int(Double(self.heDamage.upperBound) * self.multyplier)
    }
    func addPercentHealth(pHealth: Double) -> Void {
        self.heHealth = Int(Double(self.defaultHealth) * pHealth)
    }
    func addUnitHealth(uHealth: Double) -> Void {
        self.heHealth = self.defaultHealth + Int(uHealth)
    }
    func subtractHealth(enemyHit: Int) -> Void {
        self.heHealth = self.heHealth - enemyHit
    }
    func addUnitStamina(uStamina: Double) -> Void {
        self.heStamina = self.defaultStamina + Int(uStamina)
    }
    func addUnitDefence(uDefence: Double) -> Void {
        self.heDefence = self.defaultDefence + Int(uDefence)
    }
    func setMultiplier(enterMultiplier: Double) -> Void {
        self.multyplier = enterMultiplier
        if enterMultiplier == 2 {
            self.activateSkill()
        }
    }
    func setToDefaultProp() -> Void {
        self.heDamage = defaultDamage.lowerBound...defaultDamage.upperBound
        self.heHealth = defaultHealth
        self.heStamina = defaultStamina
        self.heDefence = defaultDefence
    }
    func setToDefaultMultyplier() -> Void {
        if self.multyplier == 2 {
            self.disactivateSkill()
        }
        self.multyplier = defaultMultyplier
    }
    func descriptionHero() {
        print("""
            ===============================
            Ім'я: \(self.cardName)
            -------------------------------
            Раса: \(self.heClan)
            Звання: \(self.heRank)
            Вміння: \(self.heSkill)
            Сила: \(self.heDamage.lowerBound)-\(self.heDamage.upperBound)
            Здоров'я: \(self.heHealth)
            Витривалість: \(self.heStamina)
            Броня: \(self.heDefence)
            Номер картки: \(self.cardNumber)
        """)
    }
}

class Artefact: CardAtbArena {
    var properties: [String: Double]
    init(aname: String, anum: Int, setProp: [String: Double]) {
        self.properties = setProp
        super.init(name: aname, num: anum)
    }
    func applyArtefact(appliedHero: Hero) -> Void {
        for (key, value) in properties {
            switch key {
            case "percentDamage":
                appliedHero.addPercentDamage(pDamage: value)
            case "unitDamage":
                appliedHero.addUnitDamage(uDamage: value)
            case "percentHealth":
                appliedHero.addPercentHealth(pHealth: value)
            case "unitHealth":
                appliedHero.addUnitHealth(uHealth: value)
            case "unitStamina":
                appliedHero.addUnitStamina(uStamina: value)
            case "unitDefence":
                appliedHero.addUnitDefence(uDefence: value)
            default:
                print("Something goes wrong")
            }
        }
    }
    func descriptionArtefact() -> Void {
        print("""
            ==========================
            Назва: \(self.cardName)
            --------------------------
            """)
        for (key, value) in properties {
            switch key {
            case "percentDamage":
                print("Сила атаки: +\(Int(value * 100 - 100))%")
            case "unitDamage":
                print("Сила атаки: +\(Int(value))")
            case "percentHealth":
                print("Регенерація: +\(Int(value * 100 - 100))%")
            case "unitHealth":
                print("Регенерація: +\(Int(value))")
            case "unitStamina":
                print("Витривалість: +\(Int(value))")
            case "unitDefence":
                print("Захист: +\(Int(value))")
            default:
                print("Something goes wrong")
            }
        }
        print("Номер картки: \(self.cardNumber)")
    }
}

class ArenaViewer {
    var cardHero: Hero
    var cardArtefact: Artefact?
    init(hero: Hero, artefact: Artefact) {
        self.cardHero = hero
        self.cardArtefact = artefact
    }
    init(hero: Hero) {
        self.cardHero = hero
    }
    func setHero(chooseHero: Hero) -> Void {
        self.clearStats()
        self.cardHero = chooseHero
    }
    func setArtefact(chooseAretefact: Artefact) -> Void {
        self.clearStats()
        self.removeArtefact()
        self.cardArtefact = chooseAretefact
    }
    func removeArtefact() -> Void {
        self.cardArtefact = nil
    }
    func modifyHero() -> Void {
        self.cardArtefact?.applyArtefact(appliedHero: cardHero)
        self.cardHero.descriptionHero()
    }
    func setGameMultiplier(gameMultiplier: Double) -> Void {
        self.cardHero.setMultiplier(enterMultiplier: gameMultiplier)
    }
    func resetGameMultiplier() -> Void {
        self.cardHero.setToDefaultMultyplier()
    }
    func clearStats() -> Void {
        cardHero.setToDefaultProp()
        cardHero.setToDefaultMultyplier()
    }
    func heroMakeHits(numberOfHits: Int) -> Void {
        var sumHits = 0
        for hit in 1...numberOfHits {
            let currentHit = self.cardHero.heDamage.randomElement()!
            print("Герой \(self.cardHero.cardName) завдає удар #\(hit) із силою - \(currentHit)")
            sumHits += currentHit
        }
        print("Загльна кількість пошкоджень: \(sumHits)")
    }
}

class ArenaSimulator {
    var cardHero1: Hero
    var cardHero2: Hero
    var cardArtefact1: Artefact?
    var cardArtefact2: Artefact?
    init(hero1: Hero, hero2:Hero, artefact1: Artefact, artefact2: Artefact) {
        self.cardHero1 = hero1
        self.cardHero2 = hero2
        self.cardArtefact1 = artefact1
        self.cardArtefact2 = artefact2
    }
    init(hero1: Hero, hero2: Hero) {
        self.cardHero1 = hero1
        self.cardHero2 = hero2
    }
    func setArtefact(chooseArtefact: Artefact, forHero: Int) -> Void {
        self.clearStats(forHero: forHero)
        switch forHero {
        case 1:
            self.cardArtefact1 = chooseArtefact
        case 2:
            self.cardArtefact2 = chooseArtefact
        default:
            print("Unknown Hero. Try again and choose the correct Hero (1 or 2).")
        }
        self.useArtefact(forHero: forHero)
    }
    func removeArtefact(fromHero: Int) -> Void {
        self.clearStats(forHero: fromHero)
        switch fromHero {
        case 1:
            self.cardArtefact1 = nil
        case 2:
            self.cardArtefact2 = nil
        default:
            print("Unknown Hero. Try again and choose the correct Hero (1 or 2).")
        }
    }
    func setHero(chooseHero: Hero, forPlayer: Int) -> Void {
        self.clearStats(forHero: forPlayer)
        switch forPlayer {
        case 1:
            self.cardHero1 = chooseHero
        case 2:
            self.cardHero2 = chooseHero
        default:
            print("Unknown Hero. Try again and choose the correct Hero (1 or 2).")
        }
    }
    func clearStats(forHero: Int) -> Void {
        switch forHero {
        case 1:
            self.cardHero1.setToDefaultProp()
        case 2:
            self.cardHero2.setToDefaultProp()
        default:
            print("Unknown Hero. Try again and choose the correct Hero (1 or 2).")
        }
    }
    func useArtefact(forHero: Int) -> Void {
        switch forHero {
        case 1:
            self.cardArtefact1?.applyArtefact(appliedHero: self.cardHero1)
        case 2:
            self.cardArtefact2?.applyArtefact(appliedHero: self.cardHero2)
        default:
            print("Unknown Hero. Try again and choose the correct Hero (1 or 2).")
        }
    }
    func setGameMultiplier(player1: Double, player2: Double) -> Void {
        self.cardHero1.setMultiplier(enterMultiplier: player1)
        self.cardHero1.applyGameMultiplier()
        self.cardHero2.setMultiplier(enterMultiplier: player2)
        self.cardHero2.applyGameMultiplier()
    }
    func resetGameMultiplier() -> Void {
        self.cardHero1.setToDefaultMultyplier()
        self.cardHero2.setToDefaultMultyplier()
    }
    func startTheRumble() -> Void {
        var counterHits = 1
        var move = 1
        let firstPlayer: Hero, secondPlayer: Hero
        if self.cardHero1.heStamina <= self.cardHero2.heStamina {
            firstPlayer = self.cardHero1
            secondPlayer = self.cardHero2
        } else {
            firstPlayer = self.cardHero2
            secondPlayer = self.cardHero1
        }
        while firstPlayer.heHealth > 0 && secondPlayer.heHealth > 0 {
            if counterHits % 2 != 0 {
                print("Герої завдають удар #\(move)")
                move += 1
                let currentHit = firstPlayer.heDamage.randomElement()!
                secondPlayer.subtractHealth(enemyHit: currentHit)
                print("Здоров'я \(secondPlayer.cardName): \(secondPlayer.heHealth)")
            } else {
                let currentHit = secondPlayer.heDamage.randomElement()!
                firstPlayer.subtractHealth(enemyHit: currentHit)
                print("Здоров'я \(firstPlayer.cardName): \(firstPlayer.heHealth)")
            }
            counterHits += 1
        }
        self.resetGameMultiplier()
    }
}

//HEROS INIT
var otal = Hero(hname: "ОТАЛ", hnum: 1, clan: "ЛИЦАР", rank: "*", skill: "Бойовий натиск", dam: (70, 240), health: 2150, stam: 60)
var teivus = Hero(hname: "ТЕЙВУС", hnum: 2, clan: "ЛИЦАР", rank: "**", skill: "Крижаний панцир", dam: (120, 205), health: 2250, stam: 75)
var magar = Hero(hname: "МАГАР", hnum: 3, clan: "ЛИЦАР", rank: "***", skill: "Техніка 7 самураїв", dam: (120, 210), health: 2350, stam: 80)
var sanctum = Hero(hname: "САНКТУМ", hnum: 4, clan: "ЛИЦАР", rank: "Легенда", skill: "Прихильність долі", dam: (135, 205), health: 2550, stam: 50)
var zorm = Hero(hname: "ЗОРМ", hnum: 5, clan: "МАГ", rank: "*", skill: "Світловий промінь", dam: (95, 270), health: 1800, stam: 60)
var entity = Hero(hname: "СУТНІСТЬ", hnum: 6, clan: "МАГ", rank: "**", skill: "Розкрадач гробниць", dam: (155, 230), health: 1900, stam: 70)
var meilis = Hero(hname: "МЕЙЛІС", hnum: 7, clan: "МАГ", rank: "***", skill: "Зцілення", dam: (150, 235), health: 2000, stam: 75)
var orion = Hero(hname: "ОРІОН", hnum: 8, clan: "МАГ", rank: "Легенда", skill: "Контроль часу", dam: (200, 225), health: 2150, stam: 60)
var panteron = Hero(hname: "ПАНТЕРОН", hnum: 9, clan: "ВАРТОВИЙ", rank: "*", skill: "Нищівний удар", dam: (75, 245), health: 2100, stam: 60)
var ibis = Hero(hname: "ІБІС", hnum: 10, clan: "ВАРТОВИЙ", rank: "**", skill: "Швидкість вітру", dam: (125, 210), health: 2200, stam: 70)
var heming = Hero(hname: "ХЕМІНГ", hnum: 11, clan: "ВАРТОВИЙ", rank: "***", skill: "Жага помсти", dam: (130, 215), health: 2250, stam: 85)
var antikvorum = Hero(hname: "АНТИКВОРУМ", hnum: 12, clan: "ВАРТОВИЙ", rank: "Легенда", skill: "Лють дракона", dam: (155, 215), health: 2400, stam: 60)
var geo = Hero(hname: "ГЕО", hnum: 13, clan: "ДУХ СТИХІЙ", rank: "*", skill: "Сила природи", dam: (40, 210), health: 2650, stam: 70)
var storm = Hero(hname: "ШТОРМ", hnum: 14, clan: "ДУХ СТИХІЙ", rank: "**", skill: "Небесна пастка", dam: (90, 170), health: 2800, stam: 75)
var chaos = Hero(hname: "ХАОС", hnum: 15, clan: "ДУХ СТИХІЙ", rank: "***", skill: "Водяний смерч", dam: (95, 175), health: 2900, stam: 80)
var devastator = Hero(hname: "РУЙНІВНИК", hnum: 16, clan: "ДУХ СТИХІЙ", rank: "Легенда", skill: "Подвійний удар", dam: (120, 170), health: 3050, stam: 50)
var bronestaldIV = Hero(hname: "БРОНЕСТАЛЬД IV", hnum: 17, clan: "МЕХАНІЗМ", rank: "*", skill: "Форсаж", dam: (50, 220), health: 2450, stam: 70)
var firechord = Hero(hname: "ФАЄРХОРД", hnum: 18, clan: "МЕХАНІЗМ", rank: "**", skill: "Вогняне коло", dam: (100, 185), health: 2600, stam: 75)
var rocketAndHover = Hero(hname: "РОКЕТ ТА ХОВЕР", hnum: 19, clan: "МЕХАНІЗМ", rank: "***", skill: "Вибухова суміш", dam: (100, 190), health: 2700, stam: 80)
var teslobara = Hero(hname: "ТЕСЛОБАРА", hnum: 20, clan: "МАХАНІЗМ", rank: "Легенда", skill: "Магнітна броня", dam: (125, 185), health: 2900, stam: 60)
var miriel = Hero(hname: "МІРІЕЛЬ", hnum: 21, clan: "ЕЛЬФ", rank: "*", skill: "Град стріл", dam: (85, 255), health: 1970, stam: 60)
var ladyorain = Hero(hname: "ЛЕДІ О'РЕЙН", hnum: 22, clan: "ЕЛЬФ", rank: "**", skill: "Великий калібр", dam: (130, 210), health: 2100, stam: 70)
var tailon = Hero(hname: "ТАЙЛОН", hnum: 23, clan: "ЕЛЬФ", rank: "***", skill: "Дзеркальний воїн", dam: (135, 220), health: 2200, stam: 80)
var kingnolaran = Hero(hname: "КОРОЛЬ НОЛ'АРАН", hnum: 24, clan: "ЕЛЬФ", rank: "Легенда", skill: "Крилата смерть", dam: (160, 220), health: 2350, stam: 60)
var nemezis = Hero(hname: "НЕМЕЗІС", hnum: 33, clan: "ТИТАН", rank: "Титан", skill: "Забуття", dam: (140, 205), health: 2800, stam: 40)
var k1llBot = Hero(hname: "K1-LL BOT", hnum: 34, clan: "ТИТАН", rank: "Титан", skill: "Армагеддон", dam: (190, 220), health: 2400, stam: 40)
var brut = Hero(hname: "БРУТ", hnum: 35, clan: "ОРК", rank: "*", skill: "Бумеранг", dam: (40, 220), health: 2550, stam: 60)
var higgs = Hero(hname: "ХІГГС", hnum: 36, clan: "ОРК", rank: "**", skill: "Отруйна хмара", dam: (90, 180), health: 2720, stam: 75)
var torn = Hero(hname: "ТОРН", hnum: 37, clan: "ОРК", rank: "***", skill: "Метеор", dam: (95, 185), health: 2800, stam: 80)
var kronus = Hero(hname: "КРОНУС", hnum: 38, clan: "ОРК", rank: "Легенда", skill: "Берсерк", dam: (120, 180), health: 3000, stam: 60)
var zeran = Hero(hname: "ЗЕРАН", hnum: 39, clan: "ДЖИН", rank: "*", skill: "Силовий поштовх", dam: (90, 260), health: 1900, stam: 60)
var nurzul = Hero(hname: "НУРЗУЛ", hnum: 40, clan: "ДЖИН", rank: "**", skill: "Виснаження", dam: (150, 220), health: 2000, stam: 70)
var razalmun = Hero(hname: "РАЗ АЛЬ МУН", hnum: 41, clan: "ДЖИН", rank: "***", skill: "Воскова фігура", dam: (145, 230), health: 2100, stam: 80)
var jafar = Hero(hname: "ДЖАФАР", hnum: 42, clan: "ДЖИН", rank: "Легенда", skill: "Сфери Сили", dam: (190, 215), health: 2250, stam: 60)
var tigron = Hero(hname: "ТИГРОН", hnum: 43, clan: "ЗВІР", rank: "*", skill: "Регенерація", dam: (80, 250), health: 2000, stam: 60)
var dajao = Hero(hname: "ДА ДЖАО", hnum: 44, clan: "ЗВІР", rank: "**", skill: "Запальний феєрверк" , dam: (115, 220), health: 2200, stam: 70)
var vukong = Hero(hname: "ВУКОНГ", hnum: 45, clan: "ЗВІР", rank: "***", skill: "Дуель", dam: (130, 210), health: 2300, stam: 80)
var polarius = Hero(hname: "ПОЛАРІУС", hnum: 46, clan: "ЗВІР", rank: "Легенда", skill: "Гнів лісу", dam: (150, 220), health: 2450, stam: 50)
var turmalin = Hero(hname: "ТУРМАЛІН", hnum: 47, clan: "ЛЕГІОН", rank: "*", skill: "Холодний дотик", dam: (60, 230), health: 2300, stam: 60)
var darkKnight = Hero(hname: "ВЕРШНИК ТЕМРЯВИ", hnum: 48, clan: "ЛЕГІОН", rank: "**", skill: "Тіньовий Удар", dam: (100, 205), health: 2400, stam: 75)
var rous = Hero(hname: "РОУЗ", hnum: 49, clan: "ЛЕГІОН", rank: "***", skill: "Шипи", dam: (100, 215), health: 2500, stam: 80)
var boombot = Hero(hname: "BOOM BOT", hnum: 50, clan: "ЛЕГІОН", rank: "Легенда", skill: "Критичне переванаження", dam: (120, 215), health: 2700, stam: 50)
var marikon = Hero(hname: "МАРІКОН", hnum: 55, clan: "ТИТАН", rank: "Титан", skill: "Аура світла", dam: (170, 210), health: 2650, stam: 40)
var maisterKroks = Hero(hname: "МАЙСТЕР КРОКС", hnum: 56, clan: "ТИТАН", rank: "Титан", skill: "Мисливський інстинкт", dam: (155, 165), health: 3100, stam: 40)
//---------------------------
var maincraft = Hero(hname: "МАЙНКРАФТ", hnum: 99, clan: "ПІКСЕЛЬ", rank: "*****", skill: "Больовий удар", dam: (0, 500), health: 2200, stam: 55)

//ARTEFACTS INIT
var alturConqueror = Artefact(aname: "ПІДКОРЮВАЧ АЛЬТУРУ", anum: 25, setProp: ["unitDamage": 15])
var marikonArmor = Artefact(aname: "ЛАТИ МАРІКОНА", anum: 26, setProp: ["unitDefence" : 45])
var sphereRestoration = Artefact(aname: "СФЕРА ВІДНОВЛЕННЯ", anum: 27, setProp: [:])//требует реализации
var unbrokableShield = Artefact(aname: "ЩИТ НЕЗЛАМНИЙ", anum: 28, setProp: [:])//требует реализации
var berserkBlade = Artefact(aname: "ЛЕЗА БЕРСЕРКА", anum: 29, setProp: [:])//требует реализации
var forestHerbs = Artefact(aname: "ЗІЛЛЯ ЛІСОВИХ ТРАВ", anum: 30, setProp: ["unitStamina": 20])
var sparkDevastation = Artefact(aname: "ІСКРА СПУСТОШЕННЯ", anum: 31, setProp: ["unitDamage": 75])
var amuletOfChamp = Artefact(aname: "АМУЛЕТ ЧЕМПІОНІВ", anum: 32, setProp: [:])//требует реализации
var legacyGrands = Artefact(aname: "СПАДОК ПРАДАВНІХ", anum: 51, setProp: ["percentDamage": 1.1, "percentHealth": 1.06])
var battleAxe = Artefact(aname: "БОЙОВА СОКИРА", anum: 52, setProp: ["percentDamage": 1.17])
var guntlet = Artefact(aname: "РУКАВИЦЯ СИЛИ", anum: 53, setProp: ["percentDamage": 1.08, "percentHealth": 1.06, "unitStamina": 10])
var eaglesEye = Artefact(aname: "ОРЛИНЕ ОКО", anum: 54, setProp: ["percentDamage": 1.3])
 
//START ARENA CARD VIEWER
/*
var mainArena = ArenaViewer(hero: antikvorum)
mainArena.setArtefact(chooseAretefact: alturConqueror)
mainArena.setGameMultiplier(gameMultiplier: 2)
mainArena.modifyHero()
//mainArena.removeArtefact()
//mainArena.clearStats()
mainArena.heroMakeHits(numberOfHits: 5)
*/

//START ARENA SIMULATOR
var mainSimulator = ArenaSimulator(hero1: ibis, hero2: dajao)
//mainSimulator.setArtefact(chooseArtefact: eaglesEye, forHero: 1)
//mainSimulator.setArtefact(chooseArtefact: sparkDevastation, forHero: 2)
mainSimulator.setGameMultiplier(player1: 2, player2: 2)
mainSimulator.startTheRumble()
