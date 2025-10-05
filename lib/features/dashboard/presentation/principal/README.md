# Principal Dashboard

This directory contains the comprehensive Principal Dashboard for the School Management System. The principal dashboard provides complete administrative control over the school operations.

## Features

### 1. Teacher Onboarding (`teacher_onboarding_screen.dart`)
- **Purpose**: Add new teachers to the system
- **Features**:
  - Complete teacher information form (name, email, phone, department)
  - Subject selection (multiple subjects can be assigned)
  - Class assignment (multiple classes can be assigned)
  - Profile image upload capability
  - Form validation and error handling
  - Success confirmation dialog

### 2. Student Application Form (`student_application_form_screen.dart`)
- **Purpose**: Create and manage student admission applications
- **Features**:
  - Student personal information (name, DOB, parents' details)
  - Contact information (phone, email, address)
  - Academic information (previous school, class, applied class/section)
  - Document checklist for required paperwork
  - Application status tracking
  - Form validation and submission

### 3. Teacher Assignment System (`teacher_assignment_screen.dart`)
- **Purpose**: Assign teachers to classes, sections, and subjects
- **Features**:
  - Teacher selection from available teachers
  - Class and section assignment
  - Subject assignment (multiple subjects per teacher)
  - Class teacher designation
  - View and manage existing assignments
  - Edit and delete assignment capabilities

### 4. Student Management (`student_management_screen.dart`)
- **Purpose**: Manage student transfers and class changes
- **Features**:
  - Student transfer request creation
  - Class and section change requests
  - Reason tracking for transfers
  - Pending request approval/rejection
  - Complete transfer history
  - Request status management

### 5. Announcement Management (`announcement_management_screen.dart`)
- **Purpose**: Create and manage school-wide announcements
- **Features**:
  - Create new announcements with title and content
  - Target specific classes or all classes
  - Subject-specific announcements
  - Urgent announcement marking
  - Expiry date setting
  - View and manage existing announcements
  - Edit and delete announcement capabilities

### 6. Fee Management (`fee_management_screen.dart`)
- **Purpose**: Manage fee structures for different classes and sections
- **Features**:
  - Create fee structures for classes and sections
  - Multiple fee types (tuition, transport, library, sports, etc.)
  - Academic year management
  - Effective date ranges
  - Total fee calculation
  - View and manage existing fee structures
  - Edit and delete fee structure capabilities

## Main Dashboard (`principal_dashboard.dart`)

The main dashboard provides:
- **Overview**: Quick stats and metrics
- **Quick Actions**: Direct access to all management functions
- **Navigation**: Tab-based navigation between dashboard, management, and profile
- **Welcome Section**: Personalized greeting with school information

## Data Models

The dashboard uses several data models:
- `Principal`: Principal information
- `Teacher`: Teacher details and capabilities
- `StudentApplication`: Student admission applications
- `TeacherAssignment`: Teacher class/subject assignments
- `StudentTransfer`: Student transfer requests
- `Announcement`: School announcements
- `FeeStructure`: Fee management structure

## Navigation

The principal dashboard is accessible via:
- Route: `/principal-dashboard`
- Demo login: Use the "Principal" button on the login screen

## Integration Notes

All screens are designed to work with backend APIs. Currently using mock data for demonstration purposes. The following integration points are needed:

1. **Authentication**: Principal login and session management
2. **Data Persistence**: CRUD operations for all entities
3. **File Upload**: Profile images and document attachments
4. **Real-time Updates**: Live data synchronization
5. **Notifications**: Push notifications for urgent announcements

## Usage

1. Login as Principal using the demo login button
2. Navigate through the dashboard using the bottom navigation
3. Use Quick Actions on the dashboard for immediate access to functions
4. Manage all aspects of school administration through the Management tab

## Future Enhancements

- Advanced reporting and analytics
- Bulk operations for multiple records
- Integration with external systems
- Mobile-responsive design improvements
- Advanced search and filtering capabilities
