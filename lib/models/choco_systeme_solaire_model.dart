// To parse this JSON data, do
//
//     final systemeSolaire = systemeSolaireFromJson(jsonString);

import 'dart:convert';

SystemeSolaire systemeSolaireFromJson(String str) => SystemeSolaire.fromJson(json.decode(str));

String systemeSolaireToJson(SystemeSolaire data) => json.encode(data.toJson());

class SystemeSolaire {
    List<Planets> bodies;

    SystemeSolaire({
        required this.bodies,
    });

    factory SystemeSolaire.fromJson(Map<String, dynamic> json) => SystemeSolaire(
        bodies: List<Planets>.from(json["bodies"].map((x) => Planets.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "bodies": List<dynamic>.from(bodies.map((x) => x.toJson())),
    };
}

class Planets {
    String id;
    String name;
    String englishName;
    bool isPlanet;
    List<Moon>? moons;
    int semimajorAxis;
    int perihelion;
    int aphelion;
    double eccentricity;
    double inclination;
    Mass mass;
    Vol vol;
    double density;
    double gravity;
    double escape;
    double meanRadius;
    double equaRadius;
    double polarRadius;
    double flattening;
    String dimension;
    double sideralOrbit;
    double sideralRotation;
    dynamic aroundPlanet;
    String discoveredBy;
    String discoveryDate;
    String alternativeName;
    double axialTilt;
    double avgTemp;
    double mainAnomaly;
    double argPeriapsis;
    double longAscNode;
    String bodyType;
    String rel;

    Planets({
        required this.id,
        required this.name,
        required this.englishName,
        required this.isPlanet,
        required this.moons,
        required this.semimajorAxis,
        required this.perihelion,
        required this.aphelion,
        required this.eccentricity,
        required this.inclination,
        required this.mass,
        required this.vol,
        required this.density,
        required this.gravity,
        required this.escape,
        required this.meanRadius,
        required this.equaRadius,
        required this.polarRadius,
        required this.flattening,
        required this.dimension,
        required this.sideralOrbit,
        required this.sideralRotation,
        required this.aroundPlanet,
        required this.discoveredBy,
        required this.discoveryDate,
        required this.alternativeName,
        required this.axialTilt,
        required this.avgTemp,
        required this.mainAnomaly,
        required this.argPeriapsis,
        required this.longAscNode,
        required this.bodyType,
        required this.rel,
    });

    factory Planets.fromJson(Map<String, dynamic> json) => Planets(
        id: json["id"],
        name: json["name"],
        englishName: json["englishName"],
        isPlanet: json["isPlanet"],
        moons: json["moons"] == null ? [] : List<Moon>.from(json["moons"].map((x) => Moon.fromJson(x))),
        semimajorAxis: json["semimajorAxis"],
        perihelion: json["perihelion"],
        aphelion: json["aphelion"],
        eccentricity: json["eccentricity"].toDouble(),
        inclination: json["inclination"].toDouble(),
        mass: Mass.fromJson(json["mass"]),
        vol: Vol.fromJson(json["vol"]),
        density: json["density"].toDouble(),
        gravity: json["gravity"].toDouble(),
        escape: json["escape"],
        meanRadius: json["meanRadius"].toDouble(),
        equaRadius: json["equaRadius"].toDouble(),
        polarRadius: json["polarRadius"].toDouble(),
        flattening: json["flattening"].toDouble(),
        dimension: json["dimension"],
        sideralOrbit: json["sideralOrbit"].toDouble(),
        sideralRotation: json["sideralRotation"].toDouble(),
        aroundPlanet: json["aroundPlanet"],
        discoveredBy: json["discoveredBy"],
        discoveryDate: json["discoveryDate"],
        alternativeName: json["alternativeName"],
        axialTilt: json["axialTilt"].toDouble(),
        avgTemp: json["avgTemp"].toDouble(),
        mainAnomaly: json["mainAnomaly"].toDouble(),
        argPeriapsis: json["argPeriapsis"].toDouble(),
        longAscNode: json["longAscNode"].toDouble(),
        bodyType: json["bodyType"],
        rel: json["rel"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "englishName": englishName,
        "isPlanet": isPlanet,
        "moons": moons == null ? [] : List<dynamic>.from(moons!.map((x) => x.toJson())),
        "semimajorAxis": semimajorAxis,
        "perihelion": perihelion,
        "aphelion": aphelion,
        "eccentricity": eccentricity,
        "inclination": inclination,
        "mass": mass.toJson(),
        "vol": vol.toJson(),
        "density": density,
        "gravity": gravity,
        "escape": escape,
        "meanRadius": meanRadius,
        "equaRadius": equaRadius,
        "polarRadius": polarRadius,
        "flattening": flattening,
        "dimension": dimension,
        "sideralOrbit": sideralOrbit,
        "sideralRotation": sideralRotation,
        "aroundPlanet": aroundPlanet,
        "discoveredBy": discoveredBy,
        "discoveryDate": discoveryDate,
        "alternativeName": alternativeName,
        "axialTilt": axialTilt,
        "avgTemp": avgTemp,
        "mainAnomaly": mainAnomaly,
        "argPeriapsis": argPeriapsis,
        "longAscNode": longAscNode,
        "bodyType": bodyType,
        "rel": rel,
    };
}

class Mass {
    double massValue;
    int massExponent;

    Mass({
        required this.massValue,
        required this.massExponent,
    });

    factory Mass.fromJson(Map<String, dynamic> json) => Mass(
        massValue: json["massValue"].toDouble(),
        massExponent: json["massExponent"],
    );

    Map<String, dynamic> toJson() => {
        "massValue": massValue,
        "massExponent": massExponent,
    };
}

class Moon {
    String moon;
    String rel;

    Moon({
        required this.moon,
        required this.rel,
    });

    factory Moon.fromJson(Map<String, dynamic> json) => Moon(
        moon: json["moon"],
        rel: json["rel"],
    );

    Map<String, dynamic> toJson() => {
        "moon": moon,
        "rel": rel,
    };
}

class Vol {
    double volValue;
    int volExponent;

    Vol({
        required this.volValue,
        required this.volExponent,
    });

    factory Vol.fromJson(Map<String, dynamic> json) => Vol(
        volValue: json["volValue"].toDouble(),
        volExponent: json["volExponent"],
    );

    Map<String, dynamic> toJson() => {
        "volValue": volValue,
        "volExponent": volExponent,
    };
}

