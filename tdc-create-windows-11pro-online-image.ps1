Import-Module .\WinImageBuilder.psm1
Import-Module .\Config.psm1
Import-Module .\UnattendResources\ini.psm1

$ConfigFilePath = ".\config.ini"

# Set the path to the .wim file, which you might need to extract arduously from a higher level archive within the iso...:
Set-IniFileValue -Path (Resolve-Path $ConfigFilePath) -Section "DEFAULT" `
                                      -Key "wim_file_path" `
                                      -Value "C:\git\windows-openstack-imaging-tools\install.wim"

# VirtIO ISO contains all the synthetic drivers for the KVM hypervisor
$virtIOISOPath = "C:\images\virtio.iso"
# Note(avladu): Do not use stable 0.1.126 version because of this bug https://github.com/crobinso/virtio-win-pkg-scripts/issues/10
# Note (atira): Here https://fedorapeople.org/groups/virt/virtio-win/CHANGELOG you can see the changelog for the VirtIO drivers
$virtIODownloadLink = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.141-1/virtio-win-0.1.141.iso"

# Download the VirtIO drivers ISO from Fedora
if (-not(Test-Path -Path $virtIOISOPath -PathType Leaf)) {
    (New-Object System.Net.WebClient).DownloadFile($virtIODownloadLink, $virtIOISOPath)
}
# Now create the image
New-WindowsOnlineImage -ConfigFilePath $ConfigFilePath

