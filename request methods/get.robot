*** Settings ***
Library    RequestsLibrary

*** Variables ***
${baseurl}    https://jsonplaceholder.typicode.com/
${posts_id}    1

*** Test Cases ***
Get user posts info
    # before sending any request first we have to create a session, you have to name it & also pass base url to it
    Create Session    mysession    ${baseurl}
    
    # to send get request you have to give it session name & then the url you wanna request
    # here we have stored the response in a variable to use it further
    ${response}=    GET On Session    mysession    ${baseurl}/posts/${posts_id}
    Log To Console    ${response.status_code}

    # request body
    Log To Console    ${response.content}

    # request headers
    Log To Console    ${response.headers}
    
