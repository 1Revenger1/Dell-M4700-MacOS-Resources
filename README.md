# Dell Precision M4700 MacOS

###Changelog: 
- Update 11/1/2019   Provided plist is for Opencore now  
- Update 11/22/2019 Added additional Configs for Clover, Intel, and Nvidia setups

### Help Wanted! Looking for a user with the M4000 and the not 30 bit/eDP internal display!
___
Releasing this to help others with Dell Precision M4700s.  
I would recommend reading [this guide](https://hackintosh.gitbook.io/-r-hackintosh-vanilla-desktop-guide/) and [this first contact page](https://internet-install.gitbook.io/macos-internet-install/) before proceeding. While these guides use clover, it still much needed info to begin understanding what's going on in opencore. Go [here for an opencore guide](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/) which explains the settings needed for Ivy Bridge systems

## Tested Specs

| |Laptop 1| Laptop 2 |
|---|---|---|
| CPU |  I7-3740QM  |  I7-3940XM  |
| RAM  | 4 x 4GB 1600Mhz DDR3  | 16GB DDR3 |
| GPU  | AMD Firepro Mobility M4000  |  NVidia Quadro K1000M |
| Screen  | 1080p IPS 30 bit depth  | 1080p IPS 24 bit depth |
| Wifi  |  Broadcom BCM94352Z  | Dell DW1510 |
| Trackpad  | Alphs Dual Point - V3 Rushmore  | |

## Graphics
For whatever GPU is driving the internal display, add the below to get a full range of backlight values.
```dtd
<key>applbkl</key>
<data>AQAAAA==</data>
<key>applbkl-name</key>
<data>RjE0VHh4eHgA</data>
<key>applbkl-data</key>
<data>ABEAAAAEAAsAEAAUABoAIwArADQAPwBOAGIAeQCUALUA2gD/</data>
```
This tells applbkl to force backlight injection, and to pass in a set of hex values from 0x0 to 0xff for the "F14Txxxx" display. Without these properties, the backlight still works, but you don't get the full range of brightness.

If you have an NVidia GPU, and Optimus is *enabled*, then the iGPU is running the main display, and you want to input the Intel graphics properties. If you have Optimus *disabled*, then go to the Nvidia section.

### AMD 
Use the AMD config and remove device properties if you don't need them.
These properties below are needed
```dtd
<key>@0,display-dual-link</key>
<data>AQAAAA==</data>
<key>CAIL,CAIL_DisableDrmdmaPowerGating</key>
<data>AQAAAA==</data>
<key>CAIL,CAIL_DisableGfxCGPowerGating</key>
<data>AQAAAA==</data>
<key>CAIL,CAIL_DisableUVDPowerGating</key>
<data>AQAAAA==</data>
<key>CAIL,CAIL_DisableVCEPowerGating</key>
<data>AQAAAA==</data>
```

If you would like the iGPU to be used for video encoding/airplay, then use the below
```dtd
<key>shikigva</key>
<data>KAAAAA==</data>
<key>shiki-id</key>
<data>TWFjLUZDMDJFOTFEREQzRkE2QTQA</data>
```

Use the below device properties as well if the panel has a 30 bit depth, or connects over eDP
```dtd
<key>connectors</key>
<data>AgAAAEAAAAAJCQEAAAAAABAAAAUAAAAAAAQAAAQDAAAACQIAAAAAABECAQEAAAAAAAQAAAQDAAAACQMAAAAAACEDAgIAAAAAAAgAAAQCAAAAAQQAAAAAABIEAwMAAAAA</data>
<key>@0,display-link-component-bits</key>
<data>CgAAAA==</data>
<key>@0,display-link-pixel-bits</key>
<data>CgAAAA==</data>
```

### NVidia
Nothing needed - though backlight does not work.

### Intel
Below device properties are needed in order for the iGPU to drive the main display.

```dtd
<key>AAPL,ig-platform-id</key>
<data>BABmAQ==</data>
<key>framebuffer-con1-alldata</key>
<data>AgUAAAAEAAAHBAAAAwQAAAAEAACBAAAABAYAAAAEAACBAAAA</data>
<key>framebuffer-con1-enable</key>
<integer>1</integer>
<key>framebuffer-memorycount</key>
<integer>2</integer>
<key>framebuffer-patch-enable</key>
<integer>1</integer>
<key>framebuffer-pipecount</key>
<integer>2</integer>
<key>framebuffer-portcount</key>
<integer>4</integer>
<key>framebuffer-stolenmem</key>
<data>AAAABA==</data>
```

### Enabling iGPU
If Optimus is set to "Disabled" or you are otherwise forced to use the iGPU - it is possible to enable the iGPU to use headless for airPlay and h.264 encoding using the below instructions:

1. Download the exe to update the BIOS from Dell's website
2. Extract bios with binwalker
 `binwalk -e whatever.exe`
3. Use pfsextractor on the uncompressed output
4. TODO: Add more steps to use rom from exe

## Kexts
You can get more information about these by clicking on the links, which leads to their respective github repo.

* [Lilu](https://github.com/acidanthera/Lilu) - Needed for kexts such as AirportBrcmFixup and WhateverGreen to function.  
* [AirportBrcmFixup.kext](https://github.com/acidanthera/AirportBrcmFixup) - Allows 94352Z to work even though it's not native to MacOS.  
* [WhateverGreen](https://github.com/acidanthera/WhateverGreen) - Allows us to put in the iGPU platform id and M4000 framebuffer
* [VirtualSMC](https://github.com/acidanthera/VirtualSMC) - Emulates the SMC and provides sensor information for Battery and CPU.
  * Includes SMCBatteryManager, SMCProcessor, and SMCLightSensor as well, which I use as well.  
* [USBInjectAll](https://github.com/RehabMan/OS-X-USB-Inject-All) - Injects all the USB ports in SSDT-UIAC as macOS does not pick up all the USB Ports by itself.
* [VoodooPS2Controller](https://github.com/1Revenger1/OS-X-ALPS-DRIVER) - Fixes PS2 Trackpad and Keyboard (Not linked yet, I compiled my own based off of Dr. Hurtz and Rehabman's repo)
* [BrcmFirmwareRepo/BrcmPatchRAM3 (Acidanthera)](https://github.com/acidanthera/BrcmPatchRAM) - Allows the Bluetooth part of the 94352Z to work with macOS.
  * You need BrcmPatchRAM3, BrcmFirmwareData, and BrcmBluetoothInject for Catalina
* [IntelMausiEthernet](https://github.com/Mieze/IntelMausiEthernet) - Fixes ethernet port.
* [AppleALC](https://github.com/acidanthera/AppleALC) - Fixes speakers and 3.5mm ports

## Config.plist

### Patches

* _OSI to XOSI - Redirects OSI calls to the one in the SSDT_XOSI file. When _OSI checks Windows 7 or Windows 8, it'll also check if it's Darwin as well.
* EHC1 to EH01/EHC2 to EH02 - Expected DSDT name for USBInjectAll
* ECDV to EC - Embedded Controller rename to allow the laptop to boot into MacOS 🐱-alina
* HPET _CRS to XCRS/IRQ 8 /IRQ 0 Patch - Generated by [this script](https://github.com/corpnewt/SSDTTime), used with SSDT-HPET
* EC5_ to ECB_ - Intercepts calls to change screen brightness from brightness keys to the method in SSDT-BRTK

### Dropped Tables

* MCFG - Causes crashes with SSDT-CPUPM

### Devices
* Pci(0x1b,0x0) - Set audio layout for AppleALC.kext to fix interal speakers and ports
* Pci(0x1c,0x7) - Fixes SD Card slot by allowing it to use the apple SD card kext within MacOS.

## SSDTs

* SSDT-CPUPM - Generated by [this script](https://github.com/Piker-Alpha/ssdtPRGen.sh). Allows the CPU to turbo and lower it's clock speed.
* SSDT-HPET - Generated by [this script](https://github.com/corpnewt/SSDTTime), fixes duplicate IRQs and fixes RTC
* SSDT-UIAC - Generated by [this script](https://github.com/corpnewt/USBMap). Used in conjunction with USBInjectAll, specifies which ports to be injected. 
* SSDT-PNLF - From [WhateverGreen](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/SSDT-PNLF.dsl), fixes backlight control
* SSDT-ALS0 - From [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/AcpiSamples/SSDT-ALS0.dsl) Creates a fake Ambient Light Sensor, which is needed for the screen to dim when disconnected from the battery.
* SSDT-SDMMC - Adds the missing SD card device in the DSDT
* SSDT-XOSI - If checking Windows 7 or 8, check if it's Darwin as well.
* SSDT-BRTK - Sends PS2 Commands when brightness keys are pressed.

## Credits
* Thanks to everyone in r/Hackintosh's Discord Server. They helped out a ton.
* Authors of the Kexts, drivers, and scripts used.
* Dhinak
* Landonh12
