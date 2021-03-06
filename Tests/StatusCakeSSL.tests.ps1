Import-Module Pester

# load it into memory
Invoke-Expression (gc .\Modules\StatusCakeDSC\StatusCakeSSL.psm1 -raw)


# generate a unique key for our test check
$uniquekey = ((1..9) | get-Random -Count 6) -join ""

Describe "Object and properties" {

}

Describe "The StatusCakeSSL bits" {
    $sccg = [StatusCakeSSL]::New()   

    $NewTestName = "Pester Test $uniquekey"
      
    It "Can list out SSL Checks using the internal method" {
        {       
            $sccg.GetApiResponse("/SSL/", "GET", $null) } | Should Not Throw
    }

    It "Fails well when creating an SSL check when ContactGroup doesn't exist" {
        {
            $sccg.Ensure                = "Present"
            $sccg.CheckRate             = 300
            $sccg.Name                  = "https://www.$uniquekey.net"
            $sccg.AlertOnExpiration     = $false
            $sccg.AlertOnProblems       = $false
            $sccg.AlertOnReminders      = $false
            $sccg.FirstReminderInDays   = 30;
            $sccg.SecondReminderInDays  = 6
            $sccg.FinalReminderInDays   = 1
            $sccg.ContactGroup          = @("ContactGroupThatDoesntExist")
            $sccg.get() } | Should throw "You have specified a contact group that does't exist, cannot proceed."
    }

    It "Should be able to create SSL check" {
        {
            $sccg.Ensure                = "Present"
            $sccg.CheckRate             = 300
            $sccg.Name                  = "https://www.$uniquekey.net"
            $sccg.AlertOnExpiration     = $false
            $sccg.AlertOnProblems       = $false
            $sccg.AlertOnReminders      = $false
            $sccg.FirstReminderInDays   = 30;
            $sccg.SecondReminderInDays  = 6
            $sccg.FinalReminderInDays   = 1
            $sccg.ContactGroup          = @("ExistingContactGroup")
            $sccg.get() } | Should not throw
    }

    It "Should be able to Change SSL check" {
        {
            $sccg.Ensure                = "Present"
            $sccg.CheckRate             = 300
            $sccg.Name                  = "https://www.$uniquekey.net"
            $sccg.AlertOnExpiration     = $false
            $sccg.AlertOnProblems       = $true
            $sccg.AlertOnReminders      = $true
            $sccg.FirstReminderInDays   = 25;
            $sccg.SecondReminderInDays  = 7
            $sccg.FinalReminderInDays   = 4
            $sccg.ContactGroup          = @("ExistingContactGroup")
            $sccg.get() } | Should not throw
    }
    
    It "Should be able to delete an SSL check" {
        {   $sccg.Ensure = 'Absent'
            $sccg.Set() } | Should Not Throw            
    }
}
