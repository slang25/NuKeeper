#!/usr/bin/env pwsh

dotnet publish ./NuKeeper --configuration Release --runtime win10-x64 -o ../publish/win10-x64
dotnet publish ./NuKeeper --configuration Release --runtime osx-x64 -o ../publish/osx-x64
dotnet publish ./NuKeeper --configuration Release --runtime linux-x64 -o ../publish/linux-x64

mkdir dist
mkdir dist/win10-x64
mkdir dist/macos-x64
mkdir dist/linux-x64

if ($IsWindows)
{
    [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" ; Invoke-WebRequest https://github.com/dgiagio/warp/releases/download/v0.3.0/windows-x64.warp-packer.exe -OutFile warp-packer.exe
    
    .\warp-packer --arch windows-x64 --input_dir publish/win10-x64 --exec NuKeeper.exe --output dist/win10-x64/NuKeeper.exe
    .\warp-packer --arch macos-x64 --input_dir publish/osx-x64 --exec NuKeeper --output dist/osx-x64/NuKeeper
    .\warp-packer --arch linux-x64 --input_dir publish/linux-x64 --exec NuKeeper --output dist/linux-x64/NuKeeper
}

if ($IsMacOS) {
    curl -Lo warp-packer https://github.com/dgiagio/warp/releases/download/v0.3.0/macos-x64.warp-packer
    chmod +x warp-packer

    ./warp-packer --arch windows-x64 --input_dir publish/win10-x64 --exec NuKeeper.exe --output dist/win10-x64/NuKeeper.exe
    ./warp-packer --arch macos-x64 --input_dir publish/osx-x64 --exec NuKeeper --output dist/macos-x64/NuKeeper
    ./warp-packer --arch linux-x64 --input_dir publish/linux-x64 --exec NuKeeper --output dist/linux-x64/NuKeeper

    chmod +x dist/macos-x64/NuKeeper
}

if ($IsLinux) {
    curl -Lo warp-packer https://github.com/dgiagio/warp/releases/download/v0.3.0/linux-x64.warp-packer
    chmod +x warp-packer
    
    ./warp-packer --arch windows-x64 --input_dir publish/win10-x64 --exec NuKeeper.exe --output dist/win10-x64/NuKeeper.exe
    ./warp-packer --arch macos-x64 --input_dir publish/osx-x64 --exec NuKeeper --output dist/macos-x64/NuKeeper
    ./warp-packer --arch linux-x64 --input_dir publish/linux-x64 --exec NuKeeper --output dist/linux-x64/NuKeeper

    chmod +x dist/linux-x64/NuKeeper
}
