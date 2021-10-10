# Keychain
## **[Securely store small chunks of data on behalf of the user.](https://developer.apple.com/documentation/security/keychain_services)** 

Computer users often have small secrets that they need to store securely. For example, most people manage numerous online accounts. Remembering a complex, unique password for each is impossible, but writing them down is both insecure and tedious. Users typically respond to this situation by recycling simple passwords across many accounts, which is also insecure.

The keychain services API helps you solve this problem by giving your app a mechanism to store small bits of user data in an encrypted database called a keychain. When you securely remember the password for them, you free the user to choose a complicated one.

The keychain is not limited to passwords, as shown in Figure 1. You can store other secrets that the user explicitly cares about, such as credit card information or even short notes. You can also store items that the user needs but may not be aware of. For example, the cryptographic keys and certificates that you manage with Certificate, Key, and Trust Services enable the user to engage in secure communications and to establish trust with other users and devices. You use the keychain to store these items as well.

# **[How to Persist Sensitive Data Using Keychain in Swift](https://betterprogramming.pub/how-to-persist-sensitive-data-using-keychain-in-swift-142b5769666c)**  
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

### Call a saving function 
```swift 
let accessToken = "dummy-access-token"
let data = Data(accessToken.utf8)
KeychainHelper.standard.save(data, service: "access-token", account: "facebook")
```

### Updating Existing Data in Keychain 
```swift 
func save(_ data: Data, service: String, account: String) {

    // ... ...
    // ... ...
    if status == errSecDuplicateItem {
        // Item already exist, thus update it.
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

        let attributesToUpdate = [kSecValueData: data] as CFDictionary

        // Update existing item
        SecItemUpdate(query, attributesToUpdate)
    }
}
```

## 3. Add a reading function 
```swift 
func read(service: String, account: String) -> Data? {
    
    let query = [
        kSecAttrService: service,
        kSecAttrAccount: account,
        kSecClass: kSecClassGenericPassword,
        kSecReturnData: true
    ] as CFDictionary
    
    var result: AnyObject?
    SecItemCopyMatching(query, &result)
    
    return (result as? Data)
}
```

### Call a reading function 
```swift
let data = KeychainHelper.standard.read(service: "access-token", account: "facebook")!
let accessToken = String(data: data, encoding: .utf8)!
print(accessToken)
```

4. Add a deleting function 
```swift
func delete(service: String, account: String) {
    
    let query = [
        kSecAttrService: service,
        kSecAttrAccount: account,
        kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
    
    // Delete item from keychain
    SecItemDelete(query)
}
```

### Call a deleting function 
```swift
KeychainHelper.standard.delete(service: "access-token", account: "yamamoto")
```
