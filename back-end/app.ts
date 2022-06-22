import bodyParser from 'body-parser';
import  express from 'express';
import mongoose from 'mongoose';
import config from './src/config/config';
import logging from './src/config/logging';
import { Routes } from './src/Routes';
import cors from 'cors';

class Server {
    public app!: express.Application;
    public route: Routes = new Routes();
    public mongoUrl: string =config.mongo.url;
    private NAMESPACE = 'Server';

    constructor() {
        this.app = express();
        this.config();
        this.route.routes(this.app);
        this.mongoSetup();
    }

    
    
    private config(): void {

        this.app.use((req, res, next) => {
            /** Log the req */
            logging.info(this.NAMESPACE, `METHOD: [${req.method}] - URL: [${req.url}] - IP: [${req.socket.remoteAddress}]`);
        
            res.on('finish', () => {
                /** Log the res */
                logging.info(this.NAMESPACE, `METHOD: [${req.method}] - URL: [${req.url}] - STATUS: [${res.statusCode}] - IP: [${req.socket.remoteAddress}]`);
            })
            
            next();
        });

        /** Parse the body of the request */
                this.app.use(bodyParser.urlencoded({ extended: true }));
                this.app.use(bodyParser.json());
                this.app.use(cors());

        /** Rules of our API */
        this.app.use((req, res, next) => {
            res.header('Access-Control-Allow-Origin', '*');
            res.header('Access-Control-Allow-Headers', 'Access-Control-Allow-Origin ,Origin, X-Requested-With, Content-Type, Accept, Authorization');

            if (req.method == 'OPTIONS') {
                res.header('Access-Control-Allow-Methods', 'PUT, POST, PATCH, DELETE, GET');
                return res.status(200).json({});
            }

            next();
        });

    }

    private mongoSetup(): void {
        mongoose
    .connect(config.mongo.url, config.mongo.options)
    .then((result) => {
        logging.info(this.NAMESPACE, 'Mongo Connected');
    })
    .catch((error) => {
        logging.error(this.NAMESPACE, error.message, error);
    });
    }
    

}

export default new Server().app;