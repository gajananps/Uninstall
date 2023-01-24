$currentpath=pwd
echo $currentpath
if (!(test-path $currentpath\logs)){
mkdir $currentpath\logs 
}

$username="$env:UserName"

echo --ERROR_LOG-- > $currentpath\logs\error.log
echo inprogress > $currentpath\logs\status.log
echo inprogress > $currentpath\logs\info.log


    $app = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "VMware*"}
    $app.Uninstall() 2>&1 >> $currentpath\logs\error.log

    if ( $? ) {
    #reg delete "HKLM\SOFTWARE\VMware, Inc." /f 2>&1 >> $currentpath\logs\error.log
    #reg delete "HKLM\SOFTWARE\WOW6432Node\VMware, Inc." /f 2>&1 >> $currentpath\logs\error.log

    $x86path="C:\Program Files (x86)\VMware"
    $prgfilepath="C:\Program Files\Common Files\VMware"
    $prgdata="C:\ProgramData\VMware"
    $userdata1="C:\Users\$username\AppData\Roaming\VMware"
    $userdata2="C:\Users\$username\AppData\Local\VMware"

    if (test-path -Path $x86path){
    Remove-Item -Path "C:\Program Files (x86)\VMware" -Force -Recurse 2>&1 >> $currentpath\logs\error.log 
    echo "removed $x86path successfully" 2>&1 >> $currentpath\logs\error.log   
    }

    if (test-path -Path $prgfilepath){
    Remove-Item -Path "C:\Program Files\Common Files\VMware" -Force -Recurse 2>&1 >> $currentpath\logs\error.log 
    echo "removed $prgfilepath successfully" 2>&1 >> $currentpath\logs\error.log
    }

    if (test-path -Path $prgdata){
    Remove-Item -Path "C:\ProgramData\VMware" -Force -Recurse 2>&1 >> $currentpath\logs\error.log
    echo "removed $prgdata successfully" 2>&1 >> $currentpath\logs\error.log 
    }

    if (test-path -Path $userdata1){
    Remove-Item -Path "C:\Users\$username\AppData\Roaming\VMware" -Force -Recurse 2>&1 >> $currentpath\logs\error.log 
    echo "removed $userdata1 successfully" 2>&1 >> $currentpath\logs\error.log
    }

    if (test-path -Path $userdata2){
    Remove-Item -Path "C:\Users\$username\AppData\Local\VMware" -Force -Recurse 2>&1 >> $currentpath\logs\error.log 
    echo "removed $userdata2 successfully" 2>&1 >> $currentpath\logs\error.log
    }

    echo "Removing residue files might take a while..."
    echo " " >> $currentpath\logs\error.log
    echo "Removing residue files..." >> $currentpath\logs\error.log

    $TargetApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Vendor -eq "VMware, Inc."} 2>&1>> $currentpath\logs\error.log
    $ErrorActionPreference= 'silentlycontinue'
    $TargetApp.Uninstall() 2>> $currentpath\logs\error.log
    Get-ChildItem -path HKLM:\ -Recurse | where { $_.Name -match "VMware"} | Remove-Item -Force -Recurse 2>&1>> $currentpath\logs\error.log
    Get-ChildItem -path HKLM:\ -Recurse | where { $_.Name -match "VMware, Inc."} | Remove-Item -Force -Recurse 2>&1>> $currentpath\logs\error.log
        echo "Removed residue files successfully..." >> $currentpath\logs\error.log
        echo "success" > $currentpath\logs\status.log
        echo "VMware uninstalled successfully." > $currentpath\logs\info.log


 } else {
    echo "failed" > $currentpath\logs\status.log
    echo "VMware is already uninstalled" > $currentpath\logs\info.log
    echo "VMware is already uninstalled ..." >> $currentpath\logs\error.log
}