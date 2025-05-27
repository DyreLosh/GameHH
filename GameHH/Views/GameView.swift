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
