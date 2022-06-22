import express from 'express';
import {ControllerRoom} from '../Controllers/room.controller';
import { auth } from '../middleware/auth';


export class RoomRoutes {
 public controllersRoom : ControllerRoom = new ControllerRoom();
 public auth : auth = new auth();

 public routes(app: express.Application) :void
 {
    app.post('/create/room', this.auth.verifyToken,  this.controllersRoom.createRoom);
    app.get('/getroom', this.auth.verifyToken,  this.controllersRoom.getRoomByIdOwner);
    app.put('/update/room/:id', this.controllersRoom.UpdateRoomById);
    app.get('/getrooms/:category', this.controllersRoom.getRoomByCategory);
    app.get('/getRoomById/:id',this.controllersRoom.getRoomById);
    app.delete('/delete/room/:id', this.controllersRoom.deleteRoom);
 }


}

