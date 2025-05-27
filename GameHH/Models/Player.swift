import Foundation
import SwiftUI

class Player: ObservableObject {
    var attack: Int
    var protection: Int
    var health: Int
    let maxHealth: Int
    let damageRange: ClosedRange<Int>
    var healCount: Int
    let maxHealCount: Int
    
    @Published var isAttacking = false
    @Published var isHealing = false
    @Published var isMissed = false
    @Published var isHit = false
    
    let playerImage = "player_character"
    let swordImage = "sword"
    
    init(attack: Int, protection: Int, health: Int) {
        guard (1...30).contains(attack) else {
            fatalError("Атака должна быть в диапазоне от 1 до 30")
        }
        guard (1...30).contains(protection) else {
            fatalError("Защита должна быть в диапазоне от 1 до 30")
        }
        guard health > 0 else {
            fatalError("Здоровье должно быть положительным числом")
        }
        
        self.attack = attack
        self.protection = protection
        self.health = health
        self.maxHealth = health
        self.damageRange = 1...6
        self.healCount = 0
        self.maxHealCount = GameConstants.maxHealCount
    }
    
    func attackEnemy(_ target: Monster) -> Int {

        let attackModifier = max(1, attack - target.protection + 1)
        
        for _ in 0..<attackModifier {
            let diceResult = Int.random(in: 1...6)
            if diceResult >= 5 {
                let damage = Int.random(in: damageRange)
                target.health = max(0, target.health - damage)
                return damage
            }
        }
        return 0
    }
    
    func checkHealth() {
        if health <= 0 {
            print("Игрок уничтожен!")
            health = 0
        } else {
            print("Здоровье игрока: \(health)")
        }
    }
    
    func checkStatus() {
        print("Параметры игрока -> Атака: \(attack), Защита: \(protection), Здоровье: \(health)")
    }
    
    func healing() -> Int {
        if healCount < maxHealCount {
            let healAmount = min(GameConstants.healAmount, Int(Double(health) * GameConstants.healPercentage))
            health += healAmount
            healCount += 1
            return healAmount
        }
        return 0
    }
    
    func takeHit() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isHit = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                self.isHit = false
            }
        }
    }
    
    func miss() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isMissed = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                self.isMissed = false
            }
        }
    }
}
