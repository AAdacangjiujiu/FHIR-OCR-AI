var fhirserverip="localhost"
fhirserverip=localStorage.getItem("fhirserverip")
console.log(fhirserverip)

function imagetotext(){

    /*$.ajax('http://localhost:52775/YSSTEST/UPDATEMESSAGE', {
        method: 'GET',
        data: {name: url,x: L,y:T},
        success:function (result) {
            console.log(result);
           
        },
        error:function (err) {
            console.log(err);
        }
    })*/
    var files = $('#file').prop('files');
    //var uploadElement = document.getElementById('file');
    //var files = uploadElement.files[0];

    var form = new FormData();
    form.append('file', files[0]);

    //console.log(file1)
    $.ajax('http://'+fhirserverip+'/OCR/Util/ImageToString', {
        method: 'POST',
        data: form,
                cache: false,
                processData: false,
                contentType: false,
                success: function (ret) {
                   // alert(ret);
                   document.getElementById("IMGTOSTRING").value = ret;
                }
    })

}

function getFHIR(){
   var question=document.getElementById("IMGTOSTRING").value
   var type=document.getElementById('resourceType').value
   var aitype=document.getElementById('AITYPE').value
    $.ajax('http://'+fhirserverip+'/OCR/Util/getFHIR', {
      
            method: 'POST',
            data: {Question:question,Type:type,aitype:aitype },
            success:function (result) {
                //console.log(result);
                document.getElementById("exampleFormControlTextarea1").value = result;
            },
            error:function (err) {
                console.log(err);
            }
        })

}
function getList(){
  
    $.ajax('http://'+fhirserverip+'/OCR/Util/getList', {
      
            method: 'POST',
            data: {},
            success:function (result) {
	            result=JSON.parse(result)
	           
	             var sel = document.getElementById("resourceType");
	             var sel2 = document.getElementById("resourceType2");
	              var sel3 = document.getElementById("resourceType3");
	             
	            for (var key in result) 
	            {
		            var opt = new Option(result[key],result[key])
		            var opt2 = new Option(result[key],result[key])
		            var opt3 = new Option(result[key],result[key])
				      sel.options.add(opt);
				       sel2.options.add(opt2);
				         sel3.options.add(opt3);
				       // sel3.options.add(opt);
		        }
               // console.log(result);
                //document.getElementById("exampleFormControlTextarea1").value = result;
                //var sel = document.getElementById("sel");
            },
            error:function (err) {
                console.log(err);
            }
        })

}
function sendFhir(){
	 var type=document.getElementById('resourceType2').value
   var fhirjson=document.getElementById("exampleFormControlTextarea1").value
   
        
        $.ajax({
	url:'http://'+fhirserverip+'/csp/healthshare/fhirserver/fhir/r4/'+type,
    type:"POST",
    dataType:"json",
    contentType: "application/fhir+json",
    data: fhirjson,
   success:function (data) {
       	//成功后执行的操作 
       	 alert("添加成功")   
       	    
   },
   error:function (data) {
       // 请求失败后执行的操作      
       alert(JSON.stringify(data))       
   }
})
}

   
     function getData()
      {
     //var data= $('#table1').bootstrapTable('getData',{useCurrentPage:true,includeHiddenRows:true});
       //alert(JSON.stringify(data));
         var type=document.getElementById('resourceType3').value
        $.ajax({
	url:'http://'+fhirserverip+'/csp/healthshare/fhirserver/fhir/r4/'+type,
    type:"GET",
    dataType:"json",
    contentType: "application/fhir+json",
    data: "",
   success:function (data) {
       	//成功后执行的操作 
       	 //alert("添加成功")    
       	 var data = data.entry;
        //bootstrap table初始化数据
       
        $("#table1").bootstrapTable('refreshOptions',{columns: columns, 
            data: data,pageNumber:1}); 
   },
   error:function (data) {
       // 请求失败后执行的操作      
      // alert(JSON.stringify(data))       
   }
})
      }
      
      
  function setzpKeys(){
	   var key1=document.getElementById('zpkey').value
	   console.log(key1)
    $.ajax('http://'+fhirserverip+'/OCR/Util/setzpKeys', {
      
            method: 'POST',
             //dataType:"json",
             // contentType: "application/json",
            data: {key1:key1 },
            success:function (result) {
                //console.log(result);
                alert("保存成功")
                //document.getElementById("exampleFormControlTextarea1").value = result;
                
            },
            error:function (err) {
                console.log(err);
            }
        })
  }
   function setBard(){
	   var key1=document.getElementById('PSID').value
	   var key2=document.getElementById('PSIDTS').value
	   
	   //console.log(key1)
    $.ajax('http://'+fhirserverip+'/OCR/Util/setBard', {
      
            method: 'POST',
             //dataType:"json",
             // contentType: "application/json",
            data: {key1:key1,key2:key2 },
            success:function (result) {
                //console.log(result);
                alert("保存成功")
                //document.getElementById("exampleFormControlTextarea1").value = result;
                
            },
            error:function (err) {
                console.log(err);
            }
        })
  }
  function saveIP(){
	  localStorage.setItem("fhirserverip", document.getElementById('fhirserverip').value);
	  alert("保存成功")
	 }

//console.log(document.getElementById('fhirserverip').value)

$(function(){ 

getList()
document.getElementById('fhirserverip').value=fhirserverip });