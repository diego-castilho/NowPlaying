import Foundation
import Combine
import AppKit

struct LastFMError: LocalizedError {
    let code: Int
    let message: String
    var errorDescription: String? { "[Last.fm \(code)] \(message)" }
}

@MainActor
final class LastFMClient: ObservableObject {
    @Published var sessionKey: String?
    @Published var username: String?

    private let api = "https://ws.audioscrobbler.com/2.0/"
    private let key = LastFMConfig.apiKey
    private let secret = LastFMConfig.sharedSecret

    init() {
        self.sessionKey = KeychainHelper.shared.get("lastfm_sessionKey")
        self.username   = KeychainHelper.shared.get("lastfm_username")
    }

    func getToken() async throws -> String {
        let base = ["api_key": key, "method": "auth.getToken"]
        var params = base; params["api_sig"] = apiSig(for: base); params["format"] = "json"
        let data = try await post(params)
        let obj = try JSONSerialization.jsonObject(with: data) as! [String:Any]
        guard let token = obj["token"] as? String else { throw LastFMError(code: -1, message: "Token ausente") }
        return token
    }

    func authURL(token: String) -> URL {
        var c = URLComponents(string: "https://www.last.fm/api/auth")!
        c.queryItems = [
            .init(name: "api_key", value: key),
            .init(name: "token", value: token)
        ]
        return c.url!
    }

    func getSession(with token: String) async throws {
        var p = ["api_key": key, "method": "auth.getSession", "token": token]
        p["api_sig"] = apiSig(for: p); p["format"] = "json"
        let data = try await post(p)
        let obj = try JSONSerialization.jsonObject(with: data) as! [String:Any]
        if let ecode = obj["error"] as? Int, let msg = obj["message"] as? String {
            throw LastFMError(code: ecode, message: msg)
        }
        guard let sess = obj["session"] as? [String:Any],
              let sk = sess["key"] as? String,
              let name = sess["name"] as? String else {
            throw LastFMError(code: -2, message: "Sessão inválida")
        }
        self.sessionKey = sk; self.username = name
        KeychainHelper.shared.set(sk, for: "lastfm_sessionKey")
        KeychainHelper.shared.set(name, for: "lastfm_username")
    }

    func signOut() {
        sessionKey = nil; username = nil
        KeychainHelper.shared.remove("lastfm_sessionKey")
        KeychainHelper.shared.remove("lastfm_username")
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
        let obj = try JSONSerialization.jsonObject(with: data) as! [String:Any]
        if let ecode = obj["error"] as? Int, let msg = obj["message"] as? String {
            throw LastFMError(code: ecode, message: msg)
        }
        return ((obj["recenttracks"] as? [String:Any])?["track"] as? [[String:Any]]) ?? []
    }

    func fetchArtworkURL(artist: String, track: String, album: String?) async -> URL? {
        do {
            var p = ["method":"track.getInfo","api_key":key,"format":"json","artist":artist,"track":track]
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
                var p = ["method":"album.getInfo","api_key":key,"format":"json","artist":artist,"album":album]
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
        var req = URLRequest(url: URL(string: api)!)
        req.httpMethod = "POST"
        req.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let allowed = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~")
        let body = params.map { k,v in "\(k)=\((v.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""))" }.joined(separator: "&")
        req.httpBody = body.data(using: .utf8)
        let (data, _) = try await URLSession.shared.data(for: req)
        return data
    }
}
