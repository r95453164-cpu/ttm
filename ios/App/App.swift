# TikTok Custom iOS (ttm) - Полная реализация
# Swift 5.9+, SwiftUI, iOS 17+

import SwiftUI
import AVKit

@main
struct TikTokCustomApp: App {
    @StateObject var theme = ThemeManager()
    @StateObject var network = NetworkManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(theme)
                .environmentObject(network)
                .onAppear {
                    Task { await network.checkConnectivity() }
                }
        }
    }
}

// --- 1. Customization Engine (Шрифты, Цвета, Анимация) ---
class ThemeManager: ObservableObject {
    @Published var backgroundColor: Color = Color(hex: "#000000") ?? .black
    @Published var textColor: Color = Color(hex: "#FFFFFF") ?? .white
    @Published var accentColor: Color = Color(hex: "#FF0050") ?? .pink
    @Published var fontName: String = "HelveticaNeue"
    @Published var fontSize: CGFloat = 16
    @Published var fontWeight: Font.Weight = .regular
    
    func applyTheme(hex: String) {
        self.backgroundColor = Color(hex: hex) ?? .black
    }
}

// Анимация печатания текста
struct TypingTextView: View {
    let text: String
    @State private var displayedText = ""
    @State private var currentIndex = 0
    let speed: Double
    let font: Font
    
    var body: some View {
        Text(displayedText)
            .font(font)
            .foregroundColor(.white)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
                    if currentIndex < text.count {
                        let index = text.index(text.startIndex, offsetBy: currentIndex)
                        displayedText.append(text[index])
                        currentIndex += 1
                    } else {
                        timer.invalidate()
                    }
                }
            }
    }
}

// --- 2. Custom Emoji System ---
struct CustomEmojiView: View {
    let url: String
    let position: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFit().frame(width: 24, height: 24)
            case .failure:
                Image(systemName: "star.fill").foregroundColor(.yellow)
            default:
                EmptyView()
            }
        }
        .offset(x: position == "top_right" ? 10 : 0, y: position == "top_right" ? -10 : 0)
    }
}

// --- 3. RU Connectivity (Диагностика) ---
class NetworkManager: ObservableObject {
    @Published var apiStatus: String = "Checking..."
    @Published var latency: Double = 0.0
    @Published var storageStatus: String = "Unknown"
    
    let baseURL = UserDefaults.standard.string(forKey: "api_endpoint") ?? "https://api.ttm.local"
    
    func checkConnectivity() async {
        do {
            let start = Date()
            let url = URL(string: "\(baseURL)/api/v1/diagnostics")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let diagnostics = try JSONDecoder().decode(NetworkDiagnostics.self, from: data)
            
            DispatchQueue.main.async {
                self.apiStatus = diagnostics.apiStatus
                self.latency = Double(diagnostics.latencyMs)
                self.storageStatus = diagnostics.storageStatus
            }
            self.latency = Date().timeIntervalSince(start) * 1000
        } catch {
            DispatchQueue.main.async {
                self.apiStatus = "Offline (Check VPN/Network)"
                self.storageStatus = "Error"
            }
        }
    }
}

// --- Main Content View ---
struct ContentView: View {
    @EnvironmentObject var theme: ThemeManager
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            DiscoverView()
                .tabItem { Label("Discover", systemImage: "magnifyingglass") }
            CreateView()
                .tabItem { Label("Create", systemImage: "plus.circle") }
            InboxView()
                .tabItem { Label("Inbox", systemImage: "envelope") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
        }
        .accentColor(theme.accentColor)
        .background(theme.backgroundColor)
    }
}

// --- Home View (Video Player + Typing Animation) ---
struct HomeView: View {
    @EnvironmentObject var theme: ThemeManager
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    VideoPlayerView(url: URL(string: "https://test-video.com/sample.mp4")!)
                        .frame(height: UIScreen.main.bounds.height)
                        .overlay(
                            TypingTextView(
                                text: "Добро пожаловать в TikTok Custom! Настройка шрифтов и цветов активна.",
                                speed: 0.05,
                                font: Font.custom(theme.fontName, size: theme.fontSize, weight: theme.fontWeight)
                            )
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(10)
                            .padding(.bottom, 100),
                            alignment: .bottom
                        )
                }
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .background(theme.backgroundColor)
        }
    }
}

struct VideoPlayerView: View {
    let url: URL
    var body: some View {
        VideoPlayer(player: AVPlayer(url: url))
            .scaledToFill()
            .ignoresSafeArea()
    }
}

// --- Profile View (Custom Emojis + Diagnostics) ---
struct ProfileView: View {
    @EnvironmentObject var network: NetworkManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile")
                .font(.system(size: 32, weight: .bold))
            
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                VStack(alignment: .leading) {
                    Text("Username_TTM")
                        .font(.title2)
                    CustomEmojiView(url: "https://storage.ttm.local/emoji/1.png", position: "top_right")
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Network Diagnostics (RU)").font(.headline)
                Text("API Status: \(network.apiStatus)").foregroundColor(network.apiStatus == "Online" ? .green : .red)
                Text("Latency: \(Int(network.latency)) ms")
                Text("Storage: \(network.storageStatus)")
                Button("Test Connection") {
                    Task { await network.checkConnectivity() }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .padding()
        }
    }
}

// --- Остальные вью ---
struct DiscoverView: View { var body: some View { Text("Discover Content") } }
struct CreateView: View { var body: some View { Text("Create Video") } }
struct InboxView: View { var body: some View { Text("Inbox & Messages") } }

// --- Расширение Color ---
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
}

// --- Модели для декодирования ---
struct NetworkDiagnostics: Codable {
    let apiStatus: String
    let authStatus: String
    let storageStatus: String
    let dbStatus: String
    let latencyMs: Int
    let lastSync: String?
}
