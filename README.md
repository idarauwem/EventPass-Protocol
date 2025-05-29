# EventPass Protocol

EventPass Protocol is a decentralized event ticketing platform built on Stacks blockchain, eliminating intermediaries and providing transparent, secure event access management.

## Features

- **Decentralized Ticketing**: Blockchain-based event tickets without middlemen
- **Organizer Control**: Direct event creation and revenue collection
- **Fraud Prevention**: Immutable ticket ownership and transfer records
- **Access Verification**: Cryptographic proof of event attendance rights

## Smart Contract Functions

### Event Management
- `create-event`: Set up new events with ticketing parameters
- `purchase-ticket`: Buy event tickets directly from organizers
- `get-event-info`: Retrieve event details and venue information
- `get-pass-holder`: Check current ticket holder
- `has-event-access`: Verify if someone has valid event access

## Getting Started

1. Clone this repository
2. Install [Clarinet](https://github.com/hirosystems/clarinet)
3. Run `clarinet check` to validate contracts
4. Deploy using Clarinet or Stacks CLI

## For Event Organizers

Organizers can create events by providing:
- Event title and venue details
- Access verification code
- Ticket price in STX tokens

## For Attendees

Attendees can purchase tickets directly, receiving blockchain-verified event passes for secure venue access.