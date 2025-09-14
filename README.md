# Dodo Retro 🦤

A modern retrospective tool built with Rails 8, designed to help teams reflect and improve.

## 🚀 Quick Start

### Prerequisites

- **Ruby**: 3.4.5 (see `.ruby-version`)
- **Docker**: For PostgreSQL 17 database
- **Node.js**: For frontend assets (via Rails built-in tools)

### Initial Setup

1. **Clone and install dependencies:**
   ```bash
   git clone <repository-url>
   cd dodo-retro
   bundle install
   ```

2. **Start the database:**
   ```bash
   docker compose up -d
   ```

3. **Set up the database:**
   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Run tests to verify everything works:**
   ```bash
   rspec
   ```

5. **Start the development server:**
   ```bash
   bin/dev
   ```

Visit `http://localhost:3000` to see the application running! 🎉
