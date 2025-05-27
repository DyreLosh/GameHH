import Foundation
import SwiftUI

class Monster: ObservableObject {
    var attack: Int
    var protection: Int
    var health: Int
    let maxHealth: Int
    let damageRange: ClosedRange<Int>
    
    @Published var isAttacking = false
    @Published var isHit = false
    
    let monsterImage: String
    
    init(attack: Int, protection: Int, health: Int) {
        self.attack = attack
        self.protection = protection
        self.health = health
        self.maxHealth = health
        self.damageRange = 1...6
        self.monsterImage = "monster"
    }
    
    func attackEnemy(_ target: Player) -> Int {

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
            print("Монстр уничтожен!")
            health = 0
        } else {
            print("Здоровье монстра: \(health)")
        }
    }
    
    func checkStatus() {
        print("Параметры монстра -> Атака: \(attack), Защита: \(protection), Здоровье: \(health)")
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
}
