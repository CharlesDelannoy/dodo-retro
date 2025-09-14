# Dodo Retro App - Context for Claude

> **Instructions for Claude**: Always read this file first when working on this project. Keep it updated automatically whenever you make changes to the app structure, models, controllers, routes, or key features. No permission needed - just update it.

## App Overview
- **Name**: Dodo Retrospective
- **Framework**: Rails 8.0.2+
- **Database**: PostgreSQL
- **Styling**: TailwindCSS
- **Authentication**: Custom Rails authentication system

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

## Models

### User (`app/models/user.rb`)
```ruby
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  validates :username, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :username, with: ->(u) { u.strip }
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

## Routes (`config/routes.rb`)
```ruby
resources :users, only: [:create]
get "signup", to: "users#new"
resource :session
get "login", to: "sessions#new"
resources :passwords, param: :token
root "home#index"
```

### Key Routes
- `/signup` (GET) → `users#new` - signup form
- `/users` (POST) → `users#create` - process signup
- `/login` (GET) → `sessions#new` - login form
- `/session` (POST) → `sessions#create` - process login
- `/session` (DELETE) → `sessions#destroy` - logout

## Views

### Layout & Shared
- **Navbar** (`app/views/shared/_navbar.html.erb`):
  - Shows "Welcome, [username]" and "Sign out" when logged in
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

## Key Features Implemented
1. ✅ User registration with username
2. ✅ User authentication (login/logout)
3. ✅ Session management
4. ✅ Custom routes (`/login`, `/signup`)
5. ✅ Responsive UI with TailwindCSS
6. ✅ Form validation and error handling
7. ✅ Flash messages for success/error states

## Important Notes
- `Current.user` is available throughout the app via the Current model
- Home page allows unauthenticated access but still resumes session
- All authentication redirects go to `/login` (not `/session/new`)
- Sign out button must use Turbo method for DELETE requests
- User model normalizes email (lowercase) and username (strip only)

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

## Recent Changes
- Added username field to users
- Created signup functionality
- Updated all authentication redirects to use semantic routes
- Fixed session resumption on home page
- Updated sign out button to use proper Turbo syntax
- Cleaned up test suite - removed unnecessary view/helper tests, improved remaining tests