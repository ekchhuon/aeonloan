import Foundation

struct Useres: Codable {
    var firstName: String
    var lastName: String
    var lastLogin: Date?
    var contact: Contact?
    struct Contact: Codable{
        var email: String
        var phone: String
    }
}

@propertyWrapper
struct Storage<T: Codable> {
    
    private let key: UserDefaults.Key
    private let defaultValue: T
    
    init(key: UserDefaults.Key, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }
            
            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            
            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key.rawValue)
        }
    }
}

struct Preference {
    @Storage(key: .user, defaultValue: MyUser(firstName: "", lastName: ""))
    static var user:MyUser
    
    @Storage(key: .language, defaultValue: .none)
    static var language: Language
    
    @Storage(key: .enableAutoLogin, defaultValue: false)
    static var enableAutoLogin: Bool
    
    @Storage(key: .hasSeenInstruction, defaultValue: false) var hasSeenInstruction
    
    @Storage(key: .sha256, defaultValue: "")
    static var sha256
    
    static func resetAll() {
        UserDefaults.Key.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
    
    static func reset(forKey key: UserDefaults.Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    static func show(){
        debugPrint(UserDefaults.standard.dictionaryRepresentation())
        let user = Useres(firstName: "", lastName: "", lastLogin: Date(), contact: Useres.Contact(email: "", phone: ""))
        
        user.contact?.email
    }
}


extension UserDefaults {
    enum Key: String, CaseIterable {
        case language
        case hasSeenInstruction
        case enableAutoLogin
        case user
        case sha256
    }
}

struct MyUser: Codable{
    let firstName: String
    let lastName: String
}
