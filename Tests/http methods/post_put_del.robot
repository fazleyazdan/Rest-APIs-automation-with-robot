*** Comments ***
this test file contains Post, Put & Delete requests

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
Library    OperatingSystem

*** Variables ***
${base_url}    https://reqres.in/api
${user_id}    ${None}                        # here i have initialized it with null because i will assign it value later

*** Test Cases ***
Test 1: Post request create user 
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
    Log To Console    ======================================
    Log To Console    Get Response: ${response_text}

    # Assertions to validate the response fields
    Should Be Equal As Strings    ${response.status_code}    201
    Should Contain    ${response_text['name']}    fazleyazdan
    Should Contain    ${response_text['job']}    SQA Engineer

    # assign the global variable id returned in response so we can use it other test cases
    ${user_id}=    Get From Dictionary    ${response_text}    id
    Log To Console    ${user_id}


Test 2 : Put request update user
    
    # as we have already created session we are not going to create new
    ${body}=    Create Dictionary    name=fazleyazdan    job=Lead SQA Engineer
    ${header}=    Create Dictionary    Content-Type=application/json

    ${response}=    Put Request    mysession    /users/${user_id}    json=${body}    headers=${header} 
    Log To Console    ======================================
    Log To Console    Put Response: ${response.content}

    Should Be Equal As Strings    ${response.status_code}    200

    # assert validation on individual fields
    ${response_txt}=    Evaluate    ${response.text}    json
    Log To Console    ======================================
    Log To Console    Put Response: ${response_txt}
    
    ${job}=    Get From Dictionary    ${response_txt}    job
    Should Be Equal    ${job}    Lead SQA Engineer


Test 3 : Delete user 
    ${header}=    Create Dictionary    Content-Type=application/json

    ${response}=    Delete Request    mysession    /users/${user_id} 
    Should Be Equal As Strings    ${response.status_code}    204

