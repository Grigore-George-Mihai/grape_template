## Grape Template

This repository serves as a default template for a Ruby on Rails (RoR) application using the --api flag with the Grape gem. It includes a pre-configured setup with essential gems and tools to streamline API development.

### Table of Contents

- [Installation](#installation)
- [Setup](#setup)
- [Gems](#gems)
- [Rake Tasks](#rake-tasks)
- [Grape API Generator](#grape-api-generator)
  - [Usage](#usage)
  - [Features](#features)
  - [Example](#example)
- [Docker Setup](#docker-setup)
- [Contact](#contact)

### Installation
Clone the repository
```bash
git clone https://github.com/Grigore-George-Mihai/grape_template
```

---

### Setup
**1. Rename the Application**

This will update the app name everywhere it appears (module name, titles, DB names, cable prefixes, Docker volumes, etc.).
```bash
bin/rails setup:rename_app
```

**2. Create Environment Files**

Copy environment template files into `.env.development` and `.env.test`.
```bash
bin/rails setup:copy_env
```
Then open each file and update values as needed:
- Database credentials (`POSTGRES_USER`, `POSTGRES_PASSWORD`)
- Any other environment-specific variables

**3. Set Up the Database**
```bash
bin/rails db:prepare   # Creates and migrates the database
bin/rails db:seed      # Loads seed data
```

**4. Optional Integrations**
- [Scout APM](https://github.com/scoutapp/scout_apm_ruby) — Update `config/scout_apm.yml` or remove if not needed.
- [Rollbar](https://github.com/rollbar/rollbar-gem) — Update `config/initializers/rollbar.rb` or remove if not needed.
- [PgHero](https://github.com/ankane/pghero) — Review configuration for database monitoring.

✅ You’re now ready to start development!

---

### Gems

**API Framework**
- [Grape](https://github.com/ruby-grape/grape): A REST-like API framework for Ruby that is designed to run on Rack or complement existing web application frameworks like Rails.
- [Grape Entity](https://github.com/ruby-grape/grape-entity): A framework-agnostic entity layer to decorate and serialize data objects for API responses.
- [Grape Swagger](https://github.com/ruby-grape/grape-swagger): Adds Swagger-compliant documentation to your Grape API.
- [Grape Swagger Entity](https://github.com/ruby-grape/grape-swagger-entity): Extends `grape-entity` to generate Swagger documentation automatically.
- [Grape Swagger Rails](https://github.com/ruby-grape/grape-swagger-rails): Integrates `grape-swagger` into Rails applications for serving Swagger UI.

**Pagination**
- [Pagy](https://github.com/ddnexus/pagy): A fast, efficient, and lightweight pagination gem for Rails, providing easy customization and flexibility with minimal overhead.

**Background Processing**
- [Sidekiq](https://github.com/mperham/sidekiq): Efficient background processing for Ruby applications.
- [Sidekiq-Scheduler](https://github.com/moove-it/sidekiq-scheduler): Extends Sidekiq to support scheduled and recurring jobs using a simple configuration.
- [Redis](https://github.com/redis/redis-rb): In-memory data structure store used by Sidekiq for managing background job queues, scheduling, and retries.

**Performance Monitoring**
- [Scout APM](https://github.com/scoutapp/scout_apm_ruby): Application monitoring tool.
- [Bullet](https://github.com/flyerhzm/bullet): Detects N+1 queries and unused eager loading.

**Error Tracking**
- [Rollbar](https://github.com/rollbar/rollbar-gem): Real-time error tracking and reporting.

**Code Quality & Linting**
- [Rubocop Rails Suite](https://github.com/Grigore-George-Mihai/rubocop-rails-suite): A custom suite that bundles Rubocop with various plugins for Rails projects.

**Testing**
- [Factory Bot Rails](https://github.com/thoughtbot/factory_bot_rails): Provides fixtures replacement with a straightforward definition syntax.
- [Faker](https://github.com/faker-ruby/faker): A library for generating fake data.
- [RSpec Rails](https://github.com/rspec/rspec-rails): Testing framework for Rails.
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers): Simplifies testing Rails applications with RSpec.
- [SimpleCov](https://github.com/simplecov-ruby/simplecov): Code coverage analysis tool.
- [Rspec-Sidekiq](https://github.com/philostler/rspec-sidekiq): Testing framework for Sidekiq jobs.

**Security**
- [Brakeman](https://github.com/presidentbeef/brakeman): Static analysis tool for finding security vulnerabilities in Rails applications.
- [Bundler Audit](https://github.com/rubysec/bundler-audit): Scans your Gemfile for known vulnerabilities.

**Environment Management**
- [Dotenv Rails](https://github.com/bkeepers/dotenv): Loads environment variables from `.env`.

---

### Rake Tasks
Run the following rake task to check for security risks in your application:
```bash
bin/rails security:check
```
- This task runs tools like Brakeman and Bundler Audit to ensure your application is secure.

---

### Grape Resource Generator

This repository includes a custom Rails generator for creating Grape resources, entities, and corresponding RSpec tests. 
The generator helps streamline the process of adding new API endpoints to your application.

#### Usage

Generate a new Grape API resource:
```bash
rails generate grape_resource <ResourceName> field:type field:type
```
Replace <ResourceName> with the name of your resource (e.g., Book) and field:type with the attributes and types (e.g., title:string description:text).

#### Features
- Auto Mounting: Automatically mounts new resources in the API.
- Swagger Integration: Adds entities to Swagger models.
- Optional Model Generation: Prompts to generate the corresponding model.

#### Example
```bash
rails generate grape_resource Book title:string description:text
```

##### This will create
- A Grape resource in app/api/v1/resources/books.rb
- A Grape entity in app/api/v1/entities/book_entity.rb
- A corresponding RSpec test in spec/api/v1/resources/books_spec.rb
- The resource will be automatically mounted in the API
- The entity will be added to Swagger documentation
- The generator also gives you the option to create the User model with the specified attributes.

---

### Docker Setup
- If you prefer to run the application inside a Docker container, follow these steps:

1. **Build the Docker image:**
```bash
docker-compose build
```

2. **Start the Application and services:**
```bash
docker-compose up
```

3. **Stop the Application:**
```bash
docker-compose down
```

4. **Remove named Volumes:**
```bash
docker-compose down --volumes
```

---

### Contact
For questions or further information, feel free to reach out via [LinkedIn](https://www.linkedin.com/in/grigore-george-mihai-73981b86/).
