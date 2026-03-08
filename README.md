# fyp

A new Flutter project. In Our CMS project we are creating this for the Stakeholder Rise Group of Colleges, as also it is our final year project. 

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

├── users                       // all people (students + teachers + maybe admins)
│   └── {uid}                   // document ID = Firebase Auth UID
│       ├── role: "student" | "teacher" | "admin"
│       ├── name
│       ├── email
│       ├── department
│       └── ... (phone, profilePic, etc.)
│
├── departments                 // optional – if you have many
│   └── {deptId}
│
├── programs                    // BSCS, BBA, etc. (optional)
│
├── classes                     // or "sections" / "batches"
│   └── {classId}               // e.g. "BSCS-2022-A", "BSCS-sem4-A", auto-generated or custom
│       ├── name                // "BSCS Semester 4 - Section A"
│       ├── programId
│       ├── departmentId
│       ├── academicYear        // "2025-2026"
│       ├── semester            // 4
│       └── studentUids: [array of student uids]   ← very useful!
│
├── subjects
│   └── {subjectId}             // e.g. "CS-402", "MTH-301"
│       ├── code
│       ├── name                // "Database Systems"
│       ├── creditHours
│       └── teacherUid          // who is assigned to teach it (can be array if co-teachers)
│
└── attendance                  // ← core collection – one doc per student per lecture
└── {attendanceId}          // recommended format: {classId}_{subjectId}_{yyyy-MM-dd}_{period?}
├── classId
├── subjectId
├── date                    // Timestamp or yyyy-MM-dd string
├── studentUid
├── status                  // "present" | "absent" | "late" | "excused" | "leave"
├── markedBy                // teacher uid
├── markedAt                // Timestamp
├── remarks?                // optional string
└── lectureNumber?          // 1, 2, 3... if multiple periods per day