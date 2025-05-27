import Foundation

struct GameConstants {
    // Параметры здоровья
    static let initialPlayerHealth = 100
    static let monsterHealthMultiplier = 2
    
    // Параметры атаки и защиты
    static let minAttackDefense = 1
    static let maxAttackDefense = 20
    
    // Параметры кубика
    static let minDiceValue = 1
    static let maxDiceValue = 6
    static let successDiceValue = 5
    static let maxDiceCount = 3
    
    // Параметры урона
    static let minDamage = 1
    static let maxDamage = 6
    
    // Параметры интерфейса
    static let healthBarWidth: CGFloat = 200
    static let healthBarHeight: CGFloat = 20
    static let actionButtonWidth: CGFloat = 120
    static let battleLogHeight: CGFloat = 150
    
    // Пороговые значения здоровья для цветов
    static let highHealthThreshold = 0.6
    static let mediumHealthThreshold = 0.3
    
    // Параметры отступов и размеров
    static let defaultSpacing: CGFloat = 20
    static let defaultPadding: CGFloat = 10
    static let cornerRadius: CGFloat = 10
    
    // Параметры прозрачности
    static let defaultOpacity: Double = 0.1
    
    // Параметры атаки
    static let attackModifierBase = 1
    static let attackModifierOffset = 1
    
    // Параметры лечения
    static let maxHealCount = 4
    static let healAmount = 30
    static let healPercentage = 0.3
} 