# FHIR-OCR-AI

# install

 1. It is necessary to install the healthshare irisfhir server first

 2. Embedded Python requires installation

   ① Pip install pytesseract

   ② Pip install zhipuai

 3. Install Google Tesseract

  Windows: https://digi.bib.uni-mannheim.de/tesseract/

  Linux/Mac https://tesseract-ocr.github.io/tessdoc/Installation.html

 4. Create SSL/tls www.google-analytics.com
    
    ![image](https://github.com/AAdacangjiujiu/FHIR-OCR-AI/assets/144994347/83e3a39d-6f6c-49c5-a0d7-8832987e17f9)

# zpm
  imagetofhirresource

# Access address

  ip:port/csp/fhir-ocr-ai/index1.csp

# Setting

Enter the settings page first after accessing

![image](https://github.com/AAdacangjiujiu/FHIR-OCR-AI/assets/144994347/b0490e14-e8dd-4e47-aa2a-a2d24454f53c)

① : Set backend access IP and address

② : Google Bard Cookie
  Need to have an account that can access Google Bard
  
  ![image](https://github.com/AAdacangjiujiu/FHIR-OCR-AI/assets/144994347/7e4fe87b-e710-45da-a11e-d88e86e62cb7)
  
③ Zhipu's personal key https://open.bigmodel.cn/usercenter/apikeys

# How to use

![image](https://github.com/AAdacangjiujiu/FHIR-OCR-AI/assets/144994347/d670e476-af00-4fbf-8f5e-a5df8f492a7f)

① Upload relevant images or prescription forms

② : Send request

③ Obtain the text on the image, which can be manually modified

④ : Select the type of resource you want to generate

⑤ : Select AI type

⑥ Upload text information to the interface

⑦ Obtained corresponding resources, can be manually modified

⑧ : Select resource type

⑨ Sent to the fhir server, with a status code of 201 if there is no problem with the resource. If there is a problem with the resource, relevant prompts will be displayed

If the message is successfully sent

Relevant information can be queried on the select page

![image](https://github.com/AAdacangjiujiu/FHIR-OCR-AI/assets/144994347/9213eeef-a280-432b-b8a2-caee1fc859af)

① : Select resource type

② : Click on query

③ : Can view detailed information

![image](https://github.com/AAdacangjiujiu/FHIR-OCR-AI/assets/144994347/7c545033-6235-4318-af63-172022483a8a)



  
