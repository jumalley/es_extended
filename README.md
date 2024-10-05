# ESX Paycheck Edit : Using multipliers based on the player group.

## Overview
The `paycheck.lua` script is part of the ESX framework for GTA V FiveM, located in the `esx_core/[core]/es_extended/server` directory. This script handles the paycheck system for players within the game. It calculates and distributes salaries and government aid based on player roles and groups, providing notifications for each transaction.

## File Path
The script can be found at the following path:

```
esx_core/[core]/es_extended/server/paycheck.lua
```

## Functionality
- **Salary Distribution**: The script automatically distributes salaries to players at defined intervals. 
- **Government Aid**: Players with specific job grades can receive government aid based on their role.
- **Group Multipliers**: Different player groups (e.g., VIP, Moderator, Admin, Developer) have multipliers that affect the amount of money they receive.
- **Notifications**: Players receive notifications for any salary or government aid received, including the amount and relevant multipliers.

### Key Functions
1. **`getMultiplierAndIcon(player)`**: 
   - Retrieves the multiplier, icon, and color based on the player's group.
   - Supports various groups like "vip", "moderator", "admin", and "dev".

2. **`StartPayCheck()`**: 
   - Initializes a loop that checks and distributes paychecks at defined intervals specified in `Config.PaycheckInterval`.
   - Checks player salaries and distributes the correct amounts based on their job and group.

### Usage
To integrate this script into your ESX server:
1. Ensure that the `esx_core` framework is properly installed and running.
2. Place the `paycheck.lua` file in the specified directory (`esx_core/[core]/es_extended/server/`).
3. Make sure to configure the payment intervals in the related configuration file to meet your server's requirements.

### Note
Make sure to have the necessary dependencies, such as `esx_notify`, installed and properly configured to display notifications to players.
