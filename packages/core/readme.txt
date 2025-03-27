core/
│── lib/
│   ├── src/
│   │   ├── data/                # Data layer (Repositories, DTOs, API sources)
│   │   ├── domain/              # Business logic layer (Entities, Use Cases, Repository Contracts)
│   │   ├── presentation/        # UI (Widgets, Screens, BLoCs)
│   │   ├── shared/              # Common utilities, constants, theme, localization
│   │   ├── di/                  # Dependency injection (GetIt or Injectable)
│   │   ├── error/               # Failure handling
│   │   ├── networking/          # API Clients, Dio Setup
│   │   ├── utils/               # Helper functions, extensions
│   ├── core.dart                # Entry point for core functionalities

lib/
├── core/              # Shared utilities, services, constants, themes
├── features/
│   ├── auth/
│   │   ├── data/      # API calls, DTOs, data sources
│   │   ├── domain/    # Use cases, business rules
│   │   ├── presentation/ # UI (Screens, Widgets, BLoCs)
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   ├── presentation/
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   ├── presentation/
