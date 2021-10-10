# How to Persist Sensitive Data Using Keychain in Swift
## 1. Creat a helper class 

```swift
final class KeychainHelper {
    
    static let standard = KeychainHelper()
    private init() {}
    
    // Class implementation here...
}
```

## 2. Add a save function in the class

```swift
func save(_ data: Data, service: String, account: String) {
    
    // Create query
    let query = [
        kSecValueData: data,
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account,
    ] as CFDictionary
    
    // Add data in query to keychain
    let status = SecItemAdd(query, nil)
    
    if status != errSecSuccess {
        // Print out the error
        print("Error: \(status)")
    }
}
```
