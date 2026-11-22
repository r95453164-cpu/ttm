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
}

struct CustomEmoji: Codable {
    let id: Int
    let imageURL: String
    let position: String
    let isApproved: Bool
}

// --- Networking & RU Connectivity ---
class APIClient {
    static let shared = APIClient()
    // Динамический эндпоинт для РФ
    private let baseURL = UserDefaults.standard.string(forKey: "api_endpoint") ?? "https://api.ttm.local"
    
    func fetchDiagnostics() async throws -> NetworkDiagnostics {
        let url = URL(string: "\(baseURL)/api/v1/diagnostics")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5.0 // Быстрая проверка для РФ
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
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
    func parseHEX(_ hex: String) -> Color? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        return Color(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
    
    // Анимация печатания (логика для SwiftUI)
    func generateTypingSequence(text: String, speed: Double) -> [(String, Double)] {
        return text.enumerated().map { (index, char) in
            (String(char), Double(index) * speed)
        }
    }
}
