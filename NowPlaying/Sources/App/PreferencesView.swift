import SwiftUI

import SwiftUI

/// View de preferências/configurações do aplicativo
struct PreferencesView: View {
    @ObservedObject private var launchManager = LaunchAtLoginManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Image(systemName: "gear")
                    .font(.title2)
                    .foregroundStyle(.blue)
                Text("Preferências")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.bottom, 10)
            
            Divider()
            
            // Configurações gerais
            VStack(alignment: .leading, spacing: 15) {
                Text("Configurações Gerais")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                GroupBox {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Iniciar no login")
                                .font(.body)
                                .bold()
                            Text("O aplicativo será iniciado automaticamente quando você fizer login no macOS")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $launchManager.isEnabled)
                            .toggleStyle(.switch)
                    }
                    .padding(.vertical, 8)
                }
            }
            
            Spacer()
            
            // Informações adicionais
            GroupBox {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.blue)
                        Text("Informações")
                            .font(.headline)
                    }
                    
                    Text("• O aplicativo será executado em segundo plano na barra de menu")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("• Você pode fechá-lo a qualquer momento usando a opção 'Sair' no menu")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("• Funciona automaticamente no macOS 13+ (Ventura e posteriores)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("• No macOS 12 e anteriores, configure manualmente nas Preferências do Sistema")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .italic()
                }
            }
        }
        .padding(20)
        .frame(width: 450, height: 350)
        .onAppear {
            launchManager.initialize()
        }
    }
}

#Preview {
    PreferencesView()
}