Class OCR.Util Extends %CSP.REST
{

Parameter HandleCorsRequest = "true";

XData UrlMap
{
<Routes>

  <Route Url="/*" Method="OPTIONS" Call="GetStatus"/>
  <Route Url="/ImageToString" Method="POST" Call="ImageToString"/>
 <Route Url="/getFHIR" Method="POST" Call="getFHIR"/>
 <Route Url="/setzpKeys" Method="POST" Call="setzpKeys" />
  <Route Url="/setBard" Method="POST" Call="setBard" />
 
  <Route Url="/getList" Method="POST" Call="getList" />
   <Route Url="/getSearchList" Method="POST" Call="getSearchList" />
   <Route Url="/getDisplsyList" Method="POST" Call="getDisplsyList" />
  
</Routes>
}

ClassMethod readimg(url) As %Status [ Language = python ]
{
import pytesseract
try:
    from PIL import Image
except ImportError:
    import Image
print(pytesseract.image_to_string(Image.open(url), lang='chi_sim+ens'))

return 1
}

ClassMethod ImageToString() As %Status
{
	//
	//W %request.MimeData("file",1).Read()
	set file=##class(%FileBinaryStream).%New()
	set file.Filename=$System.Util.InstallDirectory()_"mgr\python\temp.jpg"
	Do file.Write(%request.MimeData("file",1).Read())
	Do file.%Save()
	Do ..readimg(file.Filename)
	Quit $$$OK
}

ClassMethod getFHIR() As %Status
{
	set Question=%request.Data("Question",1)
	set Type=%request.Data("aitype",1)
	
	set Question=Question_"Please convert the above text into a "_%request.Data("Type",1)_" resource for fhir in JSON format"
	
  SET KEY= ^FHIRZPKEYS 
  if (Type=1){
     set msg=..getFHIRZP(Question,KEY)
  }else{
	   set msg=..getFHIRBARD(Question)
	 }
  
  set msg="{"_$p(msg,"{",2,*)
  set msg=$p(msg,"}",1,*-1)_"}"
  w msg
  
  Quit $$$OK
}

ClassMethod getFHIRZP(message, KEY) As %Status [ Language = python ]
{
from zhipuai import ZhipuAI

client = ZhipuAI(api_key=KEY) 
response = client.chat.completions.create(
    model="glm-4",  
    messages=[
        {"role": "user", "content": message},

    ],
)
#print(response.choices[0].message.content)
return response.choices[0].message.content
}

ClassMethod getFHIRBARD(Question) As %Status
{
	
	set a1="",a2="",a3=""
	Do ##class(Bard.Util.RequestSet).RequestSet(.A)
    set SNlM0e=##class(Bard.Util.RequestSet).getSNlM0e(.A)
    if (SNlM0e'[":"){
	   w "BARDSESSION ERROR" 
	   Quit
	   }
    //w SNlM0e,!
  Do ##class(Bard.Util.RequestSet).NoImageAsk(.A,SNlM0e,Question,.a1,.a2,.a3)
  //w !,##class(Bard.Util.RequestSet).GetResponse(.A,.a1,.a2,.a3),!
  Quit ##class(Bard.Util.RequestSet).GetResponse(.A,.a1,.a2,.a3)
}

ClassMethod setzpKeys() As %Status
{
	set ^FHIRZPKEYS=%request.Data("key1",1)
    w $$$OK
    Quit $$$OK
}

ClassMethod setBard() As %Status
{
	
   
	set ^FHIRBARDKEYS="__Secure-1PSID="_%request.Data("key1",1)_";__Secure-1PSIDTS="_%request.Data("key2",1)
    w $$$OK
    Quit $$$OK
}

ClassMethod getList() As %Status
{
	set ns=$namespace
	zn "fhirserver"
	SET Array=[]
	set Sql="SELECT  ID FROM %Dictionary.ClassDefinition where ID like 'HSFHIR.X0014.S.%'"
	Set statement = ##class(%SQL.Statement).%New()
	Set qStatus = statement.%Prepare(Sql)
	Set rset = statement.%Execute()
	while rset.%Next(){	
		   	Set ID  = rset.%Get("ID")
		   	if $l(ID,".")=4
		   	{
			   	Do Array.%Push($p(ID,".",4))
			 }
    }
    zn ns
    w Array.%ToJSON()
    QUIT $$$OK
}

ClassMethod getSearchList() As %Status
{
	set ns=$namespace
	zn "fhirserver"
   //set schema = ##class(HS.FHIRServer.Schema).%New()
   set schema = ##class(HS.FHIRServer.Schema).LoadSchema("hl7.fhir.r4.core@4.0.1")
   set name=""
   set searchArray=[]
   set resourceType=%request.Data("resourceType",1)
   set name= schema.NextSearchParamName(resourceType, "")
   
   while name'=""
   {
	  // zw name
	  set temp={}
	  set temp.name=name
	  set temp.path=schema.FindSearchParam(resourceType, name).fhirPath
	  Do searchArray.%Push(temp)   
	  //set temp= schema.FindSearchParam(resourceType, name).fhirPath
	  //w temp,!
	  set fname=$Get(@schema.TiGbl@(resourceType, name, "dt"))
	  set name= schema.NextSearchParamName(resourceType, name)
	  
   }
   //Do ..getDisplsyList(resourceType)
   set result={}
   set result.searchArray=searchArray
   set result.displsyList=..getDisplsyList(resourceType)
   zn ns
   w result.%ToJSON(),!
   Quit $$$OK
}

ClassMethod getDisplsyList(resourceType) As %Status
{
	
	set displayList=[]
	//set resourceType=%request.Data("resourceType",1)
	//set resourceType="Patient"
	set schema = ##class(HS.FHIRServer.Schema).LoadSchema("hl7.fhir.r4.core@4.0.1")
	set name=$Order(@schema.TiGbl@(resourceType, "*rq", ""))
	while name'=""
	{
		set temp={}
		set temp.field="resource."_name
		set temp.title=name
		
		
		
		Do displayList.%Push(temp)
		set name=$Order(@schema.TiGbl@(resourceType, "*rq", name))
		
	}
	//w displayList.%ToJSON()
    Quit displayList
}

}
