import SwiftUI

struct Movie: Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var imageName: String
    var cinemas: [Cinema]
}

struct Cinema: Codable, Identifiable {
    var id: Int
    var name: String
    var address: String
    var tickets: [Ticket]
}

struct Ticket: Codable, Identifiable {
    var id: Int
    var time: String
    var rowsCount: Int
    var seatsInRow: Int
    var seats: [Seat]
}

struct Seat: Hashable, Codable, Identifiable {
    var id: Int
    var row: Int
    var num: Int
    var price: Int
}

struct Pos: Hashable {
    var row: Int = 0
    var num: Int = 0
    
    init(row: Int, num: Int) {
        self.row = row
        self.num = num
    }
}

func setSeats(ticket: Ticket) -> Set<Pos> {
    var seats = Set<Pos>()
    for seat in ticket.seats {
        seats.insert(Pos(row: seat.row, num: seat.num))
    }
    return seats
}

let movies: [Movie] = load(from: "data.json")

func load(from fileName: String) -> [Movie] {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else
    {
        fatalError("Couldn't find \(fileName) in main bundle")
    }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Coundn't load \(fileName) from main bundle:\n\(error)")
    }
    do {
        let decoder = JSONDecoder();
        return try decoder.decode([Movie].self, from: data)
    } catch {
        fatalError("Couldn't parse \(fileName) as \([Movie].self):\n\(error)")
    }
}

func timeRowCount(for cinema: Cinema) -> Int{
    return (cinema.tickets.count + 3) / 4
}



func minPrice(for movie: Movie) -> Int {
    var minPrice = 10000
    for cinema in movie.cinemas {
        for ticket in cinema.tickets {
            for seat in ticket.seats {
                if seat.price < minPrice {
                    minPrice = seat.price
                }
            }
        }
    }
    return minPrice
}

func minPrice(for ticket: Ticket) -> Int {
    var minPrice = 1000
    for seat in ticket.seats {
        if seat.price < minPrice {
            minPrice = seat.price
        }
    }
    return minPrice
}

func maxPrice(for ticket: Ticket) -> Int {
    var maxPrice = 0
    for seat in ticket.seats {
        if seat.price > maxPrice {
            maxPrice = seat.price
        }
    }
    return maxPrice
}
