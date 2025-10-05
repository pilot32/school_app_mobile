# Teacher Dashboard Features

This directory contains all the teacher dashboard functionality for the school app. The teacher dashboard provides comprehensive tools for teachers to manage their classes, students, and academic activities.

## Features Overview

### 1. Attendance Marking (`attendance_marking_screen.dart`)
- **Purpose**: Allows teachers to mark student attendance for their classes
- **Key Features**:
  - Select date for attendance marking
  - Mark students as Present, Absent, Late, or Excused
  - Add remarks for individual students
  - View attendance summary with counts
  - Save attendance records

### 2. Class Announcements (`announcement_screen.dart`)
- **Purpose**: Enables teachers to create and manage announcements for their classes
- **Key Features**:
  - Create announcements with title, content, and target class
  - Mark announcements as urgent
  - Set expiry dates for announcements
  - Filter announcements by class
  - Edit and delete existing announcements
  - View announcement history

### 3. Marks Management (`marks_management_screen.dart`)
- **Purpose**: Allows teachers to record and manage student grades
- **Key Features**:
  - Add marks for different exam types (Quiz, Test, Assignment, Midterm, Final)
  - Record marks for multiple students at once
  - Add remarks for individual students
  - Filter marks by exam type
  - View grade calculations and percentages
  - Edit and delete existing marks

### 4. Homework Assignment (`homework_assignment_screen.dart`)
- **Purpose**: Enables teachers to assign homework to students
- **Key Features**:
  - Create homework assignments with title, details, and due date
  - Set maximum marks for homework
  - Add attachment URLs
  - Track homework urgency levels (Overdue, Urgent, Soon, Normal)
  - Edit and delete homework assignments
  - View homework history

### 5. Classwork Updates (`classwork_update_screen.dart`)
- **Purpose**: Allows teachers to record daily classwork activities
- **Key Features**:
  - Record classwork with title and description
  - Add homework assignments as part of classwork
  - Attach files or URLs
  - Filter classwork by date
  - Edit and delete classwork entries
  - Track daily teaching activities

### 6. Substitute Teacher Requests (`substitute_request_screen.dart`)
- **Purpose**: Enables teachers to request substitute teachers when needed
- **Key Features**:
  - Create substitute requests with subject, class, and date
  - Provide reason for substitute request
  - Track request status (Pending, Approved, Rejected, Completed)
  - View substitute teacher assignments
  - Edit and cancel pending requests
  - Filter requests by status

### 7. Main Teacher Dashboard (`teacher_dashboard.dart`)
- **Purpose**: Central hub for all teacher activities
- **Key Features**:
  - Overview of teacher's classes and subjects
  - Quick access to all features
  - Recent activity feed
  - Upcoming classes schedule
  - Profile management
  - Navigation between different features

## Data Models

The following data models support the teacher dashboard functionality:

- **Teacher** (`../../../../data/models/teacher.dart`): Teacher profile and information
- **Attendance** (`../../../../data/models/attendance.dart`): Student attendance records
- **Announcement** (`../../../../data/models/announcement.dart`): Class announcements
- **Marks** (`../../../../data/models/marks.dart`): Student grades and marks
- **Classwork** (`../../../../data/models/classwork.dart`): Daily classwork records
- **SubstituteRequest** (`../../../../data/models/substitute_request.dart`): Substitute teacher requests

## State Management

The teacher dashboard uses the `TeacherProvider` (`../../core/teacher_provider.dart`) for state management, which:
- Manages teacher profile data
- Provides methods to update teacher information
- Handles teacher authentication state

## Navigation

The teacher dashboard is accessible through the main app routing:
- Route: `/teacher-dashboard`
- Accessible from the login screen by selecting "Teacher" role

## Usage

1. **Login as Teacher**: Select "Teacher" option on the login screen
2. **Main Dashboard**: View overview and quick actions
3. **Navigate Features**: Use quick action cards or bottom navigation
4. **Manage Classes**: Access class-specific features from the Classes tab
5. **Update Profile**: View and manage teacher profile information

## Future Enhancements

- Integration with backend APIs
- Real-time notifications
- File upload functionality
- Advanced reporting and analytics
- Parent communication features
- Calendar integration
- Grade book export functionality

## Technical Notes

- All screens are responsive and follow Material Design guidelines
- State management uses Provider pattern
- Data persistence will be implemented with backend integration
- Error handling and loading states are included
- Form validation is implemented for all input fields
