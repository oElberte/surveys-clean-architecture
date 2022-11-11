Feature: Login
As a client
I want to access my account and remain logged
So I can see and answer surveys quickly

Scenario: Valid credentials
Given that the client provided valid credentials
When ask to login
Then the system must send the user to the search screen
And keep the user connected

Scenario: Invalid credentials
Given that the client provided invalid credentials
When ask to login
Then the system must return an error message