// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ============================================================================
// SIMPLE FORM MODEL
// ============================================================================

class Form {
  final String id;
  final String title;
  final String? description;
  final String? collectionId; // Parent collection/folder
  final FormStatus status;
  final DateTime createdAt;
  final int submissionsCount;

  Form({
    required this.id,
    required this.title,
    this.description,
    this.collectionId,
    this.status = FormStatus.draft,
    required this.createdAt,
    this.submissionsCount = 0,
  });

  Form copyWith({
    String? id,
    String? title,
    String? description,
    String? collectionId,
    FormStatus? status,
    DateTime? createdAt,
    int? submissionsCount,
  }) {
    return Form(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      collectionId: collectionId ?? this.collectionId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      submissionsCount: submissionsCount ?? this.submissionsCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'collectionId': collectionId,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'submissionsCount': submissionsCount,
    };
  }

  factory Form.fromJson(Map<String, dynamic> json) {
    return Form(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      collectionId: json['collectionId'],
      status: FormStatus.values.byName(json['status'] ?? 'draft'),
      createdAt: DateTime.parse(json['createdAt']),
      submissionsCount: json['submissionsCount'] ?? 0,
    );
  }
}

// ============================================================================
// FORM STATUS
// ============================================================================

enum FormStatus {
  draft,      // Being edited
  published,  // Live and accepting responses
  closed,     // Closed
}

// ============================================================================
// FAKE DATA FOR TESTING
// ============================================================================

List<Form> getFakeForms() {
  return [
    // Forms in Root
    Form(
      id: 'form_1',
      title: 'Company Survey',
      description: 'Annual company-wide survey',
      collectionId: '1', // Root
      status: FormStatus.published,
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      submissionsCount: 450,
    ),

    // Forms in Documents
    Form(
      id: 'form_2',
      title: 'Document Request Form',
      description: 'Request official documents',
      collectionId: '2', // Documents
      status: FormStatus.published,
      createdAt: DateTime.now().subtract(Duration(days: 5)),
      submissionsCount: 127,
    ),

    // Forms in Work
    Form(
      id: 'form_3',
      title: 'Project Proposal',
      description: 'Submit new project proposals',
      collectionId: '5', // Work
      status: FormStatus.published,
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      submissionsCount: 45,
    ),
    Form(
      id: 'form_4',
      title: 'Time Off Request',
      description: 'Request vacation or sick leave',
      collectionId: '5', // Work
      status: FormStatus.published,
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      submissionsCount: 89,
    ),

    // Forms in Personal
    Form(
      id: 'form_5',
      title: 'Personal Goals Tracker',
      description: 'Track your personal goals',
      collectionId: '6', // Personal
      status: FormStatus.draft,
      createdAt: DateTime.now().subtract(Duration(days: 10)),
      submissionsCount: 0,
    ),
    Form(
      id: 'form_6',
      title: 'Daily Journal',
      description: 'Daily reflection and journaling',
      collectionId: '6', // Personal
      status: FormStatus.published,
      createdAt: DateTime.now().subtract(Duration(days: 15)),
      submissionsCount: 234,
    ),

    // Forms in Travel
    Form(
      id: 'form_7',
      title: 'Travel Checklist',
      description: 'Pre-travel preparation checklist',
      collectionId: '7', // Travel
      status: FormStatus.published,
      createdAt: DateTime.now().subtract(Duration(days: 20)),
      submissionsCount: 67,
    ),

    // Forms in Projects
    Form(
      id: 'form_8',
      title: 'Project Feedback',
      description: 'Collect feedback on video projects',
      collectionId: '9', // Projects
      status: FormStatus.published,
      createdAt: DateTime.now().subtract(Duration(days: 7)),
      submissionsCount: 103,
    ),
    Form(
      id: 'form_9',
      title: 'Video Upload Request',
      description: 'Request video upload and processing',
      collectionId: '6', // Projects
      status: FormStatus.closed,
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      submissionsCount: 156,
    ),

    // Forms in Reports
    Form(
      id: 'form_10',
      title: 'Monthly Report',
      description: 'Submit monthly performance reports',
      collectionId: '11', // Reports
      status: FormStatus.published,
      createdAt: DateTime.now().subtract(Duration(days: 4)),
      submissionsCount: 28,
    ),
  ];
}