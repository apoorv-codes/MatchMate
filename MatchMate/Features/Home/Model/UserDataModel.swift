//
//  UserDataModel.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/7/24.
//


import Foundation

enum UserAction: String {
    case accepted
    case declined
    case pending
}
// MARK: - UsersDataModel
struct UsersDataModel: Decodable {
    let results: [UserDataModel]?
}

// MARK: - Result
struct UserDataModel: Decodable {
    let gender: String?
    let name: Name?
    let location: Location?
    let email: String?
    let dob, registered: Dob?
    let phone, cell: String?
    let id: UID?
    let picture: Picture?
    let nat: String?
    var action: UserAction = .pending
    
    enum CodingKeys: String, CodingKey {
        case gender, name, location, email, dob, registered, phone, cell, id, picture, nat
    }
}

// MARK: - Dob
struct Dob: Decodable {
    let date: String?
    let age: Int?
}

// MARK: - ID
struct UID: Decodable {
    let name: String?
    var v = UUID().uuidString
    
    init(name: String?, v: String) {
        self.name = name
        self.v = v
    }
}

// MARK: - Location
struct Location: Decodable {
    let street: Street?
    let city, state, country: String?
//    let postcode: Int?
    let coordinates: Coordinates?
    let timezone: Timezone?
}

// MARK: - Coordinates
struct Coordinates: Decodable {
    let latitude, longitude: String?
}

// MARK: - Street
struct Street: Decodable {
    let number: Int?
    let name: String?
}

// MARK: - Timezone
struct Timezone: Decodable {
    let offset, description: String?
}

// MARK: - Name
struct Name: Decodable {
    let title, first, last: String?
}

// MARK: - Picture
struct Picture: Decodable {
    let large, medium, thumbnail: String?
}

extension UserDataModel {
    func toSwiftDataModel() -> UserSwiftDataModel {
        let name = NameSwiftData(title: self.name?.title ?? "",
                                 first: self.name?.first ?? "",
                                 last: self.name?.last ?? "")
        
        let street = StreetSwiftData(number: self.location?.street?.number ?? 0,
                                     name: self.location?.street?.name ?? "")
        
        let coordinates = CoordinatesSwiftData(latitude: self.location?.coordinates?.latitude ?? "",
                                               longitude: self.location?.coordinates?.longitude ?? "")
        
        let timezone = TimezoneSwiftData(offset: self.location?.timezone?.offset ?? "")
        
        let location = LocationSwiftData(street: street,
                                         city: self.location?.city ?? "",
                                         state: self.location?.state ?? "",
                                         country: self.location?.country ?? "",
                                         coordinates: coordinates,
                                         timezone: timezone)
        
        let dob = DobSwiftData(date: self.dob?.date ?? "",
                               age: self.dob?.age ?? 0)
        
        let registered = DobSwiftData(date: self.registered?.date ?? "",
                                      age: self.registered?.age ?? 0)
        
        let id = IDSwiftData(name: self.id?.name ?? "", value: self.id?.v ?? "")
        
        let picture = PictureSwiftData(large: self.picture?.large ?? "",
                                       medium: self.picture?.medium ?? "",
                                       thumbnail: self.picture?.thumbnail ?? "")
        
        // Note: LoginSwiftData is not present in the original UserDataModel
        // You may need to add this information or use placeholder values
        let login = LoginSwiftData(uuid: "", username: "", password: "", salt: "", md5: "", sha1: "", sha256: "")
        
        return UserSwiftDataModel(gender: self.gender ?? "",
                                  name: name,
                                  location: location,
                                  email: self.email ?? "",
                                  login: login,
                                  dob: dob,
                                  registered: registered,
                                  phone: self.phone ?? "",
                                  cell: self.cell ?? "",
                                  id: id,
                                  picture: picture,
                                  nat: self.nat ?? "",
                                  action: self.action.rawValue)
    }
}
