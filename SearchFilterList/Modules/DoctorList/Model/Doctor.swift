//
//  Doctor.swift
//  SearchFilterList
//
//  Created by Infotech Solutions on 22/11/21.
//

import Foundation

// MARK: - Doctor Model
struct Doctor: Decodable {
    var doctorID, name, slug: String
    var isPopular: Bool
    var about, overview: String
    var photo: Photo
    var sip, experience: String
    var price: Price
    var specialization: Specialization
    var hospital: [Hospital]
    var aboutPreview: String

    enum CodingKeys: String, CodingKey {
        case doctorID = "doctor_id"
        case name, slug
        case isPopular = "is_popular"
        case about, overview, photo, sip, experience, price, specialization, hospital
        case aboutPreview = "about_preview"
    }
}

// MARK: - Hospital
struct Hospital: Codable {
    var id: String
    var name: String
    var image, icon: Photo
}

// MARK: - Photo
struct Photo: Codable {
    var sizeFormatted: String
    var url: String
    var formats: Formats

    enum CodingKeys: String, CodingKey {
        case sizeFormatted = "size_formatted"
        case url, formats
    }
}

// MARK: - Formats
struct Formats: Codable {
    var thumbnail, large, medium, small: String
}


// MARK: - Price
struct Price: Codable {
    var raw: Int
    var formatted: String
}

// MARK: - Specialization
struct Specialization: Codable {
    var id, name: String
}

