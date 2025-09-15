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

## Models

### User (`app/models/user.rb`)
```ruby
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :created_teams, class_name: 'Team', foreign_key: 'creator_id', dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :teams, through: :participants

  validates :email_address, presence: true, uniqueness: true
  validates :username, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :username, with: ->(u) { u.strip }
end
```

### Team (`app/models/team.rb`)
```ruby
class Team < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }

  def include_user?(user)
    participants.exists?(user: user)
  end

  def add_user(user)
    participants.find_or_create_by(user: user)
  end
end
```

### Participant (`app/models/participant.rb`)
```ruby
class Participant < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :user_id, uniqueness: { scope: :team_id, message: "is already a member of this team" }
end
```

### Session (`app/models/session.rb`)
```ruby
class Session < ApplicationRecord
  belongs_to :user
end
```

### Current (`app/models/current.rb`)
```ruby
class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true
end
```

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

## Routes (`config/routes.rb`)
```ruby
resources :teams, only: [:index, :new, :create, :show] do
  collection do
    get :lookup_user
  end
end
resources :users, only: [:create]
get "signup", to: "users#new"
resource :session
get "login", to: "sessions#new"
resources :passwords, param: :token
root "home#index"
```

### Key Routes
- `/teams` (GET) → `teams#index` - user's teams list
- `/teams/new` (GET) → `teams#new` - create team form
- `/teams` (POST) → `teams#create` - process team creation
- `/teams/:id` (GET) → `teams#show` - team details
- `/teams/lookup_user` (GET) → `teams#lookup_user` - AJAX user lookup
- `/signup` (GET) → `users#new` - signup form
- `/users` (POST) → `users#create` - process signup
- `/login` (GET) → `sessions#new` - login form
- `/session` (POST) → `sessions#create` - process login
- `/session` (DELETE) → `sessions#destroy` - logout

## Views

### Layout & Shared
- **Navbar** (`app/views/shared/_navbar.html.erb`):
  - Shows "Welcome, [username]", "Teams" link, and "Sign out" when logged in
  - Shows "Sign in" when logged out
  - **Important**: Sign out uses `data: { turbo_method: :delete }`

### Authentication Forms
- **Login** (`app/views/sessions/new.html.erb`):
  - Email and password fields
  - Link to "Sign up to Dodo Retrospective"
  - Styled with TailwindCSS

- **Signup** (`app/views/users/new.html.erb`):
  - Email (first), username, password, password confirmation
  - Username placeholder: "Choose a username"
  - Validation error display
  - Link to login page
  - Styled to match login form

### Team Management
- **Teams Index** (`app/views/teams/index.html.erb`):
  - Grid layout of user's teams
  - Team stats (member count, creation date)
  - Member avatars preview
  - Empty state with call-to-action
  - "Create New Team" button

- **Team Creation** (`app/views/teams/new.html.erb`):
  - Team name input
  - Dynamic participant email inputs with Stimulus
  - Real-time user lookup (shows if email has account)
  - Add/remove participant functionality
  - Styled consistent with auth forms

- **Team Details** (`app/views/teams/show.html.erb`):
  - Team overview with stats cards
  - Complete member list with roles
  - Creator badge display
  - Placeholder sections for future features

## Key Features Implemented
1. ✅ User registration with username
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

## Recent Changes
- Added username field to users
- Created signup functionality
- Updated all authentication redirects to use semantic routes
- Fixed session resumption on home page
- Updated sign out button to use proper Turbo syntax
- Cleaned up test suite - removed unnecessary view/helper tests, improved remaining tests
- **NEW**: Implemented complete team management system
- **NEW**: Added dynamic participant management with Stimulus
- **NEW**: Real-time user lookup functionality
- **NEW**: Team creation with email-based member invitations