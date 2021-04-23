//
//  DataMappingTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 23.04.2021.
//

import XCTest
@testable import WhatToWatch

final class DataMappingTests: XCTestCase {

    // MARK: - Prepare

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter
    }()

    // MARK: - Tests

    func testGenre() {
        let expectedGenre = Genre(name: "Foo")
        let genreDTO = GenreDTO(name: "Foo")

        let genre = genreDTO.toDomain()
        XCTAssertEqual(genre, expectedGenre)
    }

    func testCountry() {
        let expectedCountry = Country(name: "Foo")
        let countryDTO = CountryDTO(name: "Foo")

        let country = countryDTO.toDomain()
        XCTAssertEqual(country, expectedCountry)
    }

    func testCast() {
        let expectedCast = Cast(personID: 1, name: "Foo", character: "Bar", photoPath: "Baz")
        let castDTO = CastDTO(personID: 1, name: "Foo", character: "Bar", photoPath: "Baz")

        let cast = castDTO.toDomain()
        XCTAssertEqual(cast, expectedCast)
    }

    func testCredit() {
        let expectedCredit = Credit(cast: [.init(personID: 1, name: "Foo", character: "Bar", photoPath: "Baz")])
        let creditDTO = CreditDTO(cast: [.init(personID: 1, name: "Foo", character: "Bar", photoPath: "Baz")])

        let credit = creditDTO.toDomain()
        XCTAssertEqual(credit, expectedCredit)
    }

    func testMovie() {
        let credit = Credit(cast: [.init(personID: 1, name: "Foo", character: "Bar", photoPath: "Baz")])
        let genre = Genre(name: "Foo")
        let country = Country(name: "Foo")
        let expectedMovie = Movie(id: 1,
                                  title: "Foo",
                                  overview: "Bar",
                                  releaseDate: dateFormatter.date(from: "2020-10-10"),
                                  rating: 2.0,
                                  posterPath: "Baz",
                                  backdropPath: "Bat",
                                  runtime: 60.0,
                                  credit: credit,
                                  genres: [genre],
                                  productionCountries: [country])

        let creditDTO = CreditDTO(cast: [.init(personID: 1, name: "Foo", character: "Bar", photoPath: "Baz")])
        let genreDTO = GenreDTO(name: "Foo")
        let countryDTO = CountryDTO(name: "Foo")
        let movieDTO = MovieDTO(id: 1,
                                title: "Foo",
                                overview: "Bar",
                                releaseDate: "2020-10-10",
                                rating: 2.0,
                                posterPath: "Baz",
                                backdropPath: "Bat",
                                runtime: 1,
                                credit: creditDTO,
                                genres: [genreDTO],
                                productionCountries: [countryDTO])

        let movie = movieDTO.toDomain()
        XCTAssertEqual(movie, expectedMovie)
    }

    func testTV() {
        let credit = Credit(cast: [.init(personID: 1, name: "Foo", character: "Bar", photoPath: "Baz")])
        let genre = Genre(name: "Foo")
        let country = Country(name: "Foo")
        let expectedTV = TV(id: 1,
                            title: "Foo",
                            overview: "Bar",
                            firstAirDate: dateFormatter.date(from: "2020-10-10"),
                            rating: 2.0,
                            posterPath: "Baz",
                            backdropPath: "Bat",
                            episodeRuntime: [60.0],
                            credit: credit,
                            genres: [genre],
                            productionCountries: [country])

        let creditDTO = CreditDTO(cast: [.init(personID: 1, name: "Foo", character: "Bar", photoPath: "Baz")])
        let genreDTO = GenreDTO(name: "Foo")
        let countryDTO = CountryDTO(name: "Foo")
        let tvDTO = TVDTO(id: 1,
                          title: "Foo",
                          overview: "Bar",
                          firstAirDate: "2020-10-10",
                          rating: 2.0,
                          posterPath: "Baz",
                          backdropPath: "Bat",
                          episodeRuntime: [1],
                          credit: creditDTO,
                          genres: [genreDTO],
                          productionCountries: [countryDTO])

        let tv = tvDTO.toDomain()
        XCTAssertEqual(tv, expectedTV)
    }

    func testPerson() {
        let expectedPerson = Person(id: 1,
                                    name: "Foo",
                                    biography: "Bar",
                                    birthday: dateFormatter.date(from: "2020-10-10"),
                                    photoPath: "Baz",
                                    knownForDepartment: "Bat",
                                    placeOfBirth: "Qux")

        let personDTO = PersonDTO(id: 1,
                                  name: "Foo",
                                  biography: "Bar",
                                  birthday: "2020-10-10",
                                  photoPath: "Baz",
                                  knownForDepartment: "Bat",
                                  placeOfBirth: "Qux")

        let person = personDTO.toDomain()
        XCTAssertEqual(person, expectedPerson)
    }

    func testMediaPage() {
        let model = MockModel(name: "Foo")
        let mediaPageDTO = MediaPageDTO(page: 1, totalPages: 2, media: [model])

        let mediaPage = mediaPageDTO.toDomain()
        XCTAssertEqual(mediaPage.page, 1)
        XCTAssertEqual(mediaPage.totalPages, 2)
        XCTAssertEqual(mediaPage.media, ["Foo"])
    }

}

// MARK: - Mock Model

private struct MockModel: Mappable, Decodable {

    let name: String

    func toDomain() -> String {
        return name
    }

}
