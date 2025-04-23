import Foundation

class CacheService: CacheServiceProtocol {
    private let cacheDuration: TimeInterval = 300
    private let cacheFileName = "accounts_cache"
    
    private var cache: [String: CacheItem] = [:]
    
    private struct CacheItem: Codable {
        let accounts: [AccountModel]
        let timestamp: Date
    }
    
    init() {
        loadCacheFromDisk()
    }
    
    func saveAccounts(_ accounts: [AccountModel], page: Int) {
        let key = cacheKey(for: page)
        let cacheItem = CacheItem(accounts: accounts, timestamp: Date())
        cache[key] = cacheItem
        
        saveCacheToDisk()
    }
    
    func getAccounts(page: Int) -> [AccountModel]? {
        let key = cacheKey(for: page)
        guard let cacheItem = cache[key] else { return nil }
        
        if Date().timeIntervalSince(cacheItem.timestamp) > cacheDuration {
            cache.removeValue(forKey: key)
            saveCacheToDisk()
            return nil
        }
        
        return cacheItem.accounts
    }
    
    func clearCache() {
        cache.removeAll()
        
        do {
            let fileURL = try fileURL()
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch {
            print("Error removing cache file: \(error)")
        }
    }
    
    func cleanExpiredCache() {
        var keysToRemove: [String] = []
        
        for (key, item) in cache {
            if Date().timeIntervalSince(item.timestamp) > cacheDuration {
                keysToRemove.append(key)
            }
        }
        
        for key in keysToRemove {
            cache.removeValue(forKey: key)
        }
        
        if !keysToRemove.isEmpty {
            saveCacheToDisk()
        }
    }
    
    private func cacheKey(for page: Int) -> String {
        return "accounts_page_\(page)"
    }
    
    private func saveCacheToDisk() {
        do {
            let data = try JSONEncoder().encode(cache)
            let fileURL = try fileURL()
            try data.write(to: fileURL)
        } catch {
            print("Error saving cache: \(error)")
        }
    }
    
    private func loadCacheFromDisk() {
        do {
            let fileURL = try fileURL()
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let data = try Data(contentsOf: fileURL)
                cache = try JSONDecoder().decode([String: CacheItem].self, from: data)
                
                cleanExpiredCache()
            }
        } catch {
            print("Error loading cache: \(error)")
        }
    }
    
    private func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: true)
            .appendingPathComponent(cacheFileName)
    }
}
