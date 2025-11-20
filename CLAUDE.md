# Dodo Retro App - Context for Claude

> **Instructions for Claude**: Always read this file first when working on this project. Keep it updated automatically whenever you make changes to the app structure, models, controllers, routes, or key features. No permission needed - just update it.

## App Overview
- **Name**: Dodo Retrospective
- **Framework**: Rails 8.0.2+
- **Database**: PostgreSQL
- **Styling**: TailwindCSS
- **Authentication**: Custom Rails authentication system
- **Target Platform**: Desktop-first application (no mobile responsiveness needed)

## Database Schema

### Users Table
- `id` (primary key)
- `email_address` (string, not null, unique index)
- `password_digest` (string, not null) - for has_secure_password
- `username` (string) - added via migration
- `created_at`, `updated_at`

### Sessions Table
- `id` (primary key)
- `user_id` (foreign key to users)
- `user_agent` (string)
- `ip_address` (string)
- `created_at`, `updated_at`

### Teams Table
- `id` (primary key)
- `name` (string, not null)
- `creator_id` (foreign key to users, not null)
- `created_at`, `updated_at`

### Participants Table
- `id` (primary key)
- `team_id` (foreign key to teams, not null)
- `user_id` (foreign key to users, not null)
- `created_at`, `updated_at`
- **Unique constraint**: team_id + user_id (prevents duplicate memberships)

### PendingInvitations Table
- `id` (primary key)
- `team_id` (foreign key to teams, not null)
- `email` (string, not null)
- `inviter_id` (foreign key to users, not null)
- `status` (string, not null, default: 'pending')
- `created_at`, `updated_at`
- **Unique constraint**: team_id + email (prevents duplicate invitations)
- **Indexes**: team_id + email (unique), email

### RetrospectiveTypes Table
- `id` (primary key)
- `name` (string, not null) - e.g., 'Plus/Minus/Interesting', 'Start/Stop/Continue'
- `description` (text)
- `created_at`, `updated_at`

### RetrospectiveColumns Table
- `id` (primary key)
- `retrospective_type_id` (foreign key, not null)
- `name` (string, not null) - e.g., 'Plus', 'Minus', 'Interesting'
- `color` (string) - hex color for UI
- `position` (integer, not null) - display order
- `created_at`, `updated_at`

### Retrospectives Table
- `id` (primary key)
- `team_id` (foreign key, not null)
- `creator_id` (foreign key to users, not null) - the leader
- `retrospective_type_id` (foreign key, not null)
- `title` (string, not null) - auto-generated: `<team_name>-<YYYY-MM-DD>-<id>`
- `current_step` (string, not null, default: 'ice_breaker') - values: ice_breaker, ticket_creation, ticket_reveal, voting, discussion, completed
- `current_revealing_user_id` (foreign key to users, nullable)
- `created_at`, `updated_at`

## Models

### Key Associations
- **User**: has many teams (through participants), created_teams, created_retrospectives, sessions, sent_invitations
- **Team**: belongs to creator, has many users (through participants), has many pending_invitations, has many retrospectives
- **Participant**: join table between User and Team (unique constraint on team_id + user_id)
- **PendingInvitation**: tracks invitations to non-registered emails, auto-accepted on user signup
- **Session**: belongs to user, used for authentication
- **Current**: ActiveSupport::CurrentAttributes for thread-safe current user access
- **RetrospectiveType**: has many retrospective_columns, has many retrospectives
- **RetrospectiveColumn**: belongs to retrospective_type, ordered by position
- **Retrospective**: belongs to team, creator (User), retrospective_type, current_revealing_user (User, optional)

## Authentication System

### Authentication Concern (`app/controllers/concerns/authentication.rb`)
- Handles session management
- `require_authentication` - redirects to login if not authenticated
- `resume_session` - loads current session from cookie
- `start_new_session_for(user)` - creates new session
- `terminate_session` - destroys current session
- **Important**: Redirects to `login_path` (not `new_session_path`)

### Controllers

#### ApplicationController
- Includes Authentication concern
- Includes Pundit for authorization
- Modern browser requirement

#### SessionsController (`app/controllers/sessions_controller.rb`)
- `new` - shows login form
- `create` - authenticates user with `User.authenticate_by`
- `destroy` - signs out user
- Uses rate limiting (10 requests per 3 minutes)
- **Important**: All redirects use `login_path`

#### UsersController (`app/controllers/users_controller.rb`)
- `new` - shows signup form
- `create` - creates new user account
- Allows unauthenticated access
- Strong params: `username`, `email_address`, `password`, `password_confirmation`

#### HomeController (`app/controllers/home_controller.rb`)
- `index` - home page
- Allows unauthenticated access
- **Important**: Calls `resume_session` to make `Current.user` available

#### TeamsController (`app/controllers/teams_controller.rb`)
- `index` - lists user's teams (teams they created or are members of)
- `new` - shows team creation form with dynamic participant adding
- `create` - creates team and adds participants via email lookup
- `show` - displays team details and member list
- `lookup_user` - AJAX endpoint for email-to-user lookup
- Automatic creator participation when team is created
- **Email sending**: Sends invitation emails when participants are added
  - Existing users get `invitation_existing_user` email
  - Non-registered emails get `invitation_new_user` email
  - Uses `deliver_later` for async email delivery

#### RetrospectivesController (`app/controllers/retrospectives_controller.rb`)
- `new` - shows retrospective creation form with type selection
- `create` - creates retrospective for a team, sets current user as creator
- `show` - displays retrospective details and current step
- Scoped to team via `set_team` before_action
- Auto-generates title after creation: `<team_name>-<YYYY-MM-DD>-<creator_username>`

## Key Routes
- `/teams` - user's teams list (index), create team form (new), process team creation (create)
- `/teams/:id` - team details (show)
- `/teams/:team_id/retrospectives/new` - create retrospective form
- `/teams/:team_id/retrospectives` - create retrospective (POST)
- `/retrospectives/:id` - retrospective details (show)
- `/teams/lookup_user` - AJAX user lookup
- `/signup` - signup form
- `/login` - login form
- `/session` - process login (POST), logout (DELETE)

## Views Overview
- **Navbar**: Shows username, Teams link, Sign out when logged in
- **Auth Forms**: Login and Signup pages with TailwindCSS styling
- **Teams Index**: Grid of user's teams with stats, member previews, empty state
- **Team Creation**: Dynamic participant email inputs with Stimulus, real-time user lookup
- **Team Details**: Team overview, complete member list with roles, creator badge, "Start Retrospective" button
- **Retrospective Creation**: Format selection (Plus/Minus/Interesting), category preview, team-scoped
- **Retrospective Show**: Title display, step progress indicator, category grid, placeholder for future step functionality

## Key Features Implemented
1. ✅ User registration with username (auto-login after signup)
2. ✅ User authentication (login/logout)
3. ✅ Session management
4. ✅ Custom routes (`/login`, `/signup`)
5. ✅ Responsive UI with TailwindCSS
6. ✅ Form validation and error handling
7. ✅ Flash messages for success/error states
8. ✅ Team creation and management
9. ✅ Dynamic participant adding with email lookup
10. ✅ Real-time user validation via Stimulus
11. ✅ Team membership system with creator roles
12. ✅ Email invitations for team members (existing and new users)
13. ✅ Pending invitations system - tracks invitations sent to non-registered emails
14. ✅ Auto-acceptance of pending invitations when user signs up with matching email
15. ✅ Retrospective type system (flexible template configuration)
16. ✅ Retrospective creation (team-scoped, format selection)
17. ✅ Default retrospective type seeded (Plus/Minus/Interesting with color-coded categories)
18. ✅ Auto-generated retrospective titles

## Important Notes
- `Current.user` is available throughout the app via the Current model
- Home page allows unauthenticated access but still resumes session
- All authentication redirects go to `/login` (not `/session/new`)
- Sign out button must use Turbo method for DELETE requests
- User model normalizes email (lowercase) and username (strip only)
- **Desktop-first**: No mobile responsiveness - design for desktop screens only

## Database Access
```bash
psql dodo_retro_development
```

## Testing
- **RSpec** for testing framework
- **Minimal test suite** - removed unnecessary generated tests
- **Current tests**:
  - `spec/models/user_spec.rb` - User model validations and normalizations
  - `spec/requests/users_spec.rb` - User signup functionality
  - `spec/requests/home_spec.rb` - Home page access
- **Removed tests**: View tests, helper tests (all were just pending placeholders)

## Stimulus Controllers
- **team-form** (`app/javascript/controllers/team_form_controller.js`):
  - Dynamic participant input management
  - Add/remove participant functionality
  - Real-time email validation and user lookup
  - Form data collection before submission
  - Responsive UI feedback for user existence

## Email System
- **TeamMailer**: invitation_existing_user, invitation_new_user
- **Development**: letter_opener gem (previews in browser)
- **Delivery**: deliver_later with Solid Queue
- **Preview**: http://localhost:3000/rails/mailers/team_mailer