# Login Presenter

> ## Regras
1. ✅ Validate email with Validation
2. Notify the emailErrorStream with the Validation result
3. Notify the isFormValidStream after validating the email
4. Validate password with Validation
5. Notify the passwordErrorStream with the Validation result
6. Notify the isFormValidStream after validating the password
7. For the form to be valid all the error streams must be null and all obligatory fields must not be empty
8. Call the Authentication with the correct email and password
9. Notify the isLoadingStream as true before calling the Authentication
10. Notify the isLoadingStream as false in the Authentication
11. Notify the mainErrorStream in case Authentication returns a DomainError
12. ⛔️ Keep Account in cache in case of success
13. ⛔️ Redirect user to polls page in case of success
14. Close all streams in dispose