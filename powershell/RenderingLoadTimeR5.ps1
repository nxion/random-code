#Check for/create output file and temp directory
$FileDate = Get-Date -UFormat "%Y%m%d"
$TestDate = Get-Date -Format s
$PCName = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -expand Model
$TempPath = "C:\temp"
$CsvPath = "C:\temp\$FileDate.$PCName.csv"
$Count = 1

if (! (Test-Path -Path $TempPath)){
    New-Item -Path $TempPath -ItemType Directory
}
if (! (Test-Path -Path $CsvPath)){
    New-Item -Path $CsvPath -ItemType File
}Else{
    Add-Content -Path $CsvPath -Value $TestDate
}

#Clear cookies/cache
Function ClearIE {
    RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 255
    start-sleep -seconds 10
}

#ClearIE

#Close Internet Explorer
Function CloseIE {
    $ProcessRunning = Get-Process iexplore -ErrorAction SilentlyContinue
    if ( $ProcessRunning -eq $null ){
        Write-Host "iexplore is not running"
        return
    }
    else {
        get-process iexplore | stop-process
        start-sleep -seconds 10
    }
}

#Function IE Browse
Function IEBrowse {
    $Site = $args[0]
    # remove cookies
    ClearCookies
    $TimeStart = Get-Date
    $IE = New-Object -com InternetExplorer.Application
    $IE.visible = $True
    $IE.navigate2($Site)

    while ($IE.ReadyState -ne 4) {
        $Results = (Get-Date).subtract($TimeStart).TotalSeconds
        if ( $Results -gt 60 ){
            $Report = $Site + "," + $Results + "," + ">60 Seconds" | Add-Content -Path $CsvPath
            return
        }
    }

    if ($IE.ReadyState -eq 4) {
        $Results = (Get-Date).subtract($TimeStart).TotalSeconds
        $Report = $Site + "," + $Results | Add-Content -Path $CsvPath
    }

}

Function SiteList {

    $bcbs = IEBrowse http://www.bcbsnm.com/ 
    $uhc = IEBrowse http://www.uhc.com/home.htm
    $slash = IEBrowse http://www.slashdot.org 
    $vpulse = IEBrowse http://www.virginpulse.com
    $wired = IEBrowse http://www.wired.com/2012/08/apple-amazon-mat-honan-hacking/all
    $cnn = IEBrowse http://www.cnn.com
    $vanity = IEBrowse http://www.vanityfair.com/business/2014/06/apple-samsung-smartphone-patent-war
    
    # Close IE to avoid over-taxing system
    CloseIE

    $nytimes = IEBrowse http://www.nytimes.com
    $abc = IEBrowse http://www.abcnews.go.com
    $digg = IEBrowse http://www.digg.com
    $bbc = IEBrowse http://www.bbc.com/news/
    $msn = IEBrowse http://www.msnbc.com
    $nbc = IEBrowse http://www.nbcnews.com
    $fox = IEBrowse http://www.foxnews.com/politics/2015/01/27/bergdahl-to-be-charged-with-desertion-ex-military-intel-officer-says/
    # Separate tests in csv
    $Report = "End of test " + $Count | Add-Content -Path $CsvPath
    # Close IE to avoid over-taxing system
    CloseIE
}

#function for clearing IE cookies
Function ClearCookies {
    $CookieDir = $env:userprofile + "\appdata\roaming\Microsoft\Windows\Cookies"
    remove-item -Path $CookieDir\* -Recurse -Force
    Write-Host "Removing cookies from " $CookieDir
}

# Run the test X amount of times
while ( $Count -le 10 ) {
    ClearIE
    Write-Host "Current test number: " $Count
    SiteList
    $Count = $Count + 1
}
