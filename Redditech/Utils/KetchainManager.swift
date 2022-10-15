//
//  KetchainManager.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import Foundation

class KeychainManager {
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    static func save(service: String, account: String, data: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: data as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if (status == errSecDuplicateItem) {
            throw KeychainError.duplicateEntry
        }
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    static func get(service: String, account: String) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        return result as? Data
    }
    
    static func delete(service: String, account: String) {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
