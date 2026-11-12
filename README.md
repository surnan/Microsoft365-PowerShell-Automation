# Microsoft 365 & Entra ID PowerShell Automation

A collection of PowerShell scripts developed to streamline Microsoft 365 administration, investigate sign-in activity, review access, track managed devices, and generate audit-ready reports.

**Technologies:** PowerShell · Microsoft Graph · Microsoft Entra ID · Microsoft Intune · Exchange Online · Microsoft Teams

## Highlights

- **Identity and access:** Review user details, group membership, and account creation.
- **Security and devices:** Investigate sign-ins, device activity, and compliance.
- **Equipment inventory:** Generate an employee-level inventory of Intune-managed Windows and macOS devices, including serial numbers, assigned users, and ownership classification.
- **Mailbox and collaboration:** Audit inbox rules, delegated mailbox access, and Teams memberships.
- **Offboarding:** Flag disabled accounts with potentially unnecessary licenses or memberships.
- **Reporting:** Display results in the console and export timestamped CSV files.

## Script directory

| Script | Purpose |
| --- | --- |
| [Get-EmployeeLaptopInventory.ps1](Get-EmployeeLaptopInventory.ps1) | Employee laptop inventory with serial numbers, Intune ownership, and personal-device indicators |
| [Get_EnabledUsersLastSignInDevice.ps1](Get_EnabledUsersLastSignInDevice.ps1) | Recent successful sign-ins and devices for enabled users |
| [Get_EntraDevices.ps1](Get_EntraDevices.ps1) | Device ownership, activity, and Intune compliance |
| [Get_EntraGroup_Members.ps1](Get_EntraGroup_Members.ps1) | Group properties and members |
| [Get_EntraUser_Details.ps1](Get_EntraUser_Details.ps1) | User details and direct or nested group memberships |
| [Get_EntraUser_LastSignIn_Device.ps1](Get_EntraUser_LastSignIn_Device.ps1) | Sign-in and device information across enabled and disabled accounts |
| [Get_EntraUsersByCreatedDate.ps1](Get_EntraUsersByCreatedDate.ps1) | Accounts created in a specified date range |
| [Get_OffboardingExceptions.ps1](Get_OffboardingExceptions.ps1) | Disabled-account license and membership exceptions |
| [Get_TeamsUserMemberships.ps1](Get_TeamsUserMemberships.ps1) | Teams roles and channel memberships |
| [Get_UserInboxRules.ps1](Get_UserInboxRules.ps1) | Inbox rules, forwarding, and redirects |
| [Get_UserLoginActivity.ps1](Get_UserLoginActivity.ps1) | Successful user sign-in events |
| [Get_UserMailboxPermissions.ps1](Get_UserMailboxPermissions.ps1) | Mailbox access granted to a user |

## Script details

### Entra ID — Identity and groups

<details>
<summary><strong>Get_EntraUser_Details.ps1</strong> — User and group audit</summary>

**Purpose:** Retrieve user account properties and direct or nested group membership relationships.

**Input:** User email address (primary or alias).

**Output:** Display name, UPN, primary email, job title, account creation time, aliases, group membership count, group names and types, and direct/nested membership information.

**Use case:** Access reviews and user-permission investigations.
</details>

<details>
<summary><strong>Get_EntraGroup_Members.ps1</strong> — Group membership audit</summary>

**Purpose:** Retrieve a group's properties and its members.

**Input:** Group email address (primary or alias).

**Output:** Group name, primary email, group type, mail/security-enabled status, aliases, and member display names, UPNs, primary emails, and types (user/group).

**Use case:** Group membership validation and access reviews.
</details>

<details>
<summary><strong>Get_EntraUsersByCreatedDate.ps1</strong> — Account creation audit</summary>

**Purpose:** Find user accounts created during a specified period.

**Input:** Start and end dates in `MM-DD-YYYY` format; blank values default to today.

**Output:** Display name, UPN, job title, and account creation date/time.

**Use case:** Onboarding audits and account inventory.
</details>

### Entra ID & Intune — Devices and sign-ins

<details>
<summary><strong>Get-EmployeeLaptopInventory.ps1</strong> — Employee equipment inventory</summary>

**Purpose:** Export a read-only employee-level inventory of Intune-managed Windows and macOS devices for hardware tracking, offboarding, and equipment handover.

**Input:** No required prompts. By default, includes devices with an assigned user that checked in within the last 90 days. Optional parameters:

- `-IncludeStale` — Include devices regardless of last Intune check-in.
- `-IncludeUnassigned` — Include devices without an assigned user.
- `-StaleDays 90` — Change the inactivity cutoff (in days) when `-IncludeStale` is not used.
- `-OutputFolder "C:\Reports"` — Override the default CSV destination.

**Output:** Employee name, email address, equipment type, manufacturer, model, serial number, device name, operating system, last check-in, Intune ownership, personal-device indicator, Intune/Entra device IDs, and enrollment date. Displays a summary in the console and exports a timestamped CSV named `Employee_Laptop_Inventory_yyyyMMdd_HHmmss.csv` **to the same directory as the `.ps1` script** by default.

**Example:**

```powershell
.\Get-EmployeeLaptopInventory.ps1

# Include stale and unassigned devices
.\Get-EmployeeLaptopInventory.ps1 -IncludeStale -IncludeUnassigned
```

**Requirements:** PowerShell 7 or later; Microsoft Graph PowerShell modules (`Microsoft.Graph.Authentication` and `Microsoft.Graph.DeviceManagement`); delegated scopes `DeviceManagementManagedDevices.Read.All` and `User.Read.All`. The script checks for missing modules and requests authentication/scopes as needed.

**Use case:** Employee laptop asset inventories, hardware handover, and reconciling assigned devices during offboarding.

**Limitations:** The script assumes Windows/macOS managed devices are laptops; Intune alone does not reliably distinguish laptops from desktops. Ownership classifications do **not** establish whether a person uses an unenrolled personal device for work. It does not inventory phones or peripherals, and devices not enrolled in Intune are not included. Confirm device models and physical assignments before treating the CSV as a final asset register.
</details>

<details>
<summary><strong>Get_EntraDevices.ps1</strong> — Device inventory</summary>

**Purpose:** Review Entra ID device information and status.

**Input:** Select owner, days inactive, or device name.

**Output:** User display name, device name, user-account enabled status, Intune compliance status, and days since last activity.

**Use case:** Device inventory, inactivity checks, and compliance reviews.
</details>

<details>
<summary><strong>Get_EnabledUsersLastSignInDevice.ps1</strong> — Enabled-user sign-ins</summary>

**Purpose:** Retrieve recent successful sign-in and device information for enabled accounts.

**Input:** Number of days to query.

**Output:** Display name, last successful sign-in timestamp, device name, and operating system.

**Use case:** Authentication and device activity reviews for active accounts.
</details>

<details>
<summary><strong>Get_EntraUser_LastSignIn_Device.ps1</strong> — User sign-ins</summary>

**Purpose:** Review recent successful sign-ins across enabled and disabled user accounts.

**Input:** Number of days to query.

**Output:** Display name, last successful sign-in timestamp, device name, and operating system.

**Use case:** Broader authentication investigations and account reviews.
</details>

<details>
<summary><strong>Get_UserLoginActivity.ps1</strong> — Login investigation</summary>

**Purpose:** Retrieve successful login events for a specified account.

**Input:** User email address (primary or alias), plus number of days to query.

**Output:** Timestamp, application, IP address, application type, and operating system.

**Use case:** Investigate user authentication patterns.
</details>

### Exchange Online — Mailboxes

<details>
<summary><strong>Get_UserInboxRules.ps1</strong> — Inbox rule audit</summary>

**Purpose:** Review mailbox inbox rules, including mail forwarding and redirection.

**Input:** User email address (primary or alias).

**Output:** Rule name, enabled status, priority, forwarding destination, redirect destination, and description.

**Use case:** Mail-flow troubleshooting and suspicious-rule investigations.
</details>

<details>
<summary><strong>Get_UserMailboxPermissions.ps1</strong> — Mailbox access audit</summary>

**Purpose:** Identify mailboxes accessible to a selected user.

**Input:** User email address (primary or alias).

**Output:** Security group memberships, accessible mailboxes, and whether access is direct/inherited or user/group assigned.

**Use case:** Delegated-access reviews and permission audits.
</details>

### Microsoft Teams — Collaboration

<details>
<summary><strong>Get_TeamsUserMemberships.ps1</strong> — Teams and channels</summary>

**Purpose:** Retrieve a user's Microsoft Teams memberships and channel information.

**Input:** User email address (primary or alias).

**Output:** Team name, team role (owner/member), and team/channel names.

**Use case:** Onboarding checklists and Teams access documentation.
</details>

### Account lifecycle — Offboarding

<details>
<summary><strong>Get_OffboardingExceptions.ps1</strong> — Offboarding exceptions</summary>

**Purpose:** Identify disabled accounts retaining licenses, email addresses, or group memberships that may warrant review.

**Input:** None.

**Output:** Display name, UPN, email-address count, group-membership count, license count, and enabled status.

**Use case:** Offboarding quality checks and potential license recovery.
</details>

> **Reporting:** Scripts are intended to produce console output and timestamped CSV reports. `Get-EmployeeLaptopInventory.ps1` saves its CSV beside the script by default. Verify the precise columns and behavior in each script before running it.

## Requirements

- Windows PowerShell 5.1 or PowerShell 7, depending on the script. **`Get-EmployeeLaptopInventory.ps1` requires PowerShell 7 or later.**
- Access to the relevant Microsoft 365 tenant and appropriate permissions.
- Modules as required by the script, potentially including **Microsoft Graph PowerShell SDK**, **ExchangeOnlineManagement**, and **MicrosoftTeams**.

Check each script for its exact PowerShell version, module dependencies, and Graph/API permissions; requirements vary.

## Getting started

Clone the repository:

```powershell
git clone https://github.com/surnan/PS_public.git
cd PS_public
```

Run an example script from the repository directory:

```powershell
.\Get_EntraUser_Details.ps1
```

Or generate an employee equipment inventory:

```powershell
.\Get-EmployeeLaptopInventory.ps1
```

Follow script prompts and sign in with an account authorized to access the requested data.

## Output and security

Reports can include account identifiers, membership details, device information, serial numbers, IP addresses, and authentication events. Protect exported CSV files, avoid committing sensitive data or credentials, and review scripts in a test environment before production use.

## About

This repository is part of my IT administration and automation portfolio. These scripts address recurring operational tasks encountered while administering Microsoft 365 environments, with an emphasis on **identity management, security auditing, device inventory, access reviews, and repeatable reporting**.

**Author:** Suresh Nandlall · [GitHub profile](https://github.com/surnan)
