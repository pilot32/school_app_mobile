// lib/principal_dashboard.dart
// Principal Dashboard (UI) with detailed backend integration comments for engineers.
// -------------------------------------------------------------------------------
// PURPOSE: This file purposely contains only UI + explicit TODOs and API contracts.
// - Where the UI currently uses hardcoded/test values, those are marked: // TEST (HARDCODED)
// - For each place backend integration is required, there is:
//     * a short explanation of what the frontend expects,
//     * an example endpoint (HTTP method + path),
//     * expected request params (query/body/headers) and response JSON shape,
//     * notes about auth, pagination, caching, error handling and realtime updates.
// - Do NOT add API client code here; instead replace the TEST areas by calling your app's API client.
// -------------------------------------------------------------------------------

import 'package:flutter/material.dart';

class PrincipalDashboardNew extends StatefulWidget {
  const PrincipalDashboardNew({Key? key}) : super(key: key);

  @override
  State<PrincipalDashboardNew> createState() => _PrincipalDashboardState();
}

class _PrincipalDashboardState extends State<PrincipalDashboardNew> {
  // ---------------------------------------------------------------------------
  // TEST (HARDCODED) defaults - replace these with backend responses during integration
  // ---------------------------------------------------------------------------
  // NOTE for backend engineer:
  // - Frontend shows these immediately so the UI doesn't look empty while fetching.
  // - When integrating, return the same shape / value types described below.
  final int _studentsDefault = 1280; // TEST (HARDCODED) -
  final int _teachersDefault = 40; // TEST (HARDCODED) -

  // ---------------------------------------------------------------------------
  // DATA SOURCES FRONTEND NEEDS FROM BACKEND
  // ---------------------------------------------------------------------------
  // 1) Current user / principal info:
  //    - Use to display greeting (e.g., "Welcome, Akshat Ojha")
  //    - Endpoint contract (suggested):
  //      GET /api/v1/me
  //      Headers: Authorization: Bearer <token>
  //      Response (200):
  //      {
  //        "id": "user_123",
  //        "name": "Akshat Ojha",
  //        "role": "PRINCIPAL",
  //        "avatarUrl": "https://cdn.example.com/avatar.jpg" // optional
  //      }
  //
  //    Frontend should:
  //    - call /me on app start or when dashboard opens
  //    - show placeholder while loading
  //    - on 401 => redirect to login flow
  //
  // 2) Metrics (total students, total teachers, etc):
  //    - Endpoints (suggested):
  //      GET /api/v1/metrics?keys=students,teachers,classes
  //      Headers: Authorization: Bearer <token>
  //      Response (200):
  //      {
  //        "students": 1280,
  //        "teachers": 40,
  //        "classes": 36
  //      }
  //
  //    OR per-metric:
  //      GET /api/v1/metrics/{key}
  //      Response (200): { "key": "students", "value": 1280 }
  //
  //    Frontend should:
  //    - fetch metrics on init
  //    - show default (above) while loading
  //    - show retry / error UI on failure (or sticky cached value)
  //
  // 3) Dashboard cards configuration (so admin can add/remove cards without frontend deploy)
  //    - Suggested endpoint for dynamic cards:
  //      GET /api/v1/dashboard/cards?section=quick_overview
  //      Query params: section=quick_overview or section=manage
  //      Response (200):
  //      [
  //        {
  //          "id": "holidays",
  //          "title": "Holidays",
  //          "subtitle": "SCHOOL / NATIONAL",
  //          "icon": "holiday",      // frontend will map string -> IconData
  //          "route": "/holidays",   // optional: frontend route or deep-link
  //          "order": 1
  //        },
  //        ...
  //      ]
  //
  //    Frontend should:
  //    - fetch both quick_overview and manage lists
  //    - fallback to default local cards if backend returns empty
  //    - render horizontally scrollable lists with order by `order`
  //    - map `icon` string to native icon (mapping table in frontend)
  //
  // 4) Card detail lists (e.g., list of students for Students card)
  //    - Suggested paginated endpoint:
  //      GET /api/v1/students?page=1&pageSize=50
  //      Response (200):
  //      {
  //        "items": [{ "id":"s1","name":"Akshat Ojha","class":"8A" }, ...],
  //        "page": 1, "pageSize": 50, "total": 1248
  //      }
  //
  //    Frontend should:
  //    - support server-side pagination / infinite scroll
  //    - show skeleton rows while loading
  //    - send Authorization header
  //    - handle 403/401 gracefully
  //
  // 5) Create/Edit/Delete endpoints for Manage screens (CRUD)
  //    - POST /api/v1/teachers  (body: {name, email, phone, ...})
  //    - PUT /api/v1/teachers/{id}
  //    - DELETE /api/v1/teachers/{id}
  //    - Response codes: 201 (created), 200 (success), 204 (deleted)
  //
  //    Frontend should:
  //    - validate form fields client-side before submit
  //    - show spinner on submit
  //    - show success toast & refresh list after success
  //
  // 6) Realtime/Push updates (optional)
  //    - If counts must be near-real-time, implement either:
  //      a) WebSocket endpoint: ws://.../realtime or
  //      b) Server-Sent Events (SSE) endpoint: /api/v1/stream
  //    - Frontend will subscribe and update counts live.
  //
  // 7) Search / Filters for lists (students / teachers)
  //    - GET /api/v1/students?search=akshat&class=8A&page=1
  //
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // UI: Hardcoded placeholders used for quick demo. Replace fetchX() calls with
  // actual API client when integrating (call the endpoints described above).
  // ---------------------------------------------------------------------------

  // Below lists are local defaults (used if backend returns empty). They are only
  // for UI/testing convenience.
  final List<_CardConfig> defaultQuickOverviewCards = [
    _CardConfig(id: 'holidays', title: 'Holidays', subtitle: 'SCHOOL / NATIONAL', iconName: 'beach_access', route: '/holidays'),
    _CardConfig(id: 'calendar', title: 'Academic', subtitle: 'CALENDAR', iconName: 'calendar_today', route: '/calendar'),
    _CardConfig(id: 'classes', title: 'Classes', subtitle: '& Sections', iconName: 'class', route: '/classes'),
  ];

  final List<_CardConfig> defaultManageCards = [
    _CardConfig(id: 'teachers', title: 'Teachers', subtitle: 'Add / Edit / Delete', iconName: 'person', route: '/manage/teachers'),
    _CardConfig(id: 'resources', title: 'Resources', subtitle: 'Upload files', iconName: 'folder', route: '/manage/resources'),
    _CardConfig(id: 'attendance', title: 'Attendance', subtitle: 'Take / View', iconName: 'check_circle', route: '/attendance'),
  ];

  @override
  Widget build(BuildContext context) {
    // NOTE (frontend dev): Replace hardcoded greeting with BackendService.getCurrentUserName()
    // when integrating. See API contract at top of file.
    final String greetingTitle = 'Welcome Back';
    final String greetingSubtitle = 'Welcome, Principal!'; // TEST (HARDCODED) - to be replaced with real name

    return Material(

      child: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(image: AssetImage(assets))
        ),
        child: Scaffold(

          appBar: AppBar(title: const Text('Principal Dashboard')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greetingTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(greetingSubtitle, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 18),

                  // ------------------ TOP METRICS ------------------
                  Row(children: [
                    Expanded(child: _metricCard(
                      title: 'TOTAL STUDENTS',
                      // TODO (backend engineer): Frontend expects an integer.
                      // API: GET /api/v1/metrics?keys=students  -> { "students": 1280 }
                      // Frontend integration note: implement caching & fallback to default
                      value: _studentsDefault, // TEST (HARDCODED)
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _metricCard(
                      title: 'TOTAL TEACHERS',
                      // API: GET /api/v1/metrics?keys=teachers -> { "teachers": 40 }
                      value: _teachersDefault, // TEST (HARDCODED)
                    )),
                  ]),

                  const SizedBox(height: 20),

                  // ------------------ QUICK OVERVIEW ------------------
                  _sectionHeader(title: 'QUICK OVERVIEW', actionLabel: 'See All', onPressed: () {
                    // TODO: Open full overview screen. Backend: may provide full listing endpoint:
                    // GET /api/v1/dashboard/cards?section=quick_overview
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: defaultQuickOverviewCards.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final card = defaultQuickOverviewCards[index];
                        return _overviewCard(card);
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ------------------ MANAGE ------------------
                  _sectionHeader(title: 'MANAGE', actionLabel: 'Add', onPressed: () {
                    // TODO: Open a global "Add" dialog. Backend: POST endpoints per resource.
                    // Example: POST /api/v1/teachers with body {name, email, ...}
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: defaultManageCards.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final card = defaultManageCards[index];
                        return _manageCard(card);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------ UI COMPONENTS ------------------------

  Widget _metricCard({required String title, required int value}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          CircleAvatar(radius: 28, backgroundColor: Colors.indigo.withOpacity(0.1), child: Icon(Icons.school, color: Colors.indigo)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(value.toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          ])),
        ]),
      ),
    );
  }

  Widget _sectionHeader({required String title, required String actionLabel, required VoidCallback onPressed}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      TextButton(onPressed: onPressed, child: Text(actionLabel)),
    ]);
  }

  Widget _overviewCard(_CardConfig c) {
    return GestureDetector(
      onTap: () {
        // TODO (frontend): When integrating, navigate to route provided by backend or
        // call detail endpoint for c.id.
        // Suggested detail API: GET /api/v1/{c.id} or GET /api/v1/dashboard/card/{c.id}/items
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => _PlaceholderScreen(title: c.title)));
      },
      child: SizedBox(
        width: 220,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _iconFromName(c.iconName),
              const Spacer(),
              Text(c.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(c.subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _manageCard(_CardConfig c) {
    return InkWell(
      onTap: () {
        // TODO (frontend): Open manage screen which supports list + add/edit/delete.
        // Backend endpoints required: GET /api/v1/{resource}, POST /api/v1/{resource}, PUT /api/v1/{resource}/{id}, DELETE /api/v1/{resource}/{id}
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => _PlaceholderScreen(title: 'Manage ${c.title}')));
      },
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 220,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              _iconFromName(c.iconName),
              const SizedBox(height: 12),
              Text(c.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(c.subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _iconFromName(String name) {
    // Frontend mapping table (string->IconData). Keep mapping in one place.
    switch (name) {
      case 'person':
        return const Icon(Icons.person, size: 28);
      case 'folder':
        return const Icon(Icons.folder, size: 28);
      case 'check_circle':
        return const Icon(Icons.check_circle, size: 28);
      case 'calendar_today':
        return const Icon(Icons.calendar_today, size: 28);
      case 'beach_access':
        return const Icon(Icons.beach_access, size: 28);
      case 'class':
        return const Icon(Icons.class_, size: 28);
      default:
        return const Icon(Icons.widgets, size: 28);
    }
  }
}

// ---------------------- helper classes / placeholders ----------------------

class _CardConfig {
  final String id;
  final String title;
  final String subtitle;
  final String iconName;
  final String? route;
  _CardConfig({required this.id, required this.title, required this.subtitle, required this.iconName, this.route});
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text('Replace with real view for $title')));
  }
}
