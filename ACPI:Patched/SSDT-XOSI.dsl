DefinitionBlock ("", "SSDT", 2, "hack", "_XOSI", 0)
{
    Method(XOSI, 1)
    {
        Store(Package()
        {
            "Windows",
            "Windows 2001",
            "Windows 2001 SP2",
            "Windows 2006",
            "Windows 2006 SP1",
            "Windows 2009",
            "Windows 2012"
        }, Local0)
        
        Return (Ones != Match(Local0, MEQ, Arg0, MTR, 0, 0))
     }
}
        