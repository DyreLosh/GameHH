import Foundation

struct GameConstants {
    // здоровья
    static let initialPlayerHealth = 100
    static let monsterHealthMultiplier = 2
    
    // атака и защита
    static let minAttackDefense = 1
    static let maxAttackDefense = 20
    
    // кубик
    static let minDiceValue = 1
    static let maxDiceValue = 6
    static let successDiceValue = 5
    static let maxDiceCount = 3
    
    // урон
    static let minDamage = 1
    static let maxDamage = 6
    
    // интерфейса
    static let healthBarWidth: CGFloat = 200
    static let healthBarHeight: CGFloat = 20
    static let actionButtonWidth: CGFloat = 120
    static let battleLogHeight: CGFloat = 150
    
    // значения здоровья для цветов
    static let highHealthThreshold = 0.6
    static let mediumHealthThreshold = 0.3
    
    // отступы и размеры
    static let defaultSpacing: CGFloat = 20
    static let defaultPadding: CGFloat = 10
    static let cornerRadius: CGFloat = 10
    
    // прозрачность
    static let defaultOpacity: Double = 0.1
    
    // атака
    static let attackModifierBase = 1
    static let attackModifierOffset = 1
    
    // лечение
    static let maxHealCount = 4
    static let healAmount = 30
    static let healPercentage = 0.3
}
