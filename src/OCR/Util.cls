Class OCR.Util Extends %CSP.REST
{

Parameter HandleCorsRequest = "true";

XData UrlMap [ XMLNamespace = "http://www.bjgoodwill.com/urlmap" ]
{
<Routes>
  <Route Url="/*" Method="OPTIONS" Call="GetStatus"/>
  <Route Url="/ImageToString" Method="POST" Call="ImageToString"/>
 <Route Url="/getFHIR" Method="POST" Call="getFHIR"/>
 <Route Url="/setzpKeys" Method="POST" Call="setzpKeys" />
  <Route Url="/setBard" Method="POST" Call="setBard" />
 
  <Route Url="/getList" Method="POST" Call="getList" />
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
	SET Array=[]
	set Sql="SELECT  ID FROM %Dictionary.ClassDefinition where ID like 'HSFHIR.X0011.S.%'"
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
    w Array.%ToJSON()
    QUIT $$$OK
}

}

