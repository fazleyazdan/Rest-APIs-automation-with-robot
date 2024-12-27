*** Comments ***
when we do post request, we will need body & headers for it
in headers we mostly pass Content-Type

since we have to send request body in json format, and the body should be in dictionary
e.g 
{
    "name" : "fazleyazdan",
    "job" : "SQA engineer"
}

we can write it in robot like this to create a dictionary: name=fazleyazdan   job=SQA Engineer


*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    RequestsLibrary

*** Variables ***
${base_url}    https://reqres.in/api

*** Test Cases ***
create user via post request
    Create Session    mysession    ${base_url}
    ${body}=    Create Dictionary    name=fazleyazdan   job=SQA Engineer
    ${header}=    Create Dictionary    Content-Type=application/json

    # Send the POST request
    ${response}=    POST On Session    mysession    /users    json=${body}    headers=${header}
    
    Log To Console    ${response.status_code}
    Log To Console    This is the response:${response.content}

    # Assertion to validate the whole response
    Should Contain    ${response.content}    fazleyazdan

    # Log the status code
    Log To Console    Status code: ${response.status_code}

    # Extract and log the response body. to put assertions on specific response first evaluate it to text
    ${response_text}=    Evaluate    ${response.text}    json
    Log To Console    Response body: ${response_text}

    # Assertions to validate the response fields
    Should Be Equal As Strings    ${response.status_code}    201
    Should Contain    ${response_text['name']}    fazleyazdan
    Should Contain    ${response_text['job']}    SQA Engineer