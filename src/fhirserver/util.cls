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
     IF ('##Class("%SYS.Namespace").Exists("FHIRSERVER")){
        Do ##class(HS.Util.Installer.Foundation).Install(ns)
         
     }
    
   
    
    try {
     zn "%sys" 
     if (##Class(Security.Applications).%OpenId(appKey)=""){ 
     zn ns
	     //w 111
         Do ##class(HS.FHIRServer.Installer).InstallNamespace()
         Do ##class(HS.FHIRServer.Installer).InstallInstance(appKey, strategyClass, metadataPackages)
    
       zn "%sys"   //Do ##class(HS.FHIRServer.Installer).InstallInstance(appKey, strategyClass, metadataPackages)
     
     }
    ///修改web应用程序
    
    Set Application=##Class(Security.Applications).%OpenId("/csp/fhir-ocr-ai/js")
	set Application.ServeFiles=2
	Set tsc= Application.%Save()
	Set Application=##Class(Security.Applications).%OpenId("/csp/fhir-ocr-ai/css")
	set Application.ServeFiles=2
	Set tsc= Application.%Save()
	//创建应用程序
	zn currenns
    }catch e{
	  zn "user"   
	 // w 111
	 }
    Quit $$$OK
}

}
