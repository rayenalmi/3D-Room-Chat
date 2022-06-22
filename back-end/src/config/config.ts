import dotenv from 'dotenv';

dotenv.config();

const MONGO_OPTIONS = {
    useUnifiedTopology: true,
    socketTimeoutMS: 30000,
    keepAlive: true,
    maxPoolSize: 50, 
    wtimeoutMS: 2500,
    useNewUrlParser: true,
    autoIndex: true,
    retryWrites: false
};

const MONGO_PATH = process.env.MONGO_URL || `mongodb://localhost:27017/chatroom`;

const MONGO = {
    options: MONGO_OPTIONS,
    url: MONGO_PATH
};

const SERVER_HOSTNAME = process.env.SERVER_HOSTNAME || 'localhost';
const SERVER_PORT = process.env.SERVER_PORT || 3000;

const SERVER = {
    hostname: SERVER_HOSTNAME,
    port: SERVER_PORT
};

const config = {
    mongo: MONGO,
    server: SERVER
};

export default config;