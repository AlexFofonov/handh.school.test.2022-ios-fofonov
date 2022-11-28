import UIKit

class Creature {
    
    private(set) var attack: Int
    private(set) var shield: Int
    var health: Int
    private let damageRange: [Int]
    public var description: String {
        
        return "Attack: \(attack)\tShield: \(shield)\tHealth: \(health)\tdamageRange: \(String(describing: damageRange.first!)) - \(String(describing: damageRange.last!))"
        
    }
    
    init(attack: Int, shield: Int, health: Int, minDamage: Int, maxDamage: Int) {
        
        if attack > 20 || attack < 1 {
            self.attack = 10
            print("Attack (\(String(attack))) is out of range (1...20), recorded average value")
        } else {
            self.attack = attack
        }
        
        if shield > 20 || shield < 1 {
            self.shield = 10
            print("Shield (\(String(shield))) is out of range (1...20), recorded average value")
        } else {
            self.shield = shield
        }
        
        if health < 1 {
            self.health = 10
            print("Health (\(String(health))) is negative or zero, recorded average value")
        } else {
            self.health = health
        }
        
        if minDamage < 0 || maxDamage < 0 || minDamage > maxDamage {
            self.damageRange = [Int] (1...5)
            print("damageRange (\(String(minDamage)) - \(String(maxDamage))) is incorrect, recorded average range")
        } else {
            self.damageRange = [Int] (minDamage...maxDamage)
        }
        
    }
    
    func getRandomDamage() -> Int {
        
        return damageRange.randomElement()!
        
    }
    
    func takeDamage(_ damage: Int) {
        
        self.health -= damage
        
    }
    
}

class Player: Creature {
    
    private let maxHealth: Int
    private var healerCount: Int = 3
    override public var description: String { return "\(super.description)\tHealer count: \(healerCount)" }
    
    override init(attack: Int, shield: Int, health: Int, minDamage: Int, maxDamage: Int) {
        
        var h = health
        if h < 1 {
            h = 10
            print("Health (\(String(h))) is negative or zero, recorded average value")
        }
        self.maxHealth = h
        
        super.init(attack: attack, shield: shield, health: h, minDamage: minDamage, maxDamage: maxDamage)
        
    }
    
    func useHealer() {
        
        if healerCount == 0 {
            print("! No more healer")
            return
        }
        
        health += maxHealth / 2
        if health > maxHealth {
            health = maxHealth
        }
        
        healerCount -= 1
        
    }
    
}

class Monster: Creature {
    
    override init(attack: Int, shield: Int, health: Int, minDamage: Int, maxDamage: Int) {
        
        super.init(attack: attack, shield: shield, health: health, minDamage: minDamage, maxDamage: maxDamage)
        
    }
    
}

class Game {
    
    private static var monsters = [Monster]()
    private static var player: Player? = nil
    private static let shared = Game()
    static var description: String {
        
        var desc: String = "-> Monsters:\n"
        
        var i = 0
        for monster in monsters {
            desc += "\(i). \(monster.description)\n"
            i += 1
        }
        
        if let p = player {
            desc += "\n-> Player:\n\(p.description )"
        }
        
        return desc
        
    }
    
    private init() {}
    
    static func start() {
        
        if isPlayerEmpty() {
            print("To start create a player")
            return
        }
        
        var round = 1
        while !isPlayerEmpty() && !isMonstersEmpty() {
            print("\nROUND \(round)\n\n\(Game.description)")
            
            if round % 2 == 1 {
                playerTurn()
            } else {
                monstersTurn()
            }
            
            removeDead()
            
            print("\n\(Game.description)")
            round += 1
        }
        
        if isPlayerEmpty() {
            print("\nThe monsters won")
        } else {
            print("\nThe player won")
        }
        
        clear()
        
    }
    
    static func addMonster(_ m: Monster) {
        
        monsters.append(m)
        
    }
    
    static func addPlayer(_ p: Player) {
        
        if player == nil {
            player = p
        } else {
            print("Player already exists")
        }
        
    }
    
    static private func isMonstersEmpty() -> Bool {
        
        if monsters.isEmpty {
            return true
        } else {
            return false
        }
        
    }
    
    static private func isPlayerEmpty() -> Bool {
        
        if player == nil {
            return true
        } else {
            return false
        }
        
    }
    
    static private func playerTurn() {
        
        var randomMonster = monsters.randomElement()
        
        print("\n-> Attacker:\n\(player!.description)\n\n-> Defensive:\n\(randomMonster!.description)")
        fight(attacker: player!, defensive: randomMonster!)
        
    }
    
    static private func monstersTurn() {
        
        var randomMonster = monsters.randomElement()
        
        print("\n-> Attacker:\n\(randomMonster!.description)\n\n-> Defensive:\n\(player!.description)")
        fight(attacker: randomMonster!, defensive: player!)
        
    }
    
    static private func fight(attacker: Creature, defensive: Creature) {
        
        var attackMod: Int
        
        if attacker.attack < defensive.shield {
            attackMod = 1
        } else {
            attackMod = attacker.attack - defensive.shield + 1
        }
        print("\nAttack mod: \(attackMod)")
        
        var isSuccess: Bool = false
        for _ in (1...attackMod) {
            var dice = Int.random(in: 1...6)
            
            print("\nDice: \(dice)")
            if dice == 5 || dice == 6 {
                isSuccess = true
                break
            }
        }
        
        if isSuccess {
            var damage = attacker.getRandomDamage()
            
            defensive.takeDamage(damage)
            print("\nLuck! Damage: \(damage)")
        } else {
            print("\nUnluck! Dodge!")
        }
        
    }
    
    static private func removeDead() {
        
        var i = 0
        for monster in monsters {
            if monster.health < 1 {
                print("Oh, i'm a monster and i'm dead...")
                monsters.remove(at: i)
            }
            i += 1
        }
        
        if player!.health < 1 {
            print("Oh, i'm a player and i'm dead...")
            player = nil
        }
        
    }
    
    static private func clear() {
        
        monsters.removeAll()
        player = nil
        
    }
    
}

var m = Monster(attack: 12, shield: 12, health: 10, minDamage: 8, maxDamage: 10)
var m2 = Monster(attack: 14, shield: 8, health: 20, minDamage: 2, maxDamage: 8)
var p = Player(attack: 10, shield: 100, health: 30, minDamage: 8, maxDamage: 10)

Game.addMonster(m)
Game.addMonster(m2)
Game.addPlayer(p)

Game.start()
