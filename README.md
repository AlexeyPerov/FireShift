# A simple tool for users support

![stability-wip](https://img.shields.io/badge/stability-work_in_progress-lightgrey.svg)
(currently uses mock data)

Admin part uses Flutter. API uses Nest.js & AWS Lambda.

## Nest.js AWS Lambda Setup

### Setup pre-requisites:
* [Node.js](https://nodejs.org/en/)
* [NestCLI](https://docs.nestjs.com/cli/overview)
* [Serverless](https://www.serverless.com/framework/docs/providers/aws/guide/installation/)

### Run

#### AWS credentials
* Create a user with the AWS IAM service and get its access key and secret access key
* Create .aws/credentials file
```text
mkdir .aws
cd .aws
touch credentials
open .
```
* Paste
```text
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY
```
#### Install dependencies
* Run
```text
npm install --save aws-serverless-express
npm install --save aws-lambda
npm install --save-dev serverless-plugin-typescript
npm install --save-dev serverless-plugin-optimize
npm install --save-dev serverless-offline plugin
```
* Set "Incremental" to false in tsconfig.json
#### Run
* local
```text
sls offline start
```
* deploy
```text
sls deploy -v
```
* remove
```text
serverless remove
```



