
# HelloID-Task-SA-Target-ServiceNow-IncidentCreate

## Prerequisites

Before using this snippet, verify you've met with the following requirements:

- [ ] User defined variables: `serviceNowBaseUrl`, `serviceNowUserName` and `serviceNowPassword` created in your HelloID portal.

## Description

This code snippet executes the following tasks:

1. Define a hash table `$formObject`. The keys of the hash table represent the properties to create an incident, while the values represent the values entered in the form.

> To view an example of the form output, please refer to the JSON code pasted below.

```json
{
    "caller_id": "johndoe",
    "urgency": "1",
    "description": "Example inident",
    "short_description": "Example"
}
```

> :exclamation: It is important to note that the names of your form fields might differ. Ensure that the `$formObject` hashtable is appropriately adjusted to match your form fields.

2. Verify that a `sys_user` with `caller_id` _johndoe_ exists.
3. If the caller exist, create an incident.
