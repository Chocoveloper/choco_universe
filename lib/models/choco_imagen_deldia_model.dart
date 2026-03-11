// To parse this JSON data, do
//
//     final imagenDelDia = imagenDelDiaFromJson(jsonString);

import 'dart:convert';

ImagenDelDia imagenDelDiaFromJson(String str) => ImagenDelDia.fromJson(json.decode(str));

String imagenDelDiaToJson(ImagenDelDia data) => json.encode(data.toJson());

class ImagenDelDia {
    DateTime date;
    String explanation;
    String hdurl;
    String mediaType;
    String serviceVersion;
    String title;
    String url; //De aquí obtengo la imagen del día

    ImagenDelDia({
        required this.date,
        required this.explanation,
        required this.hdurl,
        required this.mediaType,
        required this.serviceVersion,
        required this.title,
        required this.url,
    });

    factory ImagenDelDia.fromJson(Map<String, dynamic> json) => ImagenDelDia(
        date: DateTime.parse(json["date"]),
        explanation: json["explanation"],
        hdurl: json["hdurl"],
        mediaType: json["media_type"],
        serviceVersion: json["service_version"],
        title: json["title"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "explanation": explanation,
        "hdurl": hdurl,
        "media_type": mediaType,
        "service_version": serviceVersion,
        "title": title,
        "url": url,
    };
}
