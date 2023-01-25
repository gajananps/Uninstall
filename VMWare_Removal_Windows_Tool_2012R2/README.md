# Purpose:
VMWare Workstation Uninstallation Tool from Vanguard to target VM
# Suppoerted OS:
Windows 2012 R2 with Powershell 4.0

# Note:
Before executing this tool in target VM, Please remove "vmware_uninstall" and "vmware_uninstall.zip" in the "C:\Windows\Temp" path

  Example :
    rd /s /q C:\Windows\Temp\vmware_uninstall
    del C:\Windows\Temp\vmware_uninstall.zip

Please ensure that Admin$ should be enabled and 445 should opened in both firewall and console before Tool execution

# :::: Read the Instructions for VMWare Uninstallation Tool Execution ::::

 1. Open "inputs" folder Enter the target VMs details in "targetvmdetails.csv" file
 2. Target Server IP should be communicable with admin$ permission and via 445 port from Vanguard VM.
 3. Double click on the run.bat or open the cmd prompt and execute the run.bat file.
 4. Once the uninstallation process completed in the target VM, Report will generat automatically in the name of VMWareRemovalReport.csv file
 5. Please use double quotes execpt for IP address in targetvmdetails.csv.
