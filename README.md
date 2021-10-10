# Keychain

# How to Persist Sensitive Data Using Keychain in Swift
**[How to Persist Sensitive Data Using Keychain in Swift](https://betterprogramming.pub/how-to-persist-sensitive-data-using-keychain-in-swift-142b5769666c)**  
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
kSecValueData:
> A key that represents the data being saved to the keychain.

kSecClass: 
> A key that represents the type of data being saved. Here we set its value as kSecClassGenericPassword indicating that the data we are saving is a generic password item.

kSecAttrService and kSecAttrAccount: 
> These 2 keys are mandatory when kSecClass is set to kSecClassGenericPassword. The values for both of these keys will act as the primary key for the data being saved. In other words, we will use them to retrieve the saved data from the keychain later on.
