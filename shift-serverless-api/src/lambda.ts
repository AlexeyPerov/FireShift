import { Handler, Context } from 'aws-lambda';
import { Server } from 'http';
import { createServer, proxy } from 'aws-serverless-express';
import { eventContext } from 'aws-serverless-express/middleware';

import { NestFactory } from '@nestjs/core';
import { ExpressAdapter } from '@nestjs/platform-express';
import {AppModule} from "./app.module";
import {Logger} from "@nestjs/common";
import {mongo} from "mongoose";

require('dotenv').config()
const mongoose = require('mongoose');
const express = require('express');

const binaryMimeTypes: string[] = [];

let cachedServer: Server;

//let dbConnection = null;

async function bootstrapServer(): Promise<Server> {
 if (!cachedServer) {
    const expressApp = express();
    const nestApp = await NestFactory.create(AppModule, new ExpressAdapter(expressApp))
    nestApp.use(eventContext());
    await nestApp.init();
    cachedServer = createServer(expressApp, undefined, binaryMimeTypes);
 }
 return cachedServer;
}

export const handler: Handler = async (event: any, context: Context) => {
    context.callbackWaitsForEmptyEventLoop = false;
    const logger = new Logger('bootstrap');
    cachedServer = await bootstrapServer();

    /*if (dbConnection == null) {
        dbConnection = mongoose.createConnection(process.env.MONGO_URI,
        {
            useNewUrlParser: true,
            useUnifiedTopology: true,
            bufferCommands: false,
            bufferMaxEntries: 0,
        });

        await dbConnection;

        logger.log('connected to mongo')
    }*/

    return proxy(cachedServer, event, context, 'PROMISE').promise;
}

