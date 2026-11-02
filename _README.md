# PowerShell Scripts
## Exchange 

* Get_EnabledUsersLastSignInDevice.ps1
  - Prompt for Input: Number of days to Query
  - Output: console & csv file appended with timestamp
      - User DisplayName
      - Last Sign-In timestamp
      - Device Name
      - Operating System
  - Purpopse: 
      - Retrieve succesful login details for all enabled users

* Get_EntraDevices.ps1
  - Prompt for Input: Choose between: {Owner, Days Inactive, Device Name}
  - Output: console & csv file appended with timestamp
      - User DisplayName
      - Device Name
      - Boolean: User Account Enabled?
      - Boolean: Is device Intune compliant?
      - Days since last login
  - Purpopse: 
      - Retrieve all devices that are being used for authentication (non-mobile)

* Get_EntraGroup_Members.ps1
  - Prompt for Input: group email address.  Can be primary or secondary.
  - Output: console & csv file appended with timestamp
      - Display Name
      - Primary Email Address
      - Group Type: Distribution, Security, etc...
      - Boolean: Mail-Enabled?
      - Boolean: Security-Enabled?
      - Every Alias Email Address
      - Table with Every Member's:
          - Display Name
          - UPN: Login Email (entra)
          - Primary Email Address
          - Member Type: User or Group
  - Purpose: Retrieve every member of group

* Get_EntraUser_Details.ps1
  - Prompt for Input: user email address.  Can be primary or secondary.
  - Output: console & csv file appended with timestamp
      - Display Name
      - UPN
      - Primary Email Address
      - Job Title
      - Timestamp for Account Creation
      - Every Alias Email Address
      - Group Membership Count
      - Table of every Group Membership:
          - Display Name
          - Group Type
          - How is membership obtained?  Directly or via Nested

* Get_EntraUser_LastSignIn_Device.ps1
  - Prompt for Input: Number of days to Query
  - Output: console & csv file appended with timestamp
      - User DisplayName
      - Last Sign-In timestamp
      - Device Name
      - Operating System
  - Purpopse: 
      - Retrieve succesful login details for all users (enabled & disabled)

* Get_EntraUsersByCreatedDate.ps1
  - Prompt for Input: Start Date in (MM-DD-YYYY) format
      - Blank = today
  - Prompt for Input: End Date in (MM-DD-YYYY) format
      - Blank = today
  - Output: console & csv file appended with timestamp
      - Display in table:
          - Display Nam
          - UPN
          - Job Title
          - Account's creation date/time
  - Purpose: 
        - Retrieve all user accounts created within specified time period

* Get_OffboardingExceptions.ps1
  - No Prompt
  - Output: console & csv file appended with timestamp
      - Display in table:
          - Display Name
          - UPN
          - Count of Email addresses still on account
          - Count of Group memberships
          - Count of licenses
          - Boolean: enabled?
              -- just confirming acc't is disabled
  - Purpose: 
          - Any disabled user accounts tying up extra licenses, improper group memberships, unnecessary group memberships?

* Get_TeamsUserMemberships.ps1
  - Prompt for Input: email address (Primary or secondary email address)
  - Output: console & csv file appended with timestamp
      - Display in table:
          - TeamName
          - Team Role (owner, member)
      - Display in table:
          - Team Name
          - Channel Name
      - Purpose:
          - Getting all the Teams information for a user.  Makes it easier to have checklist to assign to new colleague joining their department

* Get_UserInboxRules.ps1
  - Prompt for Input: email address (Primary or secondary email address)
  - Output: console & csv file appended with timestamp
      - Display in table for each rule:
          - Name
          - Boolean: Enabled?
          - Priority
          - Forwarding To Email Address
          - Redirect To Email Address
          - Description
      - Purpose:
          - Get all the rules on user's mailbox

* Get_UserLoginActivity.ps1
  - Prompt for Input: email address (Primary or secondary email address)
  - Prompt for Input: How many days deep to dig into logs?
  - Output: console & csv file appended with timestamp
      - Display in table, each succesful login:
          - Timestamp
          - Application
          - IP Address
          - Appliction Type
          - Operating System
  - Purpose:
      - Retrieve all the succesful login attempts for a user account

* Get_UserMailboxPermissions.ps1
  - Prompt for Input: email address (Primary or secondary email address)
  - Output: console & csv file appended with timestamp
      - Retrieve all security group memberships
      - Display in table, each mailbox user has rights to:
          - Mailbox Email address
          - Access granted directly or inherited
          - Access granted at user account or at group level
  - Purpose:
      - What mailboxes can user access?