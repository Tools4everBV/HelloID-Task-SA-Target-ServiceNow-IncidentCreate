# HelloID-Task-SA-Target-ServiceNow-IncidentCreate
##################################################
# Form mapping
$formObject = @{
    caller_id         = $form.caller_id
    urgency           = $form.Urgency
    description       = $form.Description
    short_description = $form.ShortDescription
}

try {
    Write-Information "Executing ServiceNow action: [CreateResource] for: [$($formObject.DisplayName)]"
    Write-Information "Validating if caller: [$($formObject.caller_id)] exists"
    $splatParams = @{
        Uri     = "$serviceNowBaseUrl/api/now/table/sys_user?sysparm_query=name=$($formObject.caller_id)^ORemail=$($formObject.caller_id)^ORsys_id=$($formObject.caller_id)^ORuser_name=$($formObject.caller_id)"
        Method  = 'GET'
        Headers = @{
            'Authorization' = "Basic $([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${serviceNowUserName}:${serviceNowPassword}")))"
        }
    }
    $caller = Invoke-RestMethod @splatParams
    if ($caller.result.count -gt 1){
        throw "Multiple callers found with caller_id: [$($formObject.caller_id)]"
    }

    Write-Information "Creating incident for caller: $($formObject.caller_id)"
    $splatParams = @{
        Uri         = "$serviceNowBaseUrl/api/now/table/incident"
        Method      = 'POST'
        Body        = $formObject | ConvertTo-Json
        ContentType = 'application/json'
        Headers = @{
            'Authorization' = "Basic $([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${serviceNowUserName}:${serviceNowPassword}")))"
        }
    }
    $incident = Invoke-RestMethod @splatParams
    $auditLog = @{
        Action            = 'CreateResource'
        System            = 'ServiceNow'
        TargetIdentifier  = $incident.result.sys_id
        TargetDisplayName = $incident.result.number
        Message           = "ServiceNow action: [CreateResource] for: [$($formObject.caller_id)] executed successfully"
        IsError           = $false
    }
    Write-Information -Tags 'Audit' -MessageData $auditLog
    Write-Information "ServiceNow action: [CreateResource] for: [$($formObject.caller_id)] executed successfully"
} catch {
    $ex = $_
    $errorDetails = $ex.ErrorDetails.Message | ConvertFrom-Json
    $auditLog = @{
        Action            = 'CreateResource'
        System            = 'ServiceNow'
        TargetIdentifier  = ''
        TargetDisplayName = $formObject.short_description
        Message           = "Could not execute ServiceNow action: [CreateResource] for: [$($formObject.caller_id)], error: $($errorDetails.error.message), detail: $($errorDetails.error.detail), status: $($errorDetails.status)"
        IsError           = $true
    }
    Write-Information -Tags "Audit" -MessageData $auditLog
    Write-Error "Could not execute ServiceNow action: [CreateResource] for: [$($formObject.caller_id)], error: $($errorDetails.error.message), detail: $($errorDetails.error.detail), status: $($errorDetails.status)"
}
###########################################
