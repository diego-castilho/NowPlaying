import Foundation
import Combine

struct LastFMError: LocalizedError {
    let code: Int
    let message: String
    var errorDescription: String? { "[Last.fm \(code)] \(message)" }
}

@MainActor
final class LastFMClient: LastFMClientProtocol {
    @Published var sessionKey: String?
    @Published var username: String?

    private let api = "https://ws.audioscrobbler.com/2.0/"
    private let key = LastFMConfig.apiKey
    private let secret = LastFMConfig.sharedSecret

    init() {
        // Inicialização síncrona - valores carregados lazy
        self.sessionKey = nil
        self.username = nil
        
        // Carregar credenciais de forma assíncrona
        Task { @MainActor in
            await self.loadCredentials()
        }
    }
    
    /// Carrega credenciais do Keychain de forma assíncrona
    private func loadCredentials() async {
        do {
            // Tentar carregar do Keychain moderno
            let session = try await KeychainService.shared.loadLastFMSession()
            let user = try await KeychainService.shared.loadLastFMUsername()
            
            self.sessionKey = session
            self.username = user
            
            print("✅ Credenciais Last.fm carregadas do Keychain")
        } catch KeychainError.itemNotFound {
            // Tentar migrar do formato antigo (KeychainHelper)
            if let oldSession = KeychainHelper.shared.get("lastfm_sessionKey"),
               let oldUsername = KeychainHelper.shared.get("lastfm_username") {
                print("🔄 Migrando credenciais do formato antigo...")
                
                do {
                    try await KeychainService.shared.saveLastFMSession(oldSession)
                    try await KeychainService.shared.saveLastFMUsername(oldUsername)
                    
                    self.sessionKey = oldSession
                    self.username = oldUsername
                    
                    // Remover formato antigo
                    KeychainHelper.shared.remove("lastfm_sessionKey")
                    KeychainHelper.shared.remove("lastfm_username")
                    
                    print("✅ Migração completa")
                } catch {
                    print("❌ Erro na migração: \(error.localizedDescription)")
                }
            } else {
                print("ℹ️ Nenhuma credencial encontrada (usuário não logado)")
            }
        } catch {
            print("❌ Erro ao carregar credenciais: \(error.localizedDescription)")
        }
    }

    func getToken() async throws -> String {
        let base = ["api_key": key, "method": "auth.getToken"]
        var params = base; params["api_sig"] = apiSig(for: base); params["format"] = "json"
        let data = try await post(params)
        let any = try JSONSerialization.jsonObject(with: data)
        guard let obj = any as? [String: Any], let token = obj["token"] as? String else {
            throw LastFMError(code: -1, message: "Token ausente")
        }
        return token
    }

    func authURL(token: String) -> URL {
        var c = URLComponents()
        c.scheme = "https"
        c.host = "www.last.fm"
        c.path = "/api/auth"
        c.queryItems = [
            .init(name: "api_key", value: key),
            .init(name: "token", value: token)
        ]
        // URLComponents always builds a valid URL with the given scheme/host/path; fallback to a known string if needed
        return c.url ?? URL(string: "https://www.last.fm/api/auth?api_key=\(key)&token=\(token)")!
    }

    func getSession(with token: String) async throws {
        var p = ["api_key": key, "method": "auth.getSession", "token": token]
        p["api_sig"] = apiSig(for: p); p["format"] = "json"
        let data = try await post(p)
        let any = try JSONSerialization.jsonObject(with: data)
        guard let obj = any as? [String: Any] else { throw LastFMError(code: -2, message: "Resposta inválida") }
        if let ecode = obj["error"] as? Int, let msg = obj["message"] as? String {
            throw LastFMError(code: ecode, message: msg)
        }
        guard let sess = obj["session"] as? [String: Any],
              let sk = sess["key"] as? String,
              let name = sess["name"] as? String else {
            throw LastFMError(code: -2, message: "Sessão inválida")
        }
        self.sessionKey = sk; self.username = name
        
        // Salvar no Keychain moderno
        do {
            try await KeychainService.shared.saveLastFMSession(sk)
            try await KeychainService.shared.saveLastFMUsername(name)
            print("✅ Credenciais salvas no Keychain")
        } catch {
            print("❌ Erro ao salvar credenciais: \(error.localizedDescription)")
            throw error
        }
    }

    func signOut() {
        sessionKey = nil; username = nil
        
        Task {
            do {
                try await KeychainService.shared.deleteAllLastFMCredentials()
                print("✅ Credenciais removidas do Keychain")
            } catch {
                print("⚠️ Erro ao remover credenciais: \(error.localizedDescription)")
            }
        }
    }

    func updateNowPlaying(artist: String, track: String, album: String?, durationSec: Int?) async throws {
        guard let sk = sessionKey else { return }
        var p = ["method":"track.updateNowPlaying","api_key":key,"sk":sk,"artist":artist,"track":track]
        if let album = album, !album.isEmpty { p["album"] = album }
        if let d = durationSec, d > 0 { p["duration"] = String(d) }
        p["api_sig"] = apiSig(for: p); p["format"] = "json"
        let data = try await post(p)
        if let obj = try? JSONSerialization.jsonObject(with: data) as? [String:Any],
           let ecode = obj["error"] as? Int, let msg = obj["message"] as? String {
            throw LastFMError(code: ecode, message: msg)
        }
    }

    func scrobble(artist: String, track: String, album: String?, timestamp: Int, durationSec: Int?) async throws {
        guard let sk = sessionKey else { return }
        var p = ["method":"track.scrobble","api_key":key,"sk":sk,"artist":artist,"track":track,"timestamp":String(timestamp)]
        if let album = album, !album.isEmpty { p["album"] = album }
        if let d = durationSec, d > 0 { p["duration"] = String(d) }
        p["api_sig"] = apiSig(for: p); p["format"] = "json"
        let data = try await post(p)
        if let obj = try? JSONSerialization.jsonObject(with: data) as? [String:Any],
           let ecode = obj["error"] as? Int, let msg = obj["message"] as? String {
            throw LastFMError(code: ecode, message: msg)
        }
    }

    func fetchRecentTracks(limit: Int = 30) async throws -> [[String:Any]] {
        let name = username ?? ""
        let p = ["method":"user.getRecentTracks","user":name,"api_key":key,"format":"json","limit":String(limit)]
        let data = try await post(p)
        let any = try JSONSerialization.jsonObject(with: data)
        guard let obj = any as? [String: Any] else { throw LastFMError(code: -3, message: "Resposta inválida") }
        if let ecode = obj["error"] as? Int, let msg = obj["message"] as? String {
            throw LastFMError(code: ecode, message: msg)
        }
        return ((obj["recenttracks"] as? [String: Any])?["track"] as? [[String: Any]]) ?? []
    }

    func fetchArtworkURL(artist: String, track: String, album: String?) async -> URL? {
        do {
            let p = ["method":"track.getInfo","api_key":key,"format":"json","artist":artist,"track":track]
            let data = try await post(p)
            if let obj = try JSONSerialization.jsonObject(with: data) as? [String:Any],
               let trackObj = obj["track"] as? [String:Any],
               let images = trackObj["album"] as? [String:Any],
               let arr = images["image"] as? [[String:Any]] {
                if let u = bestImageURL(from: arr) { return u }
            }
        } catch {}
        if let album = album, !album.isEmpty {
            do {
                let p = ["method":"album.getInfo","api_key":key,"format":"json","artist":artist,"album":album]
                let data = try await post(p)
                if let obj = try JSONSerialization.jsonObject(with: data) as? [String:Any],
                   let albumObj = obj["album"] as? [String:Any],
                   let arr = albumObj["image"] as? [[String:Any]] {
                    if let u = bestImageURL(from: arr) { return u }
                }
            } catch {}
        }
        return nil
    }

    private func bestImageURL(from array: [[String:Any]]) -> URL? {
        let preferred = ["extralarge","mega","large","medium"]
        var dict: [String:String] = [:]
        for it in array {
            if let size = it["size"] as? String, let url = it["#text"] as? String, !url.isEmpty {
                dict[size] = url
            }
        }
        for k in preferred {
            if let s = dict[k], let u = URL(string: s) { return u }
        }
        if let last = array.last?["#text"] as? String, let u = URL(string: last) { return u }
        return nil
    }

    private func apiSig(for params: [String:String]) -> String {
        let sorted = params.filter { $0.key != "format" && $0.key != "callback" }.sorted { $0.key < $1.key }
        let base = sorted.map { "\($0.key)\($0.value)" }.joined() + secret
        return md5Hex(base)
    }

    private func post(_ params: [String:String]) async throws -> Data {
        guard var c = URLComponents(string: api) else {
            throw LastFMError(code: -10, message: "URL da API inválida")
        }
        guard let url = c.url else {
            throw LastFMError(code: -10, message: "URL da API inválida")
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let allowed = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~")
        let body = params.map { k, v in "\(k)=\((v.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""))" }.joined(separator: "&")
        req.httpBody = body.data(using: .utf8)
        let (data, _) = try await URLSession.shared.data(for: req)
        return data
    }
}
