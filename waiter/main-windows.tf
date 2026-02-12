resource "terraform_data" "waiter_windows" {
  count = var.host_os == "windows" ? 1 : 0

  triggers_replace = [
    var.instance_id,
    var.expected_value
  ]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]

    environment = {
      AUTH_TOKEN = data.google_client_config.current.access_token
      PROJECT    = var.project_id
      ZONE       = var.zone
      INSTANCE   = var.instance_name
      NAMESPACE  = var.attribute_namespace
      KEY        = var.attribute_key
      VALUE      = var.expected_value
      TIMEOUT    = var.timeout_seconds
    }

    command = <<EOT
      $Url = "https://compute.googleapis.com/compute/v1/projects/$env:PROJECT/zones/$env:ZONE/instances/$env:INSTANCE/getGuestAttributes?queryPath=$env:NAMESPACE/$env:KEY"
      $Headers = @{ "Authorization" = "Bearer $env:AUTH_TOKEN" }
      
      # Calculate end time based on the timeout variable
      $EndTime = (Get-Date).AddSeconds([int]$env:TIMEOUT)

      Write-Host "Waiting for guest attribute '$env:NAMESPACE/$env:KEY' = '$env:VALUE' on instance '$env:INSTANCE'..."

      while ((Get-Date) -lt $EndTime) {
        try {
          # -ErrorAction Stop is crucial to catch 404s (attribute not created yet)
          $Response = Invoke-RestMethod -Uri $Url -Headers $Headers -Method Get -ErrorAction Stop
          
          # The API returns a JSON object. We verify if the value matches.
          # Structure: { queryValue: { items: [ { value: "..." } ] } }
          $Match = $Response.queryValue.items | Where-Object { $_.value -eq $env:VALUE }
          
          if ($Match) {
            Write-Host "Success: Found guest attribute."
            exit 0
          }
        }
        catch {
          # If the attribute doesn't exist yet, the API returns 404. We catch and ignore it.
          Write-Host "Waiting... (Attribute not found or API error)"
        }

        Start-Sleep -Seconds 10
      }

      Write-Error "Timeout: Guest attribute was not found within $env:TIMEOUT seconds."
      exit 1
    EOT
  }
}