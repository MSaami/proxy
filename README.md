# Proxy Server
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)

This program is responsible for sending messages to programs such as Slack, Teamtecture, Datev


# Stack
`Rails Version 7`

`Postgres Version 15.1`

## Installation
- Install the Docker and Docker Compose in your local machine.
- Clone the project and run the below commands.
```bash
docker-compose up -d
```
The application will be live at `localhost:3000`

## Architecture

The application is written in MVC pattern.

## Components

-  `MessageSenderJob` is in charge of send a message to the third part
- `ErrorReportable` is in charge of report errors to logs
- `ReportableError` is instance of `StandardError` which is parent of our domain exceptions
- `SlackGateway` is gateway to send a message to `Slack`
- `DatevGateway` is gateway to send a message to `Datev`
- `TeamtectureGateway` is gateway to send a message to `Teamtecture`
- `GatewayFactory` is in charge of returning appropriate gateway to sending message

## Flow
-  Request will be arrived to `MessageController` and it creates a model named `message`
- There is `after_create` callback on `message` model which enqueue the message to the `MessageSenderJob`
- After 1 minute the `MessageSenderJob` perform action to publish the message to appropriate thirdparty
- `MessageSenderJob` calls `publish!` method on `message` model to publish a message
- `publish!` method on `message` calls `GatewayFactory` to get appropriate gateway
- Finally, the `publish` method on the gateway is called and publish the message to thirdparty service

All of the exceptions and logs will be stored at `log\error_report.log` path.


## Usage

- You can run the tests using `docker-compose exec app rspec`
- There is an api which is accepts 3 arguments: `file`, `gateway`, and `payload`

```bash
Create Message
Path => localhost:3000/api/v1/message
Method => POST
body: {gateway: 'slack', file: UPLOADEDFILE, payload: {caption: 'Hi'}}


Index Message
Path => localhost:3000/api/v1/message
Method => GET
response: {"data": [
        {
            "id": 27,
            "gateway": "slack",
            "payload": {
                "test": "inja"
            },
            "status": "done",
            "result": {
                "response": {
                    "status": "200",
                    "message": "Published to Slack"
                }
            },
            "created_at": "2023-06-08T15:19:49.909Z",
            "updated_at": "2023-06-08T15:19:59.926Z"
        },
        {
            "id": 26,
            "gateway": "slack",
            "payload": {
                "test": "inja"
            },
            "status": "failed",
            "result": {
                "exception_uuid": "5fed4bed-9864-4c7c-9d57-5b49fc5db140"
            },
            "created_at": "2023-06-08T15:19:04.905Z",
            "updated_at": "2023-06-08T15:20:04.927Z"
        }
    }
```

##TODO
- Prevent to publish the message has already published.
- Retry the job after failure
- improvments on error reporter to log other severity such as `warn`
- using serializer to transform data for index API
