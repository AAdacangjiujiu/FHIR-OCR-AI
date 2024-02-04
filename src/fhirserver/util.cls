Class fhirserver.util
{

ClassMethod SetupServer() As %Status
{
	 set currenns=$namespace
	 
	 set ns="fhirserver"
	 Set appKey = "/csp/healthshare/"_ns_"/fhir/r4"
     Set strategyClass = "HS.FHIRServer.Storage.Json.InteractionsStrategy"
     Set metadataPackages = $lb("hl7.fhir.r4.core@4.0.1")
     zn "HSLIB"
     //Install a Foundation namespace and change to it
     w "ns",!
     Do ##class(HS.Util.Installer.Foundation).Install(ns)
     zn ns
     //Set $namespace = "FHIRNamespace"

     // Install elements that are required for a FHIR-enabled namespace
    Do ##class(HS.FHIRServer.Installer).InstallNamespace()

    // Install an instance of a FHIR Service into the current namespace
    Do ##class(HS.FHIRServer.Installer).InstallInstance(appKey, strategyClass, metadataPackages)
    //zn 
    
    Quit $$$OK
}

}

