try{
    # 1. Read JSON from Stdin
    $InputJson = [Console]::In.ReadToEnd() | ConvertFrom-Json
    
    # 2. Extract variables
    $HostName = $InputJson.host
    $User     = $InputJson.user
    $Key      = $InputJson.key
    $File     = $InputJson.file
    
    $KeyFile = [System.IO.Path]::GetTempFileName()
    
        
    [System.IO.File]::WriteAllText($KeyFile, $Key)
    $Acl = Get-Acl $KeyFile
    $Acl.SetAccessRuleProtection($true, $false) # Disable inheritance
    $Rule = New-Object System.Security.AccessControl.FileSystemAccessRule($env:USERNAME, "FullControl", "Allow")
    $Acl.AddAccessRule($Rule)
    Set-Acl $KeyFile $Acl
    
    # 3. Fetch content via SSH
    # Note: Windows OpenSSH outputs an array of lines, so we join them with newlines
    $Content = ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=NUL -i $KeyFile $User@$HostName "cat $File"
    $ContentStr = $Content -join "`n"
    
    # 4. Return JSON object
    # -Compress removes pretty-printing to make it safer for Terraform parsing
    @{ content = $ContentStr } | ConvertTo-Json -Compress

} catch {
    # Write error to Stderr so Terraform sees it
    [Console]::Error.WriteLine("Error: " + $_.Exception.Message)
    exit 1
} finally {
    # 7. Cleanup: Delete the key file always
    if (Test-Path $KeyFile) {
        Remove-Item -Force $KeyFile
    }
}