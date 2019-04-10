var http = require('http')

exports.handler = (event, context, callback) => {
    // TODO implement
    // callback(null, 'Hello from Lambda');
    try {
    
        if(event.session.new) {
            console.log("NEW SESSION")
        }
        
        switch(event.request.type) {
            case "LaunchRequest":
                console.log("LAUNCH REQUEST")
                var response = generateResponse(
                    buildSpeechletResponse("Welcome to Sentiment Analysis. This is an Alexa Skill. It is running on deployed lambda function. You can ask Penelope to create, update and list tasks.", true),
                    {}
                )
                console.log(response)
                context.succeed(response)
                break;
            case "IntentRequest":
                console.log("INTENT REQUEST")

                var host = "penelope.cairodigital.com.ar"

                switch(event.request.intent.name) {
                    case "CreateNewTask":
                        var taskName = getSlot("TaskName", event, "new task")
                        var taskCode = getSlot("TaskCode", event, "[new code]")
                        var body = JSON.stringify({name: taskName, code: taskCode})
                        var request = new http.ClientRequest({
                          hostname: host,
                          port: 80,
                          path: "/api/v1/tasks",
                          method: "POST",
                          headers: {
                            "Content-Type": "application/json",
                            "Content-length": Buffer.byteLength(body)
                          }
                        })
                        request.end(body)
                        request.on('response', (response) => {
                          var rbody = ""
                          console.log(response)
                          response.setEncoding('utf8');
                          response.on('data', (chunk) => {
                            rbody += chunk
                          })
                          response.on('end', () => {
                            console.log(rbody)
                            var data = JSON.parse(rbody)
                            console.log(data)
                            context.succeed(
                              generateResponse(
                                buildSpeechletResponse(`A new task has been created. Task name ${data.data.name}, code ${data.data.code} you can update the task talking to Alexa with ask Penelope to update task ${data.data.code}`, true),
                                {}
                              )
                            )
                          })
                        })
                        break;
                    case "ListTasks":
                        break;
                }
                break;
            case "SessionEndedRequest":
                console.log("SESSION ENDED REQUEST")
                break;
            
            default:
                context.fail(`INVALID REQUEST TYPE: ${event.request.type}`)
        }
        
    }
    catch(error) {context.fail(`Exception: ${error}`)}
    
    
};

buildSpeechletResponse = (outputText, shouldEndSession) => {
    return {
        outputSpeech: {
            type: "PlainText",
            text: outputText
        },
        shouldEndSession: shouldEndSession
    }
};

generateResponse = (speechletResponse, sessionAttributes) => {
    return {
        version: "string",
        sessionAttributes: sessionAttributes,
        response: speechletResponse
    }
};

getSlot = (slotName, event, defaultValue) => {
    try {
        return event.request.intent.slots[slotName].value
    }
    catch(error) {
        console.log(error)
        return defaultValue;
    }
}
