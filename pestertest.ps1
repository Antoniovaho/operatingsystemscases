#Get-EventLog -logname "Application"
#Clear-EventLog -logname "Application"

#EVENTLOG CREATION
# sourceName variable to make this easily adjustable if you want to use this with another sourcename
# sourceName = 'antoniotest'
# logname variable to make this easily adjustable if you want to use this for other logs
# logName = 'Application'

# Checks if there is a source that exists with the sourcename that you've chosen
# If it already exists you will just add onto the existing source later
if (![System.Diagnostics.eventLog]::SourceExists($sourceName)) {
    # Creating a new eventlog in the chosen log with the name
    New-EventLog -LogName Application -Source antoniotest
    }
#1 NAT NETWORKING TEST ------------------------------------------------------------
   # Name the test (usually used for grouping similar tests)
    Describe 'Nat Networking' {
        # Says what the purpose of this individual test is
        it 'should test if Nat Networking is enabled in VirtualBox' {
            # Here I grab the IP address from the -addressfamily ipv4 and the -interfacealieas ethernet and turn it into a variable
            $ipv4 = (get-netIPAddress -addressfamily ipv4 -InterfaceAlias Ethernet).IPAddress
            # Here I check to see if the IP address matches certain IP addresses that are commenly used for Nat Networking
            $ipv4 | Should -Match '10.*.*.*'
                # Writes to the eventlog as info that the first test had a positive result
                Write-EventLog -LogName Application -Source antoniotest -EntryType Information -eventId 1 -Message 'Nat networking is enabled'}
}
#2 INTERNET CONNECTION TEST ------------------------------------------------------------
   # Name the test 
    Describe 'Connection test' {
    # Says what the purpose of this individual test is
        it 'should test if the machine has an internet connection' {
            # Tests the connection to the computer with the 8.8.8.8 IP which is the google DNS server (always available) attempts to connect once without displaying ping
            $connectionTest = Test-Connection -ComputerName '8.8.8.8' -Count 1 -Quiet
            $connectionTest | Should -be $true
                # Writes to the eventlog as info that the second test had a positive result
                Write-EventLog -LogName Application -Source antoniotest -EntryType Information -eventId 2 -Message 'There is an internet connection'
            }
}
#3 ADMIN USER TEST ------------------------------------------------------------
    # Name the test
    Describe 'Admin user' {
        # Says what the purpose of this individual test is
        it 'should test if there is a user with the name admin' {
            # Tests if there is a user with the name admin
            (Get-localUser -Name admin).name | Should -Be admin
                # Writes to the eventlog as info that the third test had a positive result
                Write-EventLog -LogName Application -Source antoniotest -EntryType Information -eventId 3 -Message 'There is an admin user'
            }
}
#4 FIREWALL TEST ------------------------------------------------------------
    # Name the test
    Describe 'Firewall' {
        # Says what the purpose of this individual test is
        it 'should test if the firewall is turned off' {
            # Tests if the firewall is enabled
            !(get-netfirewallprofile -profile domain).enabled | Should -Be $true
                # Writes to the eventlog as info that the fourth test had a positive result
                Write-EventLog -LogName Application -Source antoniotest -EntryType Information -eventId 4 -Message 'The firewall is turned off'
            }
    }
#5 GUEST ADDITIONS TEST ------------------------------------------------------------
    # Name the test
    Describe 'Guest additions' {
        # Says what the purpose of this individual test is
        it 'should test if the virtual box guest additions are installed' {
            # Tests if the file VBoxGuest.sys exists, this indicates that the guest additions are installed
            Test-path "C:/Program Files/Oracle/VirtualBox Guest Additions/VBoxGuest.sys" | Should -Be $true
                # Writes to the eventlog as info that the fifth test had a positive result
                Write-EventLog -LogName Application -Source antoniotest -EntryType Information -eventId 5 -Message 'Guest additions are installed'
            }
    }
#6 WINDOWS TRIAL TEST ------------------------------------------------------------
    # Name the test
    Describe 'Window trial' {
        # Says what the purpose of this individual test is
        it 'should test if you have more than 7 days left in you windows trial' {
            # Retrieves the amount of minutes you have left in your trial period so multiply 7 by 1440 to get 10080 minutes and now we compare that to our time left
            (get-ciminstance -classname softwarelicensingproduct).graceperiodremaining | Should -BeGreaterThan 10080
                # Writes to the eventlog as info that the sixth test had a positive result
                Write-EventLog -LogName Application -Source antoniotest -EntryType Information -eventId 6 -Message 'You still have more than 7 days left on your Windows trial edition'
            }
    }
#7 BELGIAN KEYBOARD TEST ------------------------------------------------------------
    # Name the test
    Describe 'Belgian (period) keyboard' {
        # Says what the purpose of this individual test is
        it 'should test if the layout of the keyboard is Belgian (period)' {
            # Retrieves the windows user language list at position 1 which is the one in use and check if the inputmethodtips matches the number for the belgium (period) keyboard
            (get-winuserlanguagelist)[1].InputMethodTips | Should -Match ".*00000813"
                # Writes to the eventlog as info that the seventh test had a positive result
                Write-EventLog -LogName Application -Source antoniotest -EntryType Information -eventId 7 -Message 'The keyboard layout is Belgian (period)'
            }
    }
#8 MEMORY USAGE TEST ------------------------------------------------------------
    # Name the test
    Describe 'Memory usage <60%' {
        # Says what the purpose of this individual test is
        it 'should test if you are using less than 60% of your memory' {
            # Gets the amount of memory that is in usage by the system in % and checks if it is less than 60
            (get-Counter '\Memory\% Committed Bytes in use').CounterSamples.CookedValue | Should -BeLessThan "60"
                # Writes to the eventlog as info that the eigth test had a positive result
                Write-EventLog -LogName Application -Source antoniotest -EntryType Information -eventId 8 -Message 'Less than 60% of your memory is in usage'
            }
            }
#9 CPU USAGE TEST ------------------------------------------------------------
    # Name the test
    Describe 'CPU usage <60%' {
        # Says what the purpose of this individual test is
        it 'should test if you are using less than 60% of your CPU' {
            # Gets the amount of cpu that is in usage by the system in % and checks if it is less than 60
            ((get-Counter '\Processor(_Total)\% Processor Time').CounterSamples).CookedValue | Should -BeLessThan "60"
                # Writes to the eventlog as info that the ninth test had a positive result
                Write-EventLog -LogName Application -Source antoniotest -EntryType Information -eventId 9 -Message 'Less than 60% of your cpu is in usage'
        }
    }
#10 EXECUTION POLICY TEST ------------------------------------------------------------
    # Name the test
    Describe 'Execution policy restricted' {
        # Says what the purpose of this individual test is
        it 'should test if the execution-policy is set to restricted' {
            #Gets the executionpolicy and checks if it is restricted
            Get-ExecutionPolicy | Should -Be Restricted
                # Writes to the eventlog as info that the tenth test had a positive result
                Write-EventLog -LogName Application -Source antoniotest -EntryType Information -eventId 10 -Message 'The executionpolicy is set to restricted'
            }
    }

