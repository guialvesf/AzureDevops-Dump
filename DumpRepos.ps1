function Get-Repos {

    if (!$args) {
        write-host ("Usage: Get-Repos <AzureDevops URL> <Basic auth>")
        Exit
    }

    $URL = $args[0]
    $Basic = $args[1]

    $Projects = C:\Windows\system32\curl.exe "$URL/DefaultCollection/_apis/projects?\$top=3000&api-version=5.1" -H "Authorization: Basic $Basic" | convertfrom-json
    
    foreach ($Project in $Projects.value) {
        $ProjectName = $Project.name
        $Repos = C:\Windows\system32\curl.exe "$URL/DefaultCollection/$ProjectName/_apis/git/repositories?\$top=3000&api-version=5.1" -H "Authorization: Basic $Basic" | convertfrom-json
    
        foreach ($Repo in $Repos.value) {
            git -c http.extraHeader="Authorization: Basic $Basic" clone $Repo
        }
    }
}    
