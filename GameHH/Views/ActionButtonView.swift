import SwiftUI

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
