import SwiftUI

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
