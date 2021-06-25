# A simple tool for users support

The tool can be used to exchange messages with users in your applications. For example, to support users and/or collect feedback in the early stages of development.

![stability-wip](https://img.shields.io/badge/stability-work_in_progress-lightgrey.svg)

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
* Install serverless dependencies
```text
npm install --save aws-serverless-express
npm install --save aws-lambda
npm install --save-dev serverless-plugin-typescript
npm install --save-dev serverless-plugin-optimize
npm install --save-dev serverless-offline plugin
npm install --save-dev serverless
```
* Install mongose & dotenv dependencies
```text
npm install --save mongoose
npm install --save dotenv
```
* Create .env file
```text
# DB URI
MONGO_URI="mongodb+srv://[login]:[password]@[url]/[dbname]?retryWrites=true&w=majority"
 ```
* Set "Incremental" to false in tsconfig.json
#### Setup Mongo database
Any Mongo hosting is fine but for ease of use you can set up the [MongoDB Atlas](https://www.mongodb.com/) Free Tier.
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



