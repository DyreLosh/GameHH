import SwiftUI

struct GameScene: View {
    @ObservedObject var player: Player
    @ObservedObject var monster: Monster
    
    var body: some View {
        ZStack {

            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            HStack(spacing: 50) {

                VStack {
                    ZStack {
                        Image(player.playerImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .offset(x: player.isAttacking ? 20 : 0)
                            .overlay(
                                Image(player.swordImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .offset(x: player.isAttacking ? 40 : 0)
                                    .opacity(player.isAttacking ? 1 : 0)
                            )
                        
                        if player.isHealing {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 30))
                                .offset(y: -50)
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        if player.isMissed {
                            Text("Промах!")
                                .foregroundColor(.red)
                                .font(.title2)
                                .offset(y: -70)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    
                    Text("Игрок")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                VStack {
                    ZStack {
                        Image(monster.monsterImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .offset(x: monster.isAttacking ? -20 : 0)
                        
                        if monster.isHit {
                            Image(systemName: "burst.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 30))
                                .offset(y: -50)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    
                    Text("Монстр")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            }
        }
    }
}
