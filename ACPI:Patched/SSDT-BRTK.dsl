DefinitionBlock ("", "SSDT", 1, "GWYD", "BRTK", 0x00021500)
{
    External(\_SB.PCI0.LPCB.PS2K, DeviceObj)
    
    Method(EVB, 2, NotSerialized)
    {
        If ((Arg0 == One))
        {
            // Brightness Up
            Notify (\_SB.PCI0.LPCB.PS2K, 0x0406)
        }

        If ((Arg0 & 0x02))
        {
            // Brightness Down
            Notify (\_SB.PCI0.LPCB.PS2K, 0x0405)
        }
    }
}