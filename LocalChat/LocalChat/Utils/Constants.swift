struct Constants {
    static let keyUsers = "users"
    static let keyChats = "chats"
    static let saveTitle = "Save"
    static let editTitle = "Edit"
    static let backTitle = "Back"
    static let cancelTitle = "Cancel"
    static let namePlaceholder = "Enter new user's name"
    static let maxUser: Int = 100
    
    static func userIsChatting(str: String) -> String {
        return "\(str) is chatting..."
    }
    
    struct chatManagerDictionary {
        static let keyMessage = "message"
        static let keyName = "userName"
        static let keyTime = "sentTime"
    }
    
    struct userManagerDictionary {
        static let keyName = "userName"
        static let keyAvatar = "avatar"
        static let keySeleceted = "selectedForChat"
    }
    
    struct dateFormat {
        static let dateFormatStyle1 = "dd-MM-yyyy 'at' hh:mm a"
        static let dateFormatStyle2 = "HH:mm dd/MM/yyyy"
    }
    
    struct alertMessages {
        static let titleForWarning = "No!"
        static let selectUserMessage = "Select at least 2 and at most 4 users"
        static let titleOk = "OK"
    }
}
