import Foundation
import FirebaseFirestore
import CoreLocation

struct Event: Codable, Identifiable, Hashable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    @DocumentID var id: String?
    var date: Date
    var name: String
    var startPoint: Coordinate?
    var distance: Double
    var estimatedTime: Int
    var timePosted: Date
    var clubId: String
    var runIds: [String]
    
    init(id: String? = nil,
         date: Date,
         name: String,
         startPoint: CLLocationCoordinate2D?,
         clubId: String,
         distance: Double,
         estimatedTime: Int = 0,
         runIds: [String]) {
        self.id = id
        self.date = date
        self.name = name
        self.timePosted = Date()
        self.clubId = clubId
        self.startPoint = Coordinate(from: startPoint ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
        self.distance = distance
        self.estimatedTime = estimatedTime
        self.runIds = runIds
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.date = try container.decode(Date.self, forKey: .date)
        self.name = try container.decode(String.self, forKey: .name)
        self.clubId = try container.decode(String.self, forKey: .clubId)
        self.timePosted = try container.decode(Date.self, forKey: .timePosted)
        self.startPoint = try container.decode(Coordinate.self, forKey: .startPoint)
        self.distance = try container.decode(Double.self, forKey: .distance)
        self.runIds = try container.decode([String].self, forKey: .runIds)
        self.estimatedTime = try container.decodeIfPresent(Int.self, forKey: .estimatedTime) ?? 0
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timePosted, forKey: .timePosted)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.clubId, forKey: .clubId)
        try container.encode(self.startPoint, forKey: .startPoint)
        try container.encode(self.distance, forKey: .distance)
        try container.encode(self.estimatedTime, forKey: .estimatedTime)
        try container.encode(self.runIds, forKey: .runIds)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case date
        case name
        case location
        case timePosted
        case clubId
        case startPoint
        case endPoint
        case distance
        case estimatedTime
        case runIds
    }
    
    func getDaysString() -> String {
        let dateFormatter = DateFormatterService()
        let calendar = Calendar.current
        if dateFormatter.getDateString(date: Date()) == dateFormatter.getDateString(date: date) {
            return "Today"
        } else {
            if date > Date() {
                let components = calendar.dateComponents([.day], from: Date(), to: date)
                return "In \(components.day ?? 0) days"
            } else {
                let components = calendar.dateComponents([.day], from: date, to: Date())
                return "\(components.day ?? 0) days ago"
            }
        }
    }
    

    func getFormattedEstimatedTime() -> String {
        let hours = estimatedTime / 60
        let minutes = estimatedTime % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    func getEstimatedPace() -> String {
        guard distance > 0 && estimatedTime > 0 else { return "N/A" }
        
        let paceInMinutesPerKm = Double(estimatedTime) / distance
        let paceMinutes = Int(paceInMinutesPerKm)
        let paceSeconds = Int((paceInMinutesPerKm - Double(paceMinutes)) * 60)
        
        return String(format: "%d:%02d /km", paceMinutes, paceSeconds)
    }
}
