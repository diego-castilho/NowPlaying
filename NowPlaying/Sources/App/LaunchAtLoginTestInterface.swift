import SwiftUI
import AppKit

/// View de exemplo para testar a integração com LaunchAtLoginManager
struct LaunchAtLoginTestInterface: View {
    @ObservedObject private var launchManager = LaunchAtLoginManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Launch at Login - Teste")
                .font(.title2)
                .bold()
            
            HStack {
                Text("Estado atual:")
                    .font(.headline)
                
                Text(launchManager.isEnabled ? "✅ Ativado" : "❌ Desativado")
                    .foregroundStyle(launchManager.isEnabled ? .green : .red)
                    .bold()
            }
            
            Button(action: {
                launchManager.toggle()
            }) {
                Label(
                    launchManager.isEnabled ? "Desativar Launch at Login" : "Ativar Launch at Login",
                    systemImage: launchManager.isEnabled ? "minus.circle" : "plus.circle"
                )
            }
            .buttonStyle(.borderedProminent)
            
            Text("Funciona automaticamente no macOS 13+")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(width: 350)
        .onAppear {
            launchManager.initialize()
        }
    }
}

#Preview {
    LaunchAtLoginTestInterface()
}