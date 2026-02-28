//
//  DecodableTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 10/14/24.
//

import Foundation
import Testing


// https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types

struct DecodableTests {

    @Test func testDecodingSimple() throws {
        let data = """
        {
            "id": 1,
            "name": "John Doe",
            "email": "john.doe@example.com"
        }
        """.data(using: .utf8)!

        struct User: Decodable {
            let id: Int
            let name: String
            let email: String
        }

        let user = try! JSONDecoder().decode(User.self, from: data)

        #expect(user.id == 1)
        #expect(user.name == "John Doe")
        #expect(user.email == "john.doe@example.com")
    }

    @Test func testDecodingNested() throws {
        let data = """
        {
            "id": 1,
            "name": "John Doe",
            "address": {
                "street": "123 Main St",
                "city": "New York",
                "zipcode": "10001"
            }
        }
        """.data(using: .utf8)!

        struct User: Decodable {
            let id: Int
            let name: String
            let address: Address
        }

        struct Address: Decodable {
            let street: String
            let city: String
            let zipcode: String
        }

        let user = try! JSONDecoder().decode(User.self, from: data)

        #expect(user.id == 1)
        #expect(user.name == "John Doe")
        #expect(user.address.street == "123 Main St")
        #expect(user.address.city == "New York")
        #expect(user.address.zipcode == "10001")
    }

    @Test func testDecodingArray() throws {
        let data = """
        [
            {
                "id": 1,
                "name": "John Doe",
                "email": "john.doe@example.com"
            },
            {
                "id": 2,
                "name": "Jane Smith",
                "email": "jane.smith@example.com"
            }
        ]
        """.data(using: .utf8)!

        struct User: Decodable {
            let id: Int
            let name: String
            let email: String
        }

        let users = try! JSONDecoder().decode([User].self, from: data)

        #expect(users.count == 2)

        do {
            let user = users[0]
            #expect(user.id == 1)
            #expect(user.name == "John Doe")
            #expect(user.email == "john.doe@example.com")
        }

        do {
            let user = users[1]
            #expect(user.id == 2)
            #expect(user.name == "Jane Smith")
        }
    }

    @Test func testDecodingWithCodingKeys() throws {
        let data = """
        {
            "_id": 1,
            "_name": "John Doe",
            "_email": "john.doe@example.com"
        }
        """.data(using: .utf8)!

        struct User: Decodable {
            let id: Int
            let name: String
            let email: String

            // Codable types can declare a special nested enumeration named CodingKeys
            // that conforms to the CodingKey

            enum CodingKeys: String, CodingKey {
                case id = "_id"
                case name = "_name"
                case email = "_email"
            }
        }

        let user = try! JSONDecoder().decode(User.self, from: data)

        #expect(user.id == 1)
        #expect(user.name == "John Doe")
        #expect(user.email == "john.doe@example.com")
    }

    @Test func testDecodingManually() throws {
        let data = """
        {
            "id": 1,
            "name": "John Doe",
            "address": {
                "street": "123 Main St",
                "city": "New York",
                "zipcode": "10001"
            }
        }
        """.data(using: .utf8)!

        struct User: Decodable {
            let id: Int
            let name: String
            let street: String
            let city: String
            let zipcode: String

            enum CodingKeys: String, CodingKey {
                case id
                case name
                case address
            }

            enum AddressKeys: String, CodingKey {
                case street
                case city
                case zipcode
            }

            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decode(Int.self, forKey: .id)
                name = try values.decode(String.self, forKey: .name)

                let addressValues = try values.nestedContainer(keyedBy: AddressKeys.self, forKey: .address)
                street = try addressValues.decode(String.self, forKey: .street)
                city = try addressValues.decode(String.self, forKey: .city)
                zipcode = try addressValues.decode(String.self, forKey: .zipcode)
            }
        }

        let user = try! JSONDecoder().decode(User.self, from: data)

        #expect(user.id == 1)
        #expect(user.name == "John Doe")
        #expect(user.street == "123 Main St")
        #expect(user.city == "New York")
        #expect(user.zipcode == "10001")
    }

    @Test func testDecodingObjectAsArray() throws {
        let data = """
        {
          "id1": {
            "name": "John Doe",
            "email": "john.doe@example.com"
          },
          "id2": {
            "name": "Jane Smith",
            "email": "jane.smith@example.com"
          },
          "id3": {
            "name": "Emily Davis",
            "email": "emily@example.com"
          }
        }
        """.data(using: .utf8)!

        struct User: Decodable {
            let name: String
            let email: String
        }

        let userDictionary = try! JSONDecoder().decode([String: User].self, from: data)
        let sortedKeys = userDictionary.keys.sorted()
        let users = sortedKeys.compactMap { userDictionary[$0] }

        #expect(users.count == 3)
        do {
            let user = users[0]
            #expect(user.name == "John Doe")
            #expect(user.email == "john.doe@example.com")
        }
    }
}
