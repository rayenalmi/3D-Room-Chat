import http from 'http';
import app from './app';
import config from './src/config/config';
import logging from './src/config/logging';


const httpServer = http.createServer(app);
const socketIO = require('socket.io')(httpServer)

socketIO.on('connection', function (client:any) {
    console.log('Connected...', client.id);
  
  //listens for new messages coming in
    client.on('message', function name(data:any) {
      console.log(data);
      socketIO.emit('message', data);
    })
  
  //listens when a user is disconnected from the server
    client.on('disconnect', function () {
      console.log('Disconnected...', client.id);
    })
  
  //listens when there's an error detected and logs the error on the console
    client.on('error', function (err:any) {
      console.log('Error detected', client.id);
      console.log(err);
    })
  })

httpServer.listen(config.server.port, () => logging.info(config.server.hostname, `Server is runningdd ${config.server.hostname}:${config.server.port}`));