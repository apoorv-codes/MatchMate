//
//  UserCoreDataModel.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/8/24.
//
import SwiftData
import Foundation

// MARK: - Result
@Model
class UserSwiftDataModel {
    var gender: String
    var name: NameSwiftData
    var location: LocationSwiftData
    var email: String
    var login: LoginSwiftData
    var dob: DobSwiftData
    var registered: DobSwiftData
    var phone: String
    var cell: String
    var id: IDSwiftData
    var picture: PictureSwiftData
    var nat: String
    var action: String = UserAction.pending.rawValue

    init(gender: String, name: NameSwiftData, location: LocationSwiftData, email: String, login: LoginSwiftData, dob: DobSwiftData, registered: DobSwiftData, phone: String, cell: String, id: IDSwiftData, picture: PictureSwiftData, nat: String, action: String) {
        self.gender = gender
        self.name = name
        self.location = location
        self.email = email
        self.login = login
        self.dob = dob
        self.registered = registered
        self.phone = phone
        self.cell = cell
        self.id = id
        self.picture = picture
        self.nat = nat
        self.action = action
    }
}

// MARK: - Dob
@Model
class DobSwiftData {
    var date: String
    var age: Int

    init(date: String, age: Int) {
        self.date = date
        self.age = age
    }
}

// MARK: - IDSwiftData
@Model
class IDSwiftData {
    var name: String
    var value: String

    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

// MARK: - Location
@Model
class LocationSwiftData {
    var street: StreetSwiftData
    var city: String
    var state: String
    var country: String
    var coordinates: CoordinatesSwiftData
    var timezone: TimezoneSwiftData

    init(street: StreetSwiftData, city: String, state: String, country: String, coordinates: CoordinatesSwiftData, timezone: TimezoneSwiftData) {
        self.street = street
        self.city = city
        self.state = state
        self.country = country
        self.coordinates = coordinates
        self.timezone = timezone
    }
}

// MARK: - Coordinates
@Model
class CoordinatesSwiftData {
    var latitude: String
    var longitude: String

    init(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: - Street
@Model
class StreetSwiftData {
    var number: Int
    var name: String

    init(number: Int, name: String) {
        self.number = number
        self.name = name
    }
}

// MARK: - Timezone
@Model
class TimezoneSwiftData {
    var offset: String

    init(offset: String) {
        self.offset = offset
    }
}

// MARK: - Login
@Model
class LoginSwiftData {
    var uuid: String
    var username: String
    var password: String
    var salt: String
    var md5: String
    var sha1: String
    var sha256: String

    init(uuid: String, username: String, password: String, salt: String, md5: String, sha1: String, sha256: String) {
        self.uuid = uuid
        self.username = username
        self.password = password
        self.salt = salt
        self.md5 = md5
        self.sha1 = sha1
        self.sha256 = sha256
    }
}

// MARK: - Name
@Model
class NameSwiftData {
    var title: String
    var first: String
    var last: String

    init(title: String, first: String, last: String) {
        self.title = title
        self.first = first
        self.last = last
    }
}

// MARK: - Picture
@Model
class PictureSwiftData {
    var large: String
    var medium: String
    var thumbnail: String

    init(large: String, medium: String, thumbnail: String) {
        self.large = large
        self.medium = medium
        self.thumbnail = thumbnail
    }
}

extension UserSwiftDataModel {
    func toDataModel() -> UserDataModel {
        let name = Name(title: self.name.title,
                        first: self.name.first,
                        last: self.name.last)
        
        let street = Street(number: self.location.street.number,
                            name: self.location.street.name)
        
        let coordinates = Coordinates(latitude: self.location.coordinates.latitude,
                                      longitude: self.location.coordinates.longitude)
        
        let timezone = Timezone(offset: self.location.timezone.offset,
                                description: "") // Note: description is missing in SwiftDataModel
        
        let location = Location(street: street,
                                city: self.location.city,
                                state: self.location.state,
                                country: self.location.country,
                                coordinates: coordinates,
                                timezone: timezone)
        
        let dob = Dob(date: self.dob.date,
                      age: self.dob.age)
        
        let registered = Dob(date: self.registered.date,
                             age: self.registered.age)
       
        let uid = UID(name: self.id.name, v: self.id.value)
        
        let picture = Picture(large: self.picture.large,
                              medium: self.picture.medium,
                              thumbnail: self.picture.thumbnail)
        
        var userDataModel = UserDataModel(gender: self.gender,
                                          name: name,
                                          location: location,
                                          email: self.email,
                                          dob: dob,
                                          registered: registered,
                                          phone: self.phone,
                                          cell: self.cell,
                                          id: uid,
                                          picture: picture,
                                          nat: self.nat)
        
        userDataModel.action = UserAction(rawValue: self.action) ?? .pending
        
        return userDataModel
    }
}
