*** Settings ***
Library     RPA.Robocorp.WorkItems
Library     String


*** Tasks ***
Work Item Handler
    For Each Input Work Item    Handle Item


*** Keywords ***
Handle Item
    TRY
        Top level keyword
        Other keyword
        Release Input Work Item    DONE
    EXCEPT    ApplicationError
        Log    app crashed, so I will fail the work item.    console=${True}
        Release Input Work Item
        ...    state=FAILED
        ...    exception_type=APPLICATION
        ...    message=App crashed
        # Skip / Fail    # If single error needs to stop processing of all items
    EXCEPT    InvalidData
        Log    got bad data, so I will fail the work item    console=${True}
        Release Input Work Item
        ...    state=FAILED
        ...    exception_type=BUSINESS
        ...    message=Bad data
    END
    [Teardown]    Reset my work environment for next work item

Top level keyword
    Log    doing some business logic    console=${True}
    ${return}=    Embedded keyword one
    IF    ${return} == 1    Embedded keyword two
    Log    did the embedded work    console=${True}

Other keyword
    Log    doing some other business logic    console=${True}
    Embedded keyword two
    Log    done doing some other business logic    console=${True}

Embedded keyword one
    Log    doing some specific part of logic that might call deeper keyword    console=${True}
    ${return}=    Generate random string    1    01
    IF    ${return} == 1
        ${deep_result}=    Deeply embedded keyword
        RETURN    ${deep_result}
    ELSE
        RETURN    ${0}
    END

Embedded keyword two
    Log    doing some standalong business logic    console=${True}
    ${test}=    Get work item variable    test
    IF    ${test} not in [0,1]    Fail    InvalidData
    Log    The work item had the value ${test} in it.    console=${True}

Deeply embedded keyword
    Log    doing some deeper part of logic    console=${True}
    ${return}=    Generate random string    1    012
    IF    ${return} == 2
        Log    I want to fail the work item now    console=${True}
        Fail    ApplicationError
    END
    RETURN    ${return}

Reset my work environment for next work item
    Log    Getting ready for next work item...    console=${True}
    Log    Ready for next work item.    console=${True}
