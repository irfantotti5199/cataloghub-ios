# CatalogHub – AI Usage Documentation

## 1. AI Tools Used

ChatGPT was used as a supporting tool during selected development, troubleshooting and documentation activities.

**Tool used:**

- ChatGPT – GPT-6: Technical reference, backend implementation guidance, troubleshooting, testing approaches and documentation assistance.

## 2. Areas Where AI Assisted

### Backend Development

- Guidance on Express route and controller organization.
- TypeScript implementation and compilation troubleshooting.
- Fake Store API integration guidance.
- Request validation and error handling.
- Nodemailer SMTP configuration and email integration.

### Testing and Quality

- Suggestions for XCTest test scenarios.
- Mock repository testing examples.
- UI testing scenario suggestions.
- Assistance investigating UI test failures.
- CI/CD workflow planning.

### Documentation

- README structure and setup instructions.
- Engineering decisions documentation.
- AI usage documentation.

## 3. Representative Prompts

Examples of prompts used during development:

1. "Explain how to structure a Node.js TypeScript backend using Express."
2. "How can I integrate Nodemailer with Gmail SMTP to send enquiry emails?"
3. "How should I validate API request payloads?"
4. "Help me understand XCTest using mock repositories."
5. "How can I configure GitHub Actions for automated testing?"

## 4. Validation and Review

AI-generated suggestions were reviewed and validated through actual development activities.

Validation included:

- Running the backend TypeScript build.
- Testing backend API endpoints using HTTP requests.
- Verifying actual enquiry email delivery.
- Testing application functionality using the iOS simulator.
- Running unit and UI tests.
- Reviewing implementation suggestions against the actual project structure.

Suggestions were not accepted without reviewing their correctness and applicability.

## 5. Issues Identified During AI Assistance

Some AI-generated suggestions required correction or further investigation.

Examples:

### UI Test Element Identification

Initial UI test queries could not locate the featured product cards.

The XCTest accessibility hierarchy was inspected using `app.debugDescription`. This revealed that the application was displaying a backend connection error rather than the expected product list because the backend was not running.

The backend was started and the API response was verified before rerunning the test.

### API Client Implementation

An incorrect URL handling approach was identified during implementation. Compiler feedback was used to investigate and correct the issue.

### Search Request Handling

Search request cancellation and stale-response handling required additional review to ensure that older search responses did not overwrite newer results.

These examples demonstrate the importance of validating AI suggestions using compiler output, application behavior and automated tests.

## 6. Developer Responsibility

AI was used as a supporting reference and development assistant, not as a replacement for engineering judgment.

The developer is responsible for:

- Understanding the submitted implementation.
- Making architectural and technical decisions.
- Reviewing and validating code.
- Debugging implementation issues.
- Running and verifying tests.
- Ensuring the final submission meets the assessment requirements.

All submitted code and design decisions must be understood and explainable by the developer.

## 7. Limitations

- AI suggestions may require adjustments to match the actual project structure and compiler requirements.
- Generated test cases must be executed and verified.
- Security-sensitive configuration requires independent review.
- External API and email provider availability can affect runtime behavior.
- AI-generated recommendations do not replace technical validation or engineering judgment.

## 8. Agent Instruction Files

No dedicated AI agent instruction files were created or used during this project.



