import Foundation

// --- Models ---
struct User: Codable {
    let id: Int
    let username: String
    let email: String
    let avatarURL: String?
}

struct Theme: Codable {
    let id: Int
    let name: String
    let backgroundHex: String
    let accentHex: String
    // ... остальные цвета
}

struct CustomEmoji: Codable {
    let id: Int
    let imageURL: String
    let position: String
    let isApproved: Bool
}

// --- Networking ---
class APIClient {
    static let shared = APIClient()
    private let baseURL = UserDefaults.standard.string(forKey: "api_endpoint") ?? "https://api.ttm.local"
    
    func fetchDiagnostics() async throws -> NetworkDiagnostics {
        let url = URL(string: "\(baseURL)/api/v1/diagnostics")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(NetworkDiagnostics.self, from: data)
    }
}

struct NetworkDiagnostics: Codable {
    let apiStatus: String
    let authStatus: String
    let storageStatus: String
    let dbStatus: String
    let latencyMs: Int
    let lastSync: String?
}

// --- Customization Engine Logic ---
class CustomizationService {
    func parseHEX(_ hex: String) -> Color {
        // Реализация конвертации HEX в SwiftUI Color
        return .black
    }
    
    func applyTypingAnimation(text: String, speed: Double) -> String {
        // Анимация печатания (Placeholder)
        return text
    }
}
