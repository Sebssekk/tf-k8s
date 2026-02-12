resource "terraform_data" "waiter_linux" {
  count = var.terraform_running_OS == "linux" ? 1 : 0
  # Re-run the waiter if the target instance is recreated or if the target value changes
  triggers_replace = [
    var.instance_id,
    var.expected_value
  ]

  provisioner "local-exec" {
    # We use a single script that tries to run bash/curl.
    # If you need strict Windows support, see the 'interpreter' note below.
    interpreter = ["/bin/bash", "-c"]

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

    command = <<-EOT
      echo "Waiting for guest attribute $NAMESPACE/$KEY = $VALUE on instance $INSTANCE..."
      
      URL="https://compute.googleapis.com/compute/v1/projects/$PROJECT/zones/$ZONE/instances/$INSTANCE/getGuestAttributes?queryPath=$NAMESPACE/$KEY"
      
      START_TIME=$(date +%s)
      END_TIME=$((START_TIME + TIMEOUT))

      while [ $(date +%s) -lt $END_TIME ]; do
        # Fetch attributes silently
        RESPONSE=$(curl -s -H "Authorization: Bearer $AUTH_TOKEN" "$URL")

        # Check for the specific value in the JSON response
        if echo "$RESPONSE" | grep -q "\"value\": \"$VALUE\""; then
          echo "Success: Found attribute '$NAMESPACE/$KEY' = '$VALUE'"
          exit 0
        fi

        echo "Waiting... (Time elapsed: $(($(date +%s) - START_TIME))s)"
        sleep 10
      done

      echo "Error: Timeout waiting for guest attribute after $TIMEOUT seconds."
      exit 1
    EOT
  }
}

# Essential: We need the token inside the module scope
