import 'package:flutter/foundation.dart';

import '../index.dart';

class Attributes {
  Title? title;
  List<AltTitles>? altTitles;
  Description? description;
  bool? isLocked;
  Links? links;
  String? originalLanguage;
  String? lastVolume;
  String? lastChapter;
  String? publicationDemographic;
  String? status;
  int? year;
  String? contentRating;
  List<Tags>? tags;
  String? state;
  bool? chapterNumbersResetOnNewVolume;
  String? createdAt;
  String? updatedAt;
  int? version;
  List<String>? availableTranslatedLanguages;
  String? latestUploadedChapter;

  Attributes({
    this.title,
    this.altTitles,
    this.description,
    this.isLocked,
    this.links,
    this.originalLanguage,
    this.lastVolume,
    this.lastChapter,
    this.publicationDemographic,
    this.status,
    this.year,
    this.contentRating,
    this.tags,
    this.state,
    this.chapterNumbersResetOnNewVolume,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.availableTranslatedLanguages,
    this.latestUploadedChapter,
  });

  Attributes.fromJson(Map<String, dynamic> json) {
    title = json['title'] != null ? Title.fromJson(json['title']) : null;
    if (json['altTitles'] != null) {
      altTitles = <AltTitles>[];
      json['altTitles'].forEach((v) {
        altTitles!.add(AltTitles.fromJson(v));
      });
    }
    description = json['description'] != null
        ? Description.fromJson(json['description'])
        : null;
    isLocked = json['isLocked'];
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    originalLanguage = json['originalLanguage'];
    lastVolume = json['lastVolume'];
    lastChapter = json['lastChapter'];
    publicationDemographic = json['publicationDemographic'];
    status = json['status'];
    year = json['year'];
    contentRating = json['contentRating'];
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
    state = json['state'];
    chapterNumbersResetOnNewVolume = json['chapterNumbersResetOnNewVolume'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['version'];
    availableTranslatedLanguages =
        json['availableTranslatedLanguages'].cast<String>();
    latestUploadedChapter = json['latestUploadedChapter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) {
      data['title'] = title!.toJson();
    }
    if (altTitles != null) {
      data['altTitles'] = altTitles!.map((v) => v.toJson()).toList();
    }
    if (description != null) {
      data['description'] = description!.toJson();
    }
    data['isLocked'] = isLocked;
    if (links != null) {
      data['links'] = links!.toJson();
    }
    data['originalLanguage'] = originalLanguage;
    data['lastVolume'] = lastVolume;
    data['lastChapter'] = lastChapter;
    data['publicationDemographic'] = publicationDemographic;
    data['status'] = status;
    data['year'] = year;
    data['contentRating'] = contentRating;
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    data['state'] = state;
    data['chapterNumbersResetOnNewVolume'] = chapterNumbersResetOnNewVolume;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['version'] = version;
    data['availableTranslatedLanguages'] = availableTranslatedLanguages;
    data['latestUploadedChapter'] = latestUploadedChapter;
    return data;
  }

  @override
  String toString() {
    return 'Attributes{title: $title, altTitles: $altTitles, description: $description, isLocked: $isLocked, links: $links, originalLanguage: $originalLanguage, lastVolume: $lastVolume, lastChapter: $lastChapter, publicationDemographic: $publicationDemographic, status: $status, year: $year, contentRating: $contentRating, tags: $tags, state: $state, chapterNumbersResetOnNewVolume: $chapterNumbersResetOnNewVolume, createdAt: $createdAt, updatedAt: $updatedAt, version: $version, availableTranslatedLanguages: $availableTranslatedLanguages, latestUploadedChapter: $latestUploadedChapter}';
  }
}