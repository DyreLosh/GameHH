import Foundation

func castCube(attack: Int, protection: Int) -> Bool {
    let attackModifier = max(attack - protection + 1, 1)
    let rolls = (0..<attackModifier).map { _ in Int.random(in: 1...6) }
    return rolls.contains(5) || rolls.contains(6)
} 
