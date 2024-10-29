//
//  RunClubTests.swift
//  RunClubTests
//
//  Created by Rhianna McCormack on 14/10/2024.
//

import XCTest
import CoreLocation
@testable import RunClub

final class RunClubTests: XCTestCase {

    var club: Club!
    var event: Event!
    var message: Message!

    override func setUpWithError() throws {
        super.setUp()
        // Initialize an example Event object for testing
        event = Event(
            id: "event123",
            date: Date(),
            name: "Fun Run",
            startPoint: CLLocationCoordinate2D(latitude: 34.0, longitude: -118.0),
            clubId: "club123",
            distance: 5.0,
            estimatedTime: 30,
            runIds: ["run1", "run2"]
        )
        club = Club(
            id: "club123",
            name: "Running Club",
            ownerId: "owner123",
            memberIds: ["member1", "member2"],
            eventIds: ["event1"],
            messageIds: ["message1"]
        )
        message = Message(
            id: "1",
            messageContent: "Hello, RunClub!",
            posterId: "user1", 
            clubId: "club1"
        )
    }

    override func tearDownWithError() throws {
        event = nil
        club = nil
        super.tearDown()
    }

    func testEventEncoding() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(event)
        let jsonString = String(data: data, encoding: .utf8)
        
        XCTAssertNotNil(jsonString, "Event should be encoded to JSON")
    }

    func testEventDecoding() throws {
        let json = """
        {
            "id": "event456",
            "date": "\(ISO8601DateFormatter().string(from: Date()))",
            "name": "Morning Jog",
            "clubId": "club456",
            "timePosted": "\(ISO8601DateFormatter().string(from: Date()))",
            "startPoint": {
                "latitude": 34.0,
                "longitude": -118.0
            },
            "distance": 10.0,
            "estimatedTime": 60,
            "runIds": ["run3", "run4"]
        }
        """
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let decodedEvent = try decoder.decode(Event.self, from: jsonData)
        
        XCTAssertEqual(decodedEvent.id, "event456", "Event ID should match")
        XCTAssertEqual(decodedEvent.name, "Morning Jog", "Event name should match")
        XCTAssertEqual(decodedEvent.clubId, "club456", "Event club ID should match")
        XCTAssertEqual(decodedEvent.distance, 10.0, "Event distance should match")
        XCTAssertEqual(decodedEvent.estimatedTime, 60, "Event estimated time should match")
        XCTAssertEqual(decodedEvent.runIds, ["run3", "run4"], "Event run IDs should match")
    }

    func testEventEquality() {
        let event1 = Event(id: "event123", date: Date(), name: "Fun Run", startPoint: nil, clubId: "club123", distance: 5.0, estimatedTime: 30, runIds: ["run1"])
        let event2 = Event(id: "event123", date: Date(), name: "Morning Run", startPoint: nil, clubId: "club456", distance: 10.0, estimatedTime: 60, runIds: ["run2"])

        XCTAssertTrue(event1 == event2, "Events with the same ID should be equal")

        let event3 = Event(id: "event789", date: Date(), name: "Evening Run", startPoint: nil, clubId: "club789", distance: 5.0, estimatedTime: 30, runIds: ["run3"])

        XCTAssertFalse(event1 == event3, "Events with different IDs should not be equal")
    }

    func testGetFormattedEstimatedTime() {
        XCTAssertEqual(event.getFormattedEstimatedTime(), "30m", "Estimated time should format correctly")
        
        event.estimatedTime = 90
        XCTAssertEqual(event.getFormattedEstimatedTime(), "1h 30m", "Estimated time should format correctly with hours")
    }

    func testGetEstimatedPace() {
        XCTAssertEqual(event.getEstimatedPace(), "6:00 /km", "Estimated pace should calculate correctly")
        
        event.distance = 0
        XCTAssertEqual(event.getEstimatedPace(), "N/A", "Pace should return N/A for zero distance")
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }


    func testClubEncoding() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(club)
        let jsonString = String(data: data, encoding: .utf8)
        
        XCTAssertNotNil(jsonString, "Club should be encoded to JSON")
    }

    func testClubDecoding() throws {
        let json = """
        {
            "id": "club456",
            "name": "Walking Club",
            "ownerId": "owner456",
            "memberIds": ["member3", "member4"],
            "eventIds": ["event2"],
            "messageIds": ["message2"]
        }
        """
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let decodedClub = try decoder.decode(Club.self, from: jsonData)
        
        XCTAssertEqual(decodedClub.id, "club456", "Club ID should match")
        XCTAssertEqual(decodedClub.name, "Walking Club", "Club name should match")
        XCTAssertEqual(decodedClub.ownerId, "owner456", "Club owner ID should match")
        XCTAssertEqual(decodedClub.memberIds, ["member3", "member4"], "Club member IDs should match")
        XCTAssertEqual(decodedClub.eventIds, ["event2"], "Club event IDs should match")
        XCTAssertEqual(decodedClub.messageIds, ["message2"], "Club message IDs should match")
    }

    func testClubEquality() {
        let club1 = Club(id: "club123", name: "Running Club", ownerId: "owner123", memberIds: ["member1"], eventIds: [], messageIds: [])
        let club2 = Club(id: "club123", name: "Walking Club", ownerId: "owner456", memberIds: ["member2"], eventIds: [], messageIds: [])
        
        XCTAssertTrue(club1 == club2, "Clubs with the same ID should be equal")
        
        let club3 = Club(id: "club789", name: "Cycling Club", ownerId: "owner789", memberIds: [], eventIds: [], messageIds: [])
        
        XCTAssertFalse(club1 == club3, "Clubs with different IDs should not be equal")
    }

        func testFeedItemInitializationMessage() {
      
            let feedItem = FeedItem.message(message)
            switch feedItem {
            case .message(let msg):
                XCTAssertEqual(msg.id, "1")
            default:
                XCTFail("Expected a message feed item")
            }
        }

        func testFeedItemInitializationEvent() {
            let event = Event(id: "2", date: Date(), name: "Run Together", startPoint: nil, clubId: "club1", distance: 5.0, estimatedTime: 30, runIds: [])
            let feedItem = FeedItem.event(event)

            switch feedItem {
            case .event(let evt):
                XCTAssertEqual(evt.id, "2")
            default:
                XCTFail("Expected an event feed item")
            }
        }

        func testFeedItemDateForMessage() {
            let now = Date()
            let message = Message(id: "1", messageContent: "Hello, RunClub!", posterId: "user1", clubId: "club1")
            let feedItem = FeedItem.message(message)
            let date = feedItem.date
            XCTAssertEqual(date, now)
        }

        func testFeedItemDateForEvent() {
            let eventDate = Date()
            let event = Event(id: "2", date: eventDate, name: "Run Together", startPoint: nil, clubId: "club1", distance: 5.0, estimatedTime: 30, runIds: [])
            let feedItem = FeedItem.event(event)
            let date = feedItem.date
            XCTAssertEqual(date, eventDate)
        }

        func testFeedItemWithNilMessageId() {
            let message = Message(id: nil, messageContent: "Hello, RunClub!", posterId: "user1", clubId: "club1")
            let feedItem = FeedItem.message(message)
            let id = feedItem.id
            XCTAssertNotNil(UUID(uuidString: id), "Expected a valid UUID when message ID is nil")
        }

        func testFeedItemWithNilEventId() {
            let event = Event(id: nil, date: Date(), name: "Run Together", startPoint: nil, clubId: "club1", distance: 5.0, estimatedTime: 30, runIds: [])
            let feedItem = FeedItem.event(event)
            let id = feedItem.id
            XCTAssertNotNil(UUID(uuidString: id), "Expected a valid UUID when event ID is nil")
        }
    
    func testRunInitialization() {
            let locations = [
                CLLocation(latitude: 37.7749, longitude: -122.4194),
                CLLocation(latitude: 34.0522, longitude: -118.2437)
            ]
            let startTime = Date()
            let elapsedTime: TimeInterval = 3600 // 1 hour
            let runnerId = "runner1"
            
            let run = Run(eventId: "event1", locations: locations, startTime: startTime, elapsedTime: elapsedTime, runnerId: runnerId)

            XCTAssertEqual(run.eventId, "event1")
            XCTAssertEqual(run.startTime, startTime)
            XCTAssertEqual(run.elapsedTime, elapsedTime)
            XCTAssertEqual(run.runnerId, runnerId)
            XCTAssertEqual(run.locations.count, 2)
        }

        func testRunCodable() throws {
            let locations = [
                CLLocation(latitude: 37.7749, longitude: -122.4194),
                CLLocation(latitude: 34.0522, longitude: -118.2437)
            ]
            let run = Run(eventId: "event1", locations: locations, startTime: Date(), elapsedTime: 3600, runnerId: "runner1")

            let encoder = JSONEncoder()
            let data = try encoder.encode(run)
            let decoder = JSONDecoder()
            let decodedRun = try decoder.decode(Run.self, from: data)

            XCTAssertEqual(decodedRun.eventId, run.eventId)
            XCTAssertEqual(decodedRun.startTime, run.startTime)
            XCTAssertEqual(decodedRun.elapsedTime, run.elapsedTime)
            XCTAssertEqual(decodedRun.runnerId, run.runnerId)
            XCTAssertEqual(decodedRun.locations.count, run.locations.count)
        }

        func testLocationDataConversion() {
            let location = CLLocation(latitude: 37.7749, longitude: -122.4194)
            let locationData = Run.LocationData(from: location)

            let convertedLocation = locationData.toCLLocation()

            XCTAssertEqual(location.coordinate.latitude, convertedLocation.coordinate.latitude)
            XCTAssertEqual(location.coordinate.longitude, convertedLocation.coordinate.longitude)
            XCTAssertEqual(location.altitude, convertedLocation.altitude)
            XCTAssertEqual(location.timestamp, convertedLocation.timestamp)
        }
    
    func testChatInitialization() {
           let messageContent = "Hello, how are you?"
           let senderId = "user1"
           let receiverId = "user2"

           let chat = Chat(messageContent: messageContent, senderId: senderId, receiverId: receiverId)

           XCTAssertEqual(chat.messageContent, messageContent)
           XCTAssertEqual(chat.senderId, senderId)
           XCTAssertEqual(chat.receiverId, receiverId)
           XCTAssertNotNil(chat.timeSent)
       }

       func testChatCodable() throws {
           let originalChat = Chat(messageContent: "Test chat message", senderId: "user1", receiverId: "user2")

           let encoder = JSONEncoder()
           let data = try encoder.encode(originalChat)
           let decoder = JSONDecoder()
           let decodedChat = try decoder.decode(Chat.self, from: data)

           XCTAssertEqual(decodedChat.messageContent, originalChat.messageContent)
           XCTAssertEqual(decodedChat.senderId, originalChat.senderId)
           XCTAssertEqual(decodedChat.receiverId, originalChat.receiverId)
           XCTAssertEqual(decodedChat.timeSent, originalChat.timeSent) // Ensure timeSent matches
       }

       func testChatEquatable() {
           let chat1 = Chat(messageContent: "Test message 1", senderId: "user1", receiverId: "user2")
           chat1.id = "123"
           let chat2 = Chat(messageContent: "Test message 2", senderId: "user3", receiverId: "user4")
           chat2.id = "123"

           let areEqual = chat1 == chat2

           XCTAssertTrue(areEqual)
       }

       func testGetTimeString() {
           let chat = Chat(messageContent: "Test message", senderId: "user1", receiverId: "user2")
           let expectedFormatter = DateFormatter()
           expectedFormatter.timeStyle = .short
           expectedFormatter.timeZone = .current
           
           let timeString = chat.getTimeString()
           
           XCTAssertEqual(timeString, expectedFormatter.string(from: chat.timeSent))
       }

       func testGetDateString() {
           let chat = Chat(messageContent: "Test message", senderId: "user1", receiverId: "user2")
           let expectedFormatter = DateFormatter()
           expectedFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
           
           let dateString = chat.getDateString()
           
           XCTAssertEqual(dateString, expectedFormatter.string(from: chat.timeSent))
       }
    }

    
