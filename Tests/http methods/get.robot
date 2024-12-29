*** Comments ***
this is the response body
{
    "data": {
        "id": 2,
        "email": "janet.weaver@reqres.in",
        "first_name": "Janet",
        "last_name": "Weaver",
        "avatar": "https://reqres.in/img/faces/2-image.jpg"
    },
    "support": {
        "url": "https://contentcaddy.io?utm_source=reqres&utm_medium=json&utm_campaign=referral",
        "text": "Tired of writing endless social media content? Let Content Caddy generate it for you."
    }
}

we have to use collection library as well to work with response elements. because all elements is inside the dictionary.


*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    BuiltIn

*** Variables ***
${baseurl}    https://reqres.in/api
${user_id}    2

*** Test Cases ***
Get user info
    # before sending any request first we have to create a session, you have to name it & also pass base url to it
    Create Session    mysession    ${baseurl}    verify=${True}
    
    # to send get request you have to give it session name & then the url you wanna request
    # here we have stored the response in a variable to use it further
    ${response}=    GET On Session    mysession    ${baseurl}/users/${user_id}

    # you can also do the request with relative url once the session is created with base url & no need to specify it again
    # ${response}=    GET On Session    mysession    /users/${user_id}

    Log To Console    ${response.status_code}

    # request body
    Log To Console    ${response.content}

    # request headers
    Log To Console    ${response.headers}
    

    #! Validations
    
    # first convert it to string because the response is in json format & should be equal to works with string format
    ${status_code}=    Convert To String    ${response.status_code}
    Should Be Equal    ${status_code}    200


    # Parse the JSON response content into a dictionary
    ${body}=    set variable    ${response.content}
    Should Contain    ${body}    Janet

    # validation on response headers. response headers are in dictionary format
    # here we are validating value if Content-Type header. so first we stored Content-Type value from response headers
    ${contentTypeValue}=    Get From Dictionary    ${response.headers}    Content-Type
    Should Be Equal    ${contentTypeValue}    application/json; charset=utf-8  