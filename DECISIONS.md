# CatalogHub – Engineering Decisions

## 1. Overview

CatalogHub is a product catalogue application developed using SwiftUI for iOS and Node.js with TypeScript for the backend.

The implementation focuses on delivering the required product discovery and enquiry workflows while maintaining a clear separation of responsibilities between the iOS application, backend services and external integrations.

The primary engineering priorities were:

- Clear separation of concerns.
- Maintainable and testable code.
- Centralized product data access through the backend.
- Reliable handling of asynchronous operations.
- Validation of critical user workflows.
- Simple local setup for reviewers.

## 2. Architecture Decisions

### 2.1 iOS Architecture

**Decision:** Use MVVM with a layered architecture, Repository Pattern and Dependency Injection.

**Reasoning:**

- SwiftUI Views are responsible for presenting the user interface.
- ViewModels manage presentation state and user interactions.
- The Domain layer contains business entities and repository contracts.
- The Data layer implements repository contracts and communicates with the backend.
- Dependency Injection makes dependencies explicit and allows mock implementations to be used during testing.

This separation keeps presentation, business logic and networking responsibilities independent.

It also allows individual components to be modified or tested without requiring changes throughout the application.

### 2.2 Backend Architecture

**Decision:** Use Node.js, TypeScript and Express with separate routes, controllers, services and providers.

**Reasoning:**

- Routes define API endpoints.
- Controllers handle incoming HTTP requests and construct responses.
- Services contain application-level business logic.
- Providers handle external integrations such as Fake Store API and email delivery.

This structure separates HTTP handling from business logic and external dependencies.

It also makes it easier to replace an external provider without significantly changing the rest of the application.

## 3. API and Data Decisions

### 3.1 Backend as the API Gateway

**Decision:** All product catalogue requests from the iOS application go through the Node.js backend.

**Reasoning:**

- The iOS application does not communicate directly with Fake Store API.
- The backend controls how external product data is exposed.
- Business rules such as featured-product selection, category filtering and search are handled centrally.
- The backend provides a consistent API contract to the iOS application.

This approach also provides a foundation for introducing another product data provider in the future.

### 3.2 Featured Products

**Decision:** Select the five highest-rated products for the home screen.

**Assumption:** The assignment requires five featured products selected by the entrepreneur. Since no separate manually curated product list was provided, product ratings are used as the selection criterion.

**Reasoning:**

- Ratings provide a simple and understandable selection mechanism.
- Selection logic remains centralized in the backend.
- The iOS application receives an already selected list of featured products.

A manually configurable featured-product list could be introduced if business requirements change.

### 3.3 Category Products

**Decision:** Display the five highest-rated products separately from the remaining products in each category.

**Reasoning:**

- Users can quickly discover highly rated products.
- The remaining products are still accessible.
- Product selection and categorization are handled consistently.

The five highest-rated products are determined using the rating values returned by the external product API.

### 3.4 Product Search

**Decision:** Perform product search through the backend and introduce a 400 ms debounce in the iOS application.

**Reasoning:**

- Avoid unnecessary API requests while users are typing.
- Keep search matching logic centralized in the backend.
- Reduce unnecessary network activity.
- Prevent outdated search responses from replacing newer results.

The iOS application also handles cancellation of pending search tasks and ignores stale responses.

Search results are returned by the backend based on text matching against product information.

## 4. Enquiry and Email Decisions

**Decision:** Handle enquiry submissions through a dedicated backend endpoint.

**Implementation approach:**

1. The user enters contact details and an enquiry message in the iOS application.
2. The iOS application validates required fields.
3. The enquiry is submitted to the backend using an HTTP POST request.
4. The backend validates the submitted information.
5. Nodemailer sends the enquiry details to the configured sales email address.
6. The backend returns the submission result.
7. The iOS application displays a success confirmation after receiving a successful response.

**Reasoning:**

- Email credentials must not be stored in the iOS application.
- Email delivery belongs on the backend.
- The backend provides a centralized location for request validation.
- The dedicated endpoint keeps enquiry functionality separate from product catalogue operations.

SMTP credentials are maintained through backend environment variables and excluded from source control.

Email delivery depends on valid SMTP configuration and the availability of the configured email provider.

## 5. Networking and Error Handling Decisions

**Decision:** Use a shared API client in the iOS application for backend communication.

**Reasoning:**

- Centralizes HTTP request execution.
- Avoids duplicating networking logic across repositories.
- Provides consistent JSON encoding and decoding.
- Handles unsuccessful HTTP responses.
- Supports asynchronous networking through Swift Concurrency.

The repository implementation translates backend response models into domain entities, keeping external API response structures separate from the application domain.

The ViewModels maintain loading, success and error states so the UI can represent the outcome of asynchronous operations.

## 6. Testing Decisions

**Decision:** Use XCTest for unit testing and XCUITest for UI testing.

### Unit Testing

Mock repositories are used to test ViewModels independently of the actual backend.

The tests cover important scenarios such as:

- Successful featured-product loading.
- Product loading failures.
- Successful search results.
- Empty search queries.
- Search failures.
- Successful enquiry submission.
- Empty enquiry fields.
- Invalid email input.
- Enquiry submission failures.

### UI Testing

UI tests validate important application workflows and screen interactions.

The tested areas include:

- Application launch.
- Main tab navigation.
- Search screen visibility.
- Enquiry form visibility.
- Product navigation to the details screen.

**Reasoning:**

- Unit tests validate presentation logic independently of external services.
- Mock repositories make test scenarios predictable.
- UI tests validate critical user-facing interactions.
- Separating unit and UI tests helps identify issues at different application layers.

## 7. Assumptions and Simplifications

The following assumptions and simplifications were made during implementation:

1. Fake Store API is used as the external product catalogue source.
2. Product prices, descriptions, images and ratings are displayed using the values provided by the external API.
3. Since no manually curated featured-product list was provided, product ratings are used to determine featured products.
4. The five highest-rated products are highlighted separately within each category.
5. Product search matching is handled by the backend.
6. Email delivery depends on valid SMTP configuration.
7. Local development uses a locally running Node.js backend.
8. Authentication, user accounts, shopping cart and payment processing are outside the assignment scope.
9. The application is designed to demonstrate the required product discovery and enquiry workflows rather than a complete e-commerce platform.

## 8. Extensibility and Future Improvements

The current implementation provides a foundation for further development.

If additional development time were available, the following improvements could be considered:

1. **Pagination:** Introduce pagination to support larger product catalogues and reduce the amount of data returned in a single request.
2. **Caching:** Introduce persistent caching to improve performance and support offline access.
3. **API Integration Tests:** Add more comprehensive tests covering backend endpoints and external provider interactions.
4. **Logging and Monitoring:** Introduce structured logging and monitoring to improve debugging and operational visibility.
5. **Email Reliability:** Move email delivery to a background job or message queue if enquiry volume increases.
6. **Configuration Management:** Introduce production-ready environment configuration and secure secret management.
7. **CI/CD:** Introduce GitHub Actions to automate backend builds, iOS builds and automated test execution.
8. **Featured Product Management:** Replace rating-based selection with a configurable list if the business requires manual product curation.

These improvements are intentionally kept outside the current implementation scope.

## 9. Next-Day Development Plan

If an additional development day were available, the development priorities would be:

- Review the existing architecture and simplify unnecessary complexity.
- Expand automated test coverage for critical application and backend scenarios.
- Improve API validation and error handling.
- Evaluate pagination and caching requirements.
- Review the local setup process and documentation.
- Introduce CI/CD automation.
- Review the implementation against the assessment acceptance criteria.

The priority would be to improve reliability and maintainability before introducing additional product features.

## 10. Trade-offs

The implementation prioritizes a working end-to-end solution with clear separation of responsibilities over introducing complex infrastructure.

The main trade-offs are:

- **External product provider:** Fake Store API keeps product integration simple but introduces a dependency on an external service.
- **Rating-based featured selection:** Provides a deterministic selection mechanism but does not support manual business curation.
- **SMTP-based email delivery:** Keeps the enquiry workflow straightforward but depends on external email provider availability.
- **Local backend:** Makes the solution easy to run during evaluation but requires the backend to be running while using the iOS simulator.
- **Layered architecture:** Introduces some additional structure compared with a minimal implementation, but improves separation of responsibilities and testability.

Overall, the implementation aims to demonstrate sound engineering decisions, a maintainable structure and the required end-to-end functionality within the assignment's time constraints.
