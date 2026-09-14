# ConsentApp - Incremental Consent Proof of Concept

## Purpose
ConsentApp is a proof-of-concept (POC) application designed to demonstrate the implementation of "incremental consent." It allows applications (e.g., Medicaid eligibility systems) to capture a user's signature and a token identifier to authorize access to specific data points (like education records) in a modular, step-by-step fashion.

## Demo
A video demonstration of the application in action is available here: [demo.mov](public/demo.mov)

## Key Features

### 1. Signature Capture
A custom Stimulus JS controller provides a canvas-based signature pad. It supports both mouse and touch input, converting the drawing into a PNG file for storage via Rails Active Storage.

### 2. Third-Party Embedding (Demo)
The application is built to be embedded within other systems (e.g., a Medicaid application). 
- **Iframe Integration:** The consent form can be served in an `embedded` mode that adjusts headers (CSP, X-Frame-Options) for secure cross-origin usage.
- **Cross-Window Communication:** Uses `postMessage` to notify the host application upon successful consent submission, allowing the host to dynamically update its UI (e.g., enabling a "Proceed" button).

### 3. Secured API Retrieval
Consents can be retrieved programmatically via a REST API:
- `GET /api/v1/consents/:token_id`
- Secured by a static API token (`X-Api-Token` header).
- Returns metadata and a link to the stored signature.

### 4. Automated Delivery (SFTP)
The app includes a background job (`SftpConsentJob`) that can automatically transfer captured signatures to a remote server. 
- **Configurable:** Enabled/disabled via environment variables.
- **Extensible:** While SFTP is implemented as a demonstration, the architecture allows for other delivery methods (e.g., S3, Webhooks, Cloud Storage, or direct API integration with government systems).

### 5. Admin Management
A secured admin dashboard allows staff to:
- Search for consents by Token ID.
- View captured signatures.
- Mark specific consents as invalid (tracking invalidation timestamps).

## Extensibility
This POC emphasizes that the delivery layer is decoupled from the capture layer. While SFTP is currently implemented, the `after_create_commit` hooks and Active Job infrastructure make it trivial to add new delivery targets, such as:
- Sending to a messaging queue (RabbitMQ/Kafka).
- Pushing to a FHIR-compliant endpoint.
- Direct database-to-database synchronization.

## Getting Started

### Prerequisites
- Ruby 3.x
- PostgreSQL

### Setup
1. `bundle install`
2. `bin/rails db:prepare`
3. `bin/rails s`

### Testing
Run the comprehensive suite (including system tests for embedding and admin features):
`bin/rails test:all`
