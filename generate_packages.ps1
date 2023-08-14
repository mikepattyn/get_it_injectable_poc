# Define parameters for the script
param(
    [string]$package_name,
    [switch]$feature,
    [switch]$sdk,
    [switch]$ac,
    [switch]$verbose
)    

# Configure VerbosePreference based on the 'verbose' parameter
if ($verbose) {
    $VerbosePreference = "Continue"
}
else {
    $VerbosePreference = "SilentlyContinue"
}

# Define folder paths and subdirectory names
$package_path = "packages"
$domain_subdirectory = "domain"
$infrastructure_subdirectory = "infrastructure"
$presentation_subdirectory = "presentation"

# Check if the feature switch is set
if ($feature) {
    # Update package path based on the 'features' subdirectory
    $package_path = Join-Path -Path $package_path -ChildPath "features"
}

# Construct paths for various subdirectories
$package_path = Join-Path -Path $package_path -ChildPath $package_name
$domain_path = Join-Path -Path $package_path -ChildPath $domain_subdirectory
$infrastructure_path = Join-Path -Path $package_path -ChildPath $infrastructure_subdirectory
$presentation_path = Join-Path -Path $package_path -ChildPath $presentation_subdirectory

# Create package names for different subdirectories
$domain_package_name = "$package_name" + "_" + "$domain_subdirectory"
$infrastructure_package_name = "$package_name" + "_" + "$infrastructure_subdirectory"
$presentation_package_name = "$package_name" + "_" + "$presentation_subdirectory"

# Arrays to store subdirectory paths and package names
$subdirectoryPaths = @()
$packages = @()

# Check if the 'feature' switch is set
if ($feature) {
    if (-not (Test-Path -Path $package_path)) {
        # Create the main package directory and subdirectories
        New-Item -Path $package_path -ItemType Directory 2>&1 | Write-Verbose
            
        # Create Flutter packages in different subdirectories
        Invoke-Expression "flutter create --template=package $domain_path --project-name $domain_package_name"  2>&1 | Write-Verbose
        Invoke-Expression "flutter create --template=package $infrastructure_path --project-name $infrastructure_package_name" 2>&1 | Write-Verbose
        Invoke-Expression "flutter create --template=package $presentation_path --project-name $presentation_package_name" 2>&1 | Write-Verbose

        # Add package names to the packages array
        $packages += $domain_package_name
        $packages += $infrastructure_package_name
        $packages += $presentation_package_name

        # Add subdirectory paths to the subdirectoryPaths array
        $subdirectoryPaths += $domain_path
        $subdirectoryPaths += $infrastructure_path
        $subdirectoryPaths += $presentation_path
    }
    else {
        Write-Host "Directory already exists: $package_path"
        break
    }
}
# If the 'feature' switch is not set
else {
    # Reset the package path to the default value
    $package_path = "packages"

    # Check if the 'sdk' switch is set
    if ($sdk) {
        # Construct the path for the SDK subdirectory
        $sdk_path = Join-Path -Path $package_path -ChildPath "api\sdk"
        $sdk_path = Join-Path -Path $sdk_path -ChildPath $package_name

        if (-not (Test-Path -Path $sdk_path)) {
            # Create the SDK package directory
            New-Item -Path $sdk_path -ItemType Directory 2>&1 | Write-Verbose

            # Create a unique name for the SDK package
            $sdk_name = $package_name + "_" + "sdk"

            # Create a Flutter package in the SDK subdirectory
            Invoke-Expression "flutter create --template=package $sdk_path --project-name $sdk_name" 2>&1 | Write-Verbose
            $subdirectoryPaths += $sdk_path
            $packages += $sdk_name
        }
        else {
            Write-Host "Directory already exists: $sdk_path"
            break
        }
    }

    # Check if the 'ac' (anti-corruption) switch is set
    if ($ac) {
        # Construct the path for the anti-corruption subdirectory
        $ac_path = Join-Path -Path $package_path -ChildPath "api\anti_corruption"
        $ac_path = Join-Path -Path $ac_path -ChildPath $package_name

        if (-not (Test-Path -Path $ac_path)) {
            # Create the anti-corruption package directory
            New-Item -Path $ac_path -ItemType Directory 2>&1 | Write-Verbose

            # Create a unique name for the anti-corruption package
            $ac_name = $package_name + "_" + "anti_corruption"

            # Create a Flutter package in the anti-corruption subdirectory
            Invoke-Expression "flutter create --template=package $ac_path --project-name $ac_name" 2>&1 | Write-Verbose
            $subdirectoryPaths += $ac_path
            $packages += $ac_name
        }
        else {
            Write-Host "Directory already exists: $ac_path"
            break
        }
    }

    # If neither 'sdk' nor 'ac' switches are set
    if (-not $sdk -and -not $ac) {
        # Update package path to include the package name
        $package_path = Join-Path $package_path -ChildPath $package_name

        if (-not (Test-Path -Path $package_path)) {
            # Create the main package directory
            New-Item -Path $package_path -ItemType Directory 2>&1 | Write-Verbose

            # Create a Flutter package in the main package directory
            Invoke-Expression "flutter create --template=package $package_path --project-name $package_name" 2>&1 | Write-Verbose
            $subdirectoryPaths += $package_path
            $packages += $package_name
        }
        else {
            Write-Host "Directory already exists: $package_path"
            break
        }
    }       
}

# Folders to remove from created packages
$foldersToRemove = @("android", "ios", "linux", "macos", "windows")

# Files to remove from created packages
$filesToRemove = @(".gitignore", "CHANGELOG.md", "LICENSE", "README.md")

# Iterate through subdirectory paths and clean up unwanted files and folders
foreach ($subdirectoryPath in $subdirectoryPaths) {
    foreach ($folder in $foldersToRemove) {
        $folderPath = Join-Path -Path $subdirectoryPath -ChildPath $folder
        if (Test-Path -Path $folderPath -PathType Container) {
            Remove-Item -Path $folderPath -Force -Recurse
        }
    }

    foreach ($file in $filesToRemove) {
        $filePath = Join-Path -Path $subdirectoryPath -ChildPath $file
        if (Test-Path -Path $filePath -PathType Leaf) {
            Remove-Item -Path $filePath -Force
        }
    }
}

Write-Host "Successfully added the following package(s):"
foreach ($package in $packages) { 
    Write-Host "- $package"
}

Write-Host ""
Write-Host "Please change the following in the pubspec.yaml file for all the packages listed above:"
Write-Host "- Remove the homepage field"
Write-Host "- Add 'publish_to: none'";
Write-Host "- Remove automatically generated comments";
Write-Host "- Update the description to reflect the content of the package";
Write-Host ""
Write-Host "You can now add dependencies to and from the package(s)."
