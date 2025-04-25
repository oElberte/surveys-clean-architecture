# Surveys - Clean Architecture Demo

A Flutter application demonstrating Clean Architecture principles in a simple surveys app for developers. This project was developed primarily as a learning exercise for Test-Driven Development (TDD), Clean Architecture, and other software engineering best practices.

## 📱 About

This application allows users to participate in surveys. It features authentication, survey listing, and result visualization. The primary focus is on implementing a robust architecture rather than complex features.

## 🏗️ Architecture

The project strictly follows Clean Architecture principles with clear separation of concerns:

- **Domain Layer**: Contains enterprise business rules, entities, and use case interfaces

  - `domain/entities`: Core business objects
  - `domain/usecases`: Business rules and use case definitions
  - `domain/helpers`: Domain-specific helper functions

- **Data Layer**: Implements domain use cases and contains repositories

  - `data/usecases`: Implementation of domain use cases
  - `data/models`: Data models that implement domain entities
  - `data/cache`: Local data storage logic
  - `data/http`: HTTP client implementations

- **Presentation Layer**: Contains presenters/controllers and presentation logic

  - `presentation`: Handles UI logic and state management

- **UI Layer**: Flutter widgets and pages

  - `ui/pages`: Application screens
  - `ui/components`: Reusable UI components
  - `ui/mixins`: UI behavior mixins
  - `ui/helpers`: UI-specific helper functions

- **Main Layer**: Composition root and factories

  - `main/factories`: Factory methods for dependency injection

- **Infra Layer**: Implementation details of external interfaces

  - `infra`: External services implementations

- **Validation Layer**: Input validation logic
  - `validation`: Form and input validation

## 🛠️ Development Practices

This application was built using:

- **Test-Driven Development (TDD)**: All features were developed following the Red-Green-Refactor cycle
- **Clean Architecture**: Strict separation of concerns with dependency rules
- **SOLID Principles**: Single Responsibility, Open-Closed, Liskov Substitution, Interface Segregation, Dependency Inversion
- **Design Patterns**: Various design patterns are implemented throughout the codebase
- **DRY (Don't Repeat Yourself)**: Code reuse and abstraction
- **KISS (Keep It Simple, Stupid)**: Simplicity in design
- **YAGNI (You Aren't Gonna Need It)**: Only implementing necessary features
- **SoC (Separation of Concerns)**: Clear boundaries between components
- **DDD (Domain-Driven Design)**: Focus on core domain logic
- **BDD (Behavior-Driven Development)**: Requirements specified as behaviors

## 🚀 Getting Started

The app is built with Flutter and uses FVM (Flutter Version Management) for version control:

- Flutter version: 2.5.1 (originally developed on 1.20.4)
- Dart SDK: >=2.12.0 <3.0.0 (with null safety)

### Prerequisites

- Flutter SDK
- FVM (recommended for version management)
- An IDE (VS Code, Android Studio, etc.)

### Installation

1. Clone the repository
2. Install dependencies:
   ```
   flutter pub get
   ```
3. Run the app:
   ```
   flutter run
   ```

### Running Tests

```
flutter test
```

## 🌟 ️Dependencies

- **State Management**: Provider and GetX
- **HTTP Client**: http package
- **Local Storage**: flutter_secure_storage and localstorage
- **UI Components**: carousel_slider
- **Testing**: mockito, faker, and network_image_mock

## 📂 Project Structure

The project follows a feature-based organization within the Clean Architecture layers. Requirements and specifications are documented in the `requirements` directory, including use cases, BDD specs, and checklists.

## 📚 Learning Resources

This project serves as a practical example of implementing Clean Architecture in Flutter. It's recommended to explore the codebase, tests, and requirements to understand how these principles are applied in practice.
