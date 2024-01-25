Class Bard.Util.RequestSet
{

ClassMethod GetResponsejx(line, id1, ByRef id2, ByRef id3) As %String
{
 set resultImage=[]
 //w line,!
 set LineArray=[].%FromJSON(line)

 set Array2=[].%FromJSON(LineArray.%Get(0).%Get(2))
 set id1=Array2.%Get(1).%Get(0)
 set id2=Array2.%Get(1).%Get(1)
 set resPonseArray=Array2.%Get(4).%Get(0)
 SET RCID=resPonseArray.%Get(0)
 set id3=RCID
 set responseText=resPonseArray.%Get(1).%Get(0)
 if (resPonseArray.%Get(4)'="")&&(resPonseArray.%Get(4).%Size()'=0){
 set imageArray=resPonseArray.%Get(4)
 for i=0:1:imageArray.%Size()-1
 {
	 set imageOb={}
	 set imageOb.label=imageArray.%Get(i).%Get(2)
	 set imageOb.url=imageArray.%Get(i).%Get(0).%Get(0).%Get(0)
	 set responseText=$replace(responseText,imageOb.label,imageOb.url)
	 
 }
 }
 Quit responseText
}

ClassMethod GetResponse(ByRef pRequest As %Net.HttpRequest, ByRef id1, ByRef id2, ByRef id3) As %String
{
	set out =""
	set responsedata=pRequest.HttpResponse.Data
	while 'responsedata.AtEnd
	{
		set line=responsedata.ReadLine()
		if line["[["
		{
			//W line,!
			set out=..GetResponsejx(line,.id1,.id2,.id3)
			
		    Quit 
		}
    }
    //w out,!
    Quit out
}

ClassMethod RequestSet(ByRef OutRequest As %Net.HttpRequest) As %Status
{
    set httpRequest=##class(%Net.HttpRequest).%New()	
    //-----根据需要设置代理---//
    set httpRequest.ProxyPort="15236"
    set httpRequest.ProxyServer="localhost"
    set httpRequest.ProxyHTTPS=1
    set httpRequest.ProxyTunnel=1
    Do httpRequest.SetHeader("Host","bard.google.com")
    Do httpRequest.SetHeader("X-Same-Domain", "1")
    Do httpRequest.SetHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36")
    Do httpRequest.SetHeader("Origin", "https://bard.google.com/")
    Do httpRequest.SetHeader("Connection", "keep-alive")
    Do httpRequest.SetHeader("Referer", "https://bard.google.com/")
    ////Cookie值手动从网页获取
    Do httpRequest.SetHeader("Cookie", ^FHIRBARDKEYS)
    set httpRequest.Https=1
    set httpRequest.Server="bard.google.com"
    set httpRequest.Port="443"
    ///配置SSL----
    set httpRequest.SSLConfiguration="www.google-analytics.com"
    set OutRequest=httpRequest
    Quit $$$OK
}

ClassMethod requstGet(url As %String, ByRef pRequest As %Net.HttpRequest) As %Status
{
	Do pRequest.Get(url)
}

ClassMethod requestPost(url As %String, ByRef pRequest As %Net.HttpRequest) As %Status
{
	Do pRequest.Post(url)
}

ClassMethod getSNlM0e(ByRef pRequest As %Net.HttpRequest) As %String
{
	Do ..requstGet("/",pRequest)
	set response=pRequest.HttpResponse
    set responseText= response.Data.Read()
    if (responseText["SNlM0e")
    {
	    set text=$p($p(responseText,"SNlM0e",2),",",1)
	    set text=$replace(text,"""","")
	    set text=$e(text,2,*)
	    //w text,!
    }else{
	    
	    set text= "get SNlM0e error" 
	 }
	// w text,!
	 Quit text
}

ClassMethod NoImageAsk(ByRef pRequest As %Net.HttpRequest, SNlM0e As %String, question, id1, id2, id3) As %Status
{
	set Inputstr="[null,""[[\"""_question_"\""],null,[\"""_id1_"\"",\"""_id2_"\"",\"""_id3_"\""]]""]"
	Do pRequest.SetHeader("Content-Type","application/x-www-form-urlencoded;charset=UTF-8")
	Do pRequest.InsertFormData("f.req",Inputstr)
    //w "ID:"_$e(text,2,*),!
	set pRequest.Timeout=60
	Do pRequest.InsertFormData("at",SNlM0e)
	Do pRequest.InsertParam("bl","boq_assistant-bard-web-server_20230808.09_p0")
	Do pRequest.InsertParam("_reqid",$random(1000000))
	Do pRequest.InsertParam("rt","c")
	Do ..requestPost("/_/BardChatUi/data/assistant.lamda.BardFrontendService/StreamGenerate",.pRequest)
	
	Quit $$$OK
}

}

