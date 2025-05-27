import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var player: Player
    @Published var monster: Monster
    @Published var battleLog: String = ""
    @Published var gameOver: Bool = false
    @Published var winnerMessage: String = ""
    
    let playerMaxHealth: Int
    let monsterMaxHealth: Int
    
    var canAttack: Bool {
        !gameOver && player.health > 0 && monster.health > 0
    }
    
    var canHeal: Bool {
        !gameOver && player.health > 0 && player.health < playerMaxHealth
    }
    
    init() {
        let initialHealth = GameConstants.initialPlayerHealth
        playerMaxHealth = initialHealth
        monsterMaxHealth = initialHealth * GameConstants.monsterHealthMultiplier
        
        player = Player(
            attack: Int.random(in: GameConstants.minAttackDefense...GameConstants.maxAttackDefense),
            protection: Int.random(in: GameConstants.minAttackDefense...GameConstants.maxAttackDefense),
            health: initialHealth
        )
        monster = Monster(
            attack: Int.random(in: GameConstants.minAttackDefense...GameConstants.maxAttackDefense),
            protection: Int.random(in: GameConstants.minAttackDefense...GameConstants.maxAttackDefense),
            health: monsterMaxHealth
        )
        
        addToLog("Игра началась!")
    }
    
    func attack() {
        // Анимация атаки игрока
        player.isAttacking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.player.isAttacking = false
        }
        
        if castCube(attack: player.attack, protection: monster.protection) {
            let damage = Int.random(in: GameConstants.minDamage...GameConstants.maxDamage)
            monster.health -= damage
            monster.takeHit()
            addToLog("Игрок атакует и наносит \(damage) урона!")
        } else {
            player.miss()
            addToLog("Игрок промахнулся!")
        }
        
        if monster.health > 0 {
            // Анимация атаки монстра
            monster.isAttacking = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.monster.isAttacking = false
            }
            
            if castCube(attack: monster.attack, protection: player.protection) {
                let damage = Int.random(in: GameConstants.minDamage...GameConstants.maxDamage)
                player.health -= damage
                player.takeHit()
                addToLog("Монстр атакует и наносит \(damage) урона!")
            } else {
                addToLog("Монстр промахнулся!")
            }
        }
        
        checkGameOver()
    }
    
    func heal() {
        let healAmount = player.healing()
        if healAmount > 0 {
            player.isHealing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.player.isHealing = false
            }
            addToLog("Игрок восстановил \(healAmount) здоровья")
        } else {
            addToLog("Игрок не может больше лечиться")
        }
    }
    
    private func addToLog(_ message: String) {
        battleLog = message + "\n" + battleLog
    }
    
    private func checkGameOver() {
        if player.health <= 0 {
            gameOver = true
            winnerMessage = "Монстр победил!"
        } else if monster.health <= 0 {
            gameOver = true
            winnerMessage = "Игрок победил!"
        }
    }
    
    func resetGame() {
        player = Player(
            attack: Int.random(in: GameConstants.minAttackDefense...GameConstants.maxAttackDefense),
            protection: Int.random(in: GameConstants.minAttackDefense...GameConstants.maxAttackDefense),
            health: playerMaxHealth
        )
        monster = Monster(
            attack: Int.random(in: GameConstants.minAttackDefense...GameConstants.maxAttackDefense),
            protection: Int.random(in: GameConstants.minAttackDefense...GameConstants.maxAttackDefense),
            health: monsterMaxHealth
        )
        battleLog = "Игра началась заново!"
        gameOver = false
        winnerMessage = ""
    }
    
    private func castCube(attack: Int, protection: Int) -> Bool {
        let attackModifier = max(GameConstants.attackModifierBase, attack - protection + GameConstants.attackModifierOffset)
        let diceCount = min(attackModifier, GameConstants.maxDiceCount)
        
        for _ in 0..<diceCount {
            let diceResult = Int.random(in: GameConstants.minDiceValue...GameConstants.maxDiceValue)
            if diceResult >= GameConstants.successDiceValue {
                return true
            }
        }
        return false
    }
}
