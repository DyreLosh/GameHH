import SwiftUI

struct GameView: View {
    @StateObject private var gameViewModel = GameViewModel()
    
    var body: some View {
        VStack(spacing: GameConstants.defaultSpacing) {
            Text("Битва с Монстром")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // игрок
            VStack(alignment: .leading, spacing: GameConstants.defaultSpacing) {
                Text("Игрок")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Атака: \(gameViewModel.player.attack)")
                        Text("Защита: \(gameViewModel.player.protection)")
                        Text("Здоровье: \(gameViewModel.player.health)")
                        Text("Лечения: \(gameViewModel.player.healCount)/\(gameViewModel.player.maxHealCount)")
                            .foregroundColor(gameViewModel.player.healCount < gameViewModel.player.maxHealCount ? .green : .red)
                    }
                    
                    Spacer()
                    
                    HealthBarView(health: gameViewModel.player.health, maxHealth: gameViewModel.playerMaxHealth)
                        .frame(width: GameConstants.healthBarWidth, height: GameConstants.healthBarHeight)
                }
            }
            .padding()
            .background(Color.blue.opacity(GameConstants.defaultOpacity))
            .cornerRadius(GameConstants.cornerRadius)
            
            // монстр
            VStack(alignment: .leading, spacing: GameConstants.defaultSpacing) {
                Text("Монстр")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Атака: \(gameViewModel.monster.attack)")
                        Text("Защита: \(gameViewModel.monster.protection)")
                        Text("Здоровье: \(gameViewModel.monster.health)")
                    }
                    
                    Spacer()
                    
                    HealthBarView(health: gameViewModel.monster.health, maxHealth: gameViewModel.monsterMaxHealth)
                        .frame(width: GameConstants.healthBarWidth, height: GameConstants.healthBarHeight)
                }
            }
            .padding()
            .background(Color.red.opacity(GameConstants.defaultOpacity))
            .cornerRadius(GameConstants.cornerRadius)
            
            // логи
            ScrollView {
                Text(gameViewModel.battleLog)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(GameConstants.defaultOpacity))
                    .cornerRadius(GameConstants.cornerRadius)
            }
            .frame(height: GameConstants.battleLogHeight)
            
            // кнопки 
            HStack(spacing: GameConstants.defaultSpacing) {
                Button(action: {
                    gameViewModel.attack()
                }) {
                    ActionButtonView(title: "Атаковать", color: .red)
                }
                .disabled(!gameViewModel.canAttack)
                
                Button(action: {
                    gameViewModel.heal()
                }) {
                    ActionButtonView(title: "Лечиться", color: .green)
                }
                .disabled(!gameViewModel.canHeal)
                
                Button(action: {
                    gameViewModel.resetGame()
                }) {
                    ActionButtonView(title: "Заново", color: .blue)
                }
            }
            
            if gameViewModel.gameOver {
                VStack {
                    Text(gameViewModel.winnerMessage)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        gameViewModel.resetGame()
                    }) {
                        Text("Начать заново")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(GameConstants.cornerRadius)
                    }
                }
            }
        }
        .padding()
    }
}

struct HealthBarView: View {
    let health: Int
    let maxHealth: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(GameConstants.defaultOpacity)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: min(CGFloat(health) / CGFloat(maxHealth) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(healthColor)
            }
            .cornerRadius(GameConstants.cornerRadius)
        }
    }
    
    private var healthColor: Color {
        let percentage = Double(health) / Double(maxHealth)
        switch percentage {
        case GameConstants.highHealthThreshold...: return .green
        case GameConstants.mediumHealthThreshold..<GameConstants.highHealthThreshold: return .yellow
        default: return .red
        }
    }
}

struct ActionButtonView: View {
    let title: String
    let color: Color
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: GameConstants.actionButtonWidth)
            .background(color)
            .cornerRadius(GameConstants.cornerRadius)
    }
}

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
        if castCube(attack: player.attack, protection: monster.protection) {
            let damage = Int.random(in: GameConstants.minDamage...GameConstants.maxDamage)
            monster.health -= damage
            addToLog("Игрок атакует и наносит \(damage) урона!")
        } else {
            addToLog("Игрок промахнулся!")
        }
        
        if monster.health > 0 {
            if castCube(attack: monster.attack, protection: player.protection) {
                let damage = Int.random(in: GameConstants.minDamage...GameConstants.maxDamage)
                player.health -= damage
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
