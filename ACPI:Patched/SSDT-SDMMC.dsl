DefinitionBlock ("", "SSDT", 1, "DELL ", "SD/MMC", 0x00021500)
{
    External (_SB_.PCI0.RP08, DeviceObj)
    
    Scope (_SB.PCI0.RP08)
    {
 
        Device (SDSX)
        {
            Name (_ADR, One)
            Name (_PWR, Package (0x02)
            {
                0x09,
                0x04
            })
        }       
    }
}    
    