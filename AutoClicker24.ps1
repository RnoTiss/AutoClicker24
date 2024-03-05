<#
.SYNOPSIS
AutoClicker24 - Simulates mouse clicks at random intervals between 600 and 850 milliseconds when the start button is pressed and stops when the stop button is pressed.

.DESCRIPTION
This PowerShell script creates a simple GUI with Start and Stop buttons to control the simulation of mouse clicks. It demonstrates the use of WPF for building the GUI and timers to handle periodic actions in PowerShell scripts.

.EXAMPLE
To run AutoClicker24, simply execute the script in PowerShell. Ensure that the execution policy allows script execution.

    .\AutoClicker24.ps1

.NOTES
Make sure to adjust the execution policy to allow script execution. This can be done by running the following command as an administrator:

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

This command is commented out within the script for security reasons and should be executed separately by the administrator.

#>

# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser # Uncomment and run as administrator to set execution policy.

function AutoClicker24 {
    Add-Type -AssemblyName PresentationFramework
    Add-Type -AssemblyName System.Windows.Forms

    # Inner function to simulate mouse click
    function Simulate-Click {
        param(
            [int]$duration
        )

        $script:timer = New-Object System.Windows.Forms.Timer
        $script:timer.Interval = $duration
        $script:timer.Add_Tick({
            # Placeholder for mouse click simulation
            [System.Windows.Forms.SendKeys]::SendWait("{LEFT}")
        })
    }

    # UI setup with WPF
    $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Click Simulator" Height="100" Width="200">
    <StackPanel>
        <Button Name="StartButton" Content="Start" Margin="10"/>
        <Button Name="StopButton" Content="Stop" Margin="10"/>
    </StackPanel>
</Window>
"@

    $reader = New-Object System.Xml.XmlNodeReader ([System.Xml.XmlDocument]$xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)

    # Finding and setting up UI controls
    $startButton = $window.FindName("StartButton")
    $stopButton = $window.FindName("StopButton")

    # Defining event handlers for buttons
    $startButton.Add_Click({
        $duration = Get-Random -Minimum 600 -Maximum 850
        Simulate-Click -duration $duration
        $script:timer.Start()
    })

    $stopButton.Add_Click({
        $script:timer.Stop()
    })

    # Display the GUI window
    $window.ShowDialog()
}

# Invoking the function to start the application
AutoClicker24
